package fambox.pro.audiorecordservice;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.media.MediaRecorder;
import android.os.Binder;
import android.os.CountDownTimer;
import android.os.IBinder;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import java.io.File;
import java.net.HttpURLConnection;
import java.util.List;
import java.util.Locale;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.RecordDetailsModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.ProgressRequestBodyObservable;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.TimeUtil;
import io.nlopez.smartlocation.SmartLocation;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Response;

public class AudioRecordService extends Service {
    private static final int MILLIS_IN_FUTURE = 61000;
    private static final int COUNT_DOWN_INTERVAL = 1000;
    private RecordDetailsModel mRecordDetailsModel;
    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();
    private MediaRecorder recorder;
    private static final String TAG = AudioRecordService.class.getSimpleName();
    private final static String FOREGROUND_CHANNEL_ID = "RECORD_CHANEL_SAFE_YOU";
    private NotificationManager mNotificationManager;
    private final IBinder mBinder = new LocalBinder();
    private String mRecordName;
    private File instanceRecord;
    private long mRecordDuration;
    private long recordStartTime;
    String countryCode;

    // Registered callback
    private ServiceCallback serviceCallback;
    private final CountDownTimer countDownTimer = new CountDownTimer(MILLIS_IN_FUTURE, COUNT_DOWN_INTERVAL) {

        @Override
        public void onTick(long millisUntilFinished) {
        }

        @Override
        public void onFinish() {
            if (serviceCallback != null) {
                serviceCallback.endRecord();
            }
            stopRecording(false);
        }
    };

    public AudioRecordService() {
    }

    @Override
    public void onCreate() {
        super.onCreate();
        mNotificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        SmartLocation.with(this).activity().stop();
        stopForeground(true);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        countryCode = SafeYouApp.getPreference(getApplicationContext())
                .getStringValue(Constants.Key.KEY_COUNTRY_CODE, "");
        mRecordDetailsModel = new RecordDetailsModel();
        startForeground(Constants.NOTIFICATION_ID_FOREGROUND_SERVICE, prepareNotification());
        startRecording();
        return START_NOT_STICKY;
    }

