package fambox.pro.presenter;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.widget.SeekBar;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.Random;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.audiowaveview.AudioWaveView;
import fambox.pro.model.RecordDetailsModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.RecordDetailsContract;
import retrofit2.Response;

public class RecordDetailsPresenter extends BasePresenter<RecordDetailsContract.View>
        implements RecordDetailsContract.Presenter {

    private ArrayList<Integer> recordIdsList = new ArrayList<>();
    private int recordCurrentIndex;
    private RecordDetailsModel mRecordDetailsModel;
    private Handler mHandler = new Handler();
    private AudioWaveView mAudioWaveView;
    private MediaPlayer mMediaPlayer;
    private boolean mIsTrackCompleted;
    private long currentRecordId;
    private String longitude;
    private String latitude;
    private String mName;
    private String mTime;
    private String mDate;
    private Runnable mTarget = new Runnable() {
        @Override
        public void run() {
            if (mMediaPlayer != null) {
                try {
                    int percent = (int) Utils.percentageCalculator(
                            mMediaPlayer.getCurrentPosition(),
                            mMediaPlayer.getDuration(),
                            Utils.PercentageType.NUMBER_TO_PERCENTAGE);
                    if (percent >= 0 && percent <= 100) {
                        mAudioWaveView.setProgress(percent);
                    }
                    // get current position and update view.
                    getView().setRecCurrentPosition(Utils.millisecondsToMinute(mMediaPlayer.getCurrentPosition()));
                } catch (Exception ignore) {
                }
            }
            mHandler.postDelayed(this, 200);
        }
    };

    @Override
    public void initView() {
        mRecordDetailsModel = new RecordDetailsModel();
    }

    @Override
    public void initBundle(Bundle bundle, String countryCode, String locale) {
        if (bundle != null) {
            int recordId = (int) bundle.getLong("record_id");
            getRecord(countryCode, locale, recordId);
            recordIdsList = bundle.getIntegerArrayList("all_record_ids");
            if (recordIdsList != null) {
                recordCurrentIndex = recordIdsList.indexOf(recordId);
                if (recordIdsList.size() == 1) {
                    getView().configNextPreviewsButtons(false, false);
                } else if (recordCurrentIndex == 0) {
                    getView().configNextPreviewsButtons(true, false);
                } else if (recordCurrentIndex == recordIdsList.size() - 1) {
                    getView().configNextPreviewsButtons(false, true);
                }
            } else {
                getView().configNextPreviewsButtons(false, false);
            }
        }
    }

    @Override
    public void viewIsReady() {
    }

    @Override
    public void setUpMediaPlayer(String path) {
        Uri uri = Uri.parse(path);
        mMediaPlayer = new MediaPlayer();
        try {
            mMediaPlayer.setDataSource(getView().getContext(), uri);
            mMediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mMediaPlayer.prepare();
        } catch (IOException e) {
            e.printStackTrace();
        }
        getView().setRecDuration(Utils.millisecondsToMinute(mMediaPlayer.getDuration()));
        getView().onWaveChanged(mMediaPlayer);

        mMediaPlayer.setOnCompletionListener(mp -> {
            getView().onPlayButtonChanged(false);
            mIsTrackCompleted = true;
        });
    }

    @Override
    public void play(Activity activity) {
        if (mMediaPlayer != null) {
            activity.runOnUiThread(mTarget);
            mMediaPlayer.start();
        }
    }

    @Override
    public void pause() {
        if (mMediaPlayer != null) {
            mMediaPlayer.pause();
        }
    }

    @Override
    public void repeat(Activity activity) {
        if (mMediaPlayer != null && mIsTrackCompleted) {
            if (mHandler == null) {
                activity.runOnUiThread(mTarget);
            }
            mMediaPlayer.start();
            getView().onPlayButtonChanged(true);
            mIsTrackCompleted = false;
        }
    }

    @Override
    public void setUpWaveView(AudioWaveView audioWaveView) {
        this.mAudioWaveView = audioWaveView;
        audioWaveView.setRawData(byteArray());
    }

    @Override
    public void setUpMediaVolume(Activity activity, SeekBar seekBarVolume) {
        activity.setVolumeControlStream(AudioManager.STREAM_MUSIC);
        AudioManager audioManager = (AudioManager) activity.getSystemService(Context.AUDIO_SERVICE);
        seekBarVolume.setMax(audioManager
                .getStreamMaxVolume(AudioManager.STREAM_MUSIC));
        seekBarVolume.setProgress(audioManager
                .getStreamVolume(AudioManager.STREAM_MUSIC));
        getView().onVolumeChanged(audioManager);
    }

    @Override
    public void googleMapReady() {
        getView().configMapPosition(mName,
                Utils.convertStringToDuple(latitude),
                Utils.convertStringToDuple(longitude));
    }

    @Override
    public void getRecord(String countryCode, String locale, long recordId) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        mRecordDetailsModel.getSingleRecord(getView().getContext(), countryCode, locale, recordId,
                new NetworkCallback<Response<RecordResponse>>() {
                    @Override
                    public void onSuccess(Response<RecordResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    currentRecordId = response.body().getId();
                                    longitude = response.body().getLongitude();
                                    latitude = response.body().getLatitude();
                                    mName = response.body().getLocation();
                                    mTime = response.body().getTime();
                                    mDate = response.body().getDate();
                                    getView().setUpRecord(response.body());
                                    setUpMediaPlayer(Constants.BASE_URL.concat(response.body().getUrl()));
                                    googleMapReady();
                                    if (recordIdsList != null) {
                                        if (recordCurrentIndex == 0) {
                                            getView().configNextPreviewsButtons(true, false);
                                        } else if (recordCurrentIndex == recordIdsList.size() - 1) {
                                            getView().configNextPreviewsButtons(false, true);
                                        }
                                    }
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void sendRecord(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        getView().showProgress();
        mRecordDetailsModel.sendMailRecord(getView().getContext(), countryCode, locale, currentRecordId, longitude, latitude,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                getView().showDialogSuccessSent(mName, mTime, mDate);
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void deleteRecord(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        mRecordDetailsModel.deleteRecord(getView().getContext(), countryCode, locale, currentRecordId,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    getView().showErrorMessage(response.body().getMessage());
                                    getView().back();
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void onStop() {
        if (mMediaPlayer != null) {
            mMediaPlayer.pause();
            getView().onPlayButtonChanged(false);
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mHandler != null) {
            mHandler.removeCallbacks(mTarget, null);
        }

        if (mMediaPlayer != null) {
            mMediaPlayer.release();
            mMediaPlayer = null;
        }

        if (mRecordDetailsModel != null) {
            mRecordDetailsModel.onDestroy();
        }
        getView().dismissProgress();
    }

    private byte[] byteArray() {
        final Random random = new Random();
        final byte[] data = new byte[2048 * 200];
        random.nextBytes(data);
        return data;
    }

    @Override
    public void onClickPreview(String countryCode, String locale) {
        if (recordCurrentIndex > 0) {
            recordCurrentIndex--;
            getView().configNextPreviewsButtons(true, true);
            getRecord(countryCode, locale, recordIdsList.get(recordCurrentIndex));
        } else {
            getView().configNextPreviewsButtons(true, false);
        }
    }

    @Override
    public void onClickNext(String countryCode, String locale) {
        if (recordCurrentIndex != recordIdsList.size() - 1) {
            recordCurrentIndex++;
            getView().configNextPreviewsButtons(true, true);
            getRecord(countryCode, locale, recordIdsList.get(recordCurrentIndex));
        } else {
            getView().configNextPreviewsButtons(false, true);
        }
    }
}