    private Notification prepareNotification() {
        // handle build version above android oreo
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.title_all);
            NotificationChannel channel = new NotificationChannel(FOREGROUND_CHANNEL_ID, name, NotificationManager.IMPORTANCE_MIN);
            channel.setImportance(NotificationManager.IMPORTANCE_LOW);
            channel.setLockscreenVisibility(Notification.VISIBILITY_SECRET);
            channel.enableVibration(false);
            mNotificationManager.createNotificationChannel(channel);
        }

        // notification builder
        NotificationCompat.Builder notificationBuilder =
                new NotificationCompat.Builder(this, FOREGROUND_CHANNEL_ID)
                        .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                        .setCategory(NotificationCompat.CATEGORY_STATUS)
                        .setContentTitle(getResources().getString(R.string.app_name))
                        .setContentText("Audio record service")
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setVisibility(NotificationCompat.VISIBILITY_PRIVATE);
        return notificationBuilder.build();
    }

    private void startRecording() {
        File soundDir = getFilesDir();
        File instanceRecordDirectory = new File(soundDir.getAbsolutePath() + File.separator + "sound");

        if (!instanceRecordDirectory.exists()) {
            if (instanceRecordDirectory.mkdirs()) {
                Log.i(TAG, "success created: ");
            }
        }

        String[] entries = instanceRecordDirectory.list();
        if (entries != null) {
            for (String s : entries) {
                File currentFile = new File(instanceRecordDirectory.getPath(), s);
                if (currentFile.delete()) {
                    Log.i(TAG, "startRecording: " + currentFile + " deleted");
                }
            }
        }

        try {
            recorder = new MediaRecorder();
            recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
            recorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
            recorder.setAudioEncoder(MediaRecorder.OutputFormat.AMR_NB);

            mRecordName = TimeUtil.getCurrentTime("yyyy-MM-dd_HH:mm:ss");
            instanceRecord = new File(instanceRecordDirectory.getAbsolutePath() + File.separator + mRecordName + ".mp3");
            recorder.setOutputFile(instanceRecord.getAbsolutePath());
            recorder.prepare();
            recorder.start();
            // start count down timer...
            countDownTimer.start();
            recordStartTime = System.currentTimeMillis();
        } catch (Exception e) {
            Log.e(TAG, "error start record: " + e.getMessage());
        }
    }

    public void sentRecord() {
        stopRecording(true);
    }

    public void stopRecording(boolean isSendFromClick) {
        countDownTimer.cancel();
        mRecordDuration = (System.currentTimeMillis() - recordStartTime) / COUNT_DOWN_INTERVAL;
        if (recorder != null) {
            recorder.stop();
            recorder.release();
            recorder = null;
            SmartLocation.with(this).location().start(location -> {
                String address = "Location not found";
                Geocoder gcd = new Geocoder(getBaseContext(), Locale.getDefault());
                try {
                    List<Address> addresses =
                            gcd.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
                    if (addresses.size() > 0) {
                        address = addresses.get(0).getAddressLine(0);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    stopService();
                }

                if (!Connectivity.isConnected(this)) {
                    stopService();
                    return;
                }

                addAudionInServer(instanceRecord, address, location.getLongitude(), location.getLatitude(), isSendFromClick);
            });
        }
    }

    private void addAudionInServer(File audioFile, String pLocation, double pLongitude, double pLatitude, boolean isSendFromClick) {
        ProgressRequestBodyObservable progressRequestBodyObservable =
                new ProgressRequestBodyObservable(audioFile, ProgressRequestBodyObservable.RequestBodyMediaType.AUDIO);
        MultipartBody.Part audio = MultipartBody.Part.createFormData("audio",
                audioFile.getName(), progressRequestBodyObservable);

        RequestBody name = createFormDataBody(mRecordName);
        RequestBody location = createFormDataBody(pLocation);
        RequestBody latitude = createFormDataBody(String.valueOf(pLatitude));
        RequestBody longitude = createFormDataBody(String.valueOf(pLongitude));
        RequestBody duration = createFormDataBody(String.valueOf(mRecordDuration));
        RequestBody date = createFormDataBody(TimeUtil.getCurrentTime("yyyy-MM-dd"));
        RequestBody time = createFormDataBody(TimeUtil.getCurrentTime("HH:mm:ss"));

        mCompositeDisposable.add(SafeYouApp.getApiService().addRecord(countryCode, LocaleHelper.getLanguage(getBaseContext()),
                audio, name, location, latitude,
                longitude, duration, date, time, false)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> listResponse) {
                        if (listResponse.isSuccessful()) {
                            if (listResponse.code() == HttpURLConnection.HTTP_OK) {
                                if (serviceCallback != null) {
                                    serviceCallback.onFileSuccessSend();
                                    serviceCallback.onRecordSaved();
                                }

                                if (isSendFromClick) {
                                    sentRecordToUsers(countryCode, LocaleHelper.getLanguage(getBaseContext()));
                                    return;
                                }
                            }
                        }
                        stopService();
                    }

                    @Override
                    public void onError(Throwable e) {
                        stopService();
                    }
                }));
    }

    public void sentRecordToUsers(String countryCode, String locale) {
        mRecordDetailsModel.getRecords(this, countryCode, locale, new NetworkCallback<Response<List<RecordResponse>>>() {
            @Override
            public void onSuccess(Response<List<RecordResponse>> response) {
                if (response.isSuccessful()) {
                    if (response.code() == HttpURLConnection.HTTP_OK) {
                        if (response.body() != null && response.body().size() >= 1) {
                            mRecordDetailsModel.sendMailRecord(AudioRecordService.this, countryCode, locale,
                                    response.body().get(0).getId(),
                                    response.body().get(0).getLongitude(),
                                    response.body().get(0).getLatitude(),
                                    new NetworkCallback<Response<Message>>() {
                                        @Override
                                        public void onSuccess(Response<Message> respo) {
                                            if (respo.isSuccessful()) {
                                                if (respo.code() == HttpURLConnection.HTTP_OK) {
                                                    if (serviceCallback != null) {
                                                        serviceCallback.onFileSuccessSend();
                                                        serviceCallback.onRecordSent(
                                                                response.body().get(0).getLocation(),
                                                                response.body().get(0).getTime(),
                                                                response.body().get(0).getDate());
                                                    }
                                                }
                                            } else {
                                                Log.i(TAG, "error: " + RetrofitUtil.getErrorMessage(respo.errorBody()));
                                            }
                                            stopService();
                                        }

                                        @Override
                                        public void onError(Throwable error) {
                                            stopService();
                                        }
                                    });
                        }
                    }
                } else {
                    stopService();
                }
            }

            @Override
            public void onError(Throwable error) {
                stopService();
            }
        });
    }

    private void stopService() {
        Log.i(TAG, "stopService: ");
        SmartLocation.with(this).location().stop();
        stopForeground(true);
        stopSelf();
    }

    private RequestBody createFormDataBody(String value) {
        return RequestBody.create(MediaType.parse(ProgressRequestBodyObservable.
                RequestBodyMediaType.TEXT.getType()), value);
    }

    public void setServiceCallback(ServiceCallback serviceCallback) {
        this.serviceCallback = serviceCallback;
    }

    // Class used for the client Binder.
    public class LocalBinder extends Binder {
        public AudioRecordService getService() {
            return AudioRecordService.this;
        }
    }

    public interface ServiceCallback {
        void onFileSuccessSend();

        void onRecordSaved();

        void onRecordSent(String name, String time, String date);

        void endRecord();
    }
}
