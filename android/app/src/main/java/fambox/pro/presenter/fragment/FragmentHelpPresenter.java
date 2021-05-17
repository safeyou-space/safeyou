package fambox.pro.presenter.fragment;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.IntentSender;
import android.location.Address;
import android.location.Geocoder;
import android.os.CountDownTimer;
import android.view.View;
import android.view.animation.LinearInterpolator;
import android.widget.ProgressBar;

import androidx.fragment.app.FragmentActivity;

import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.tasks.Task;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.util.List;
import java.util.Locale;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.enums.Types;
import fambox.pro.model.fragment.FragmentHelpModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentHelpContract;
import io.nlopez.smartlocation.SmartLocation;
import okhttp3.ResponseBody;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME_FOR_POPUP;
import static io.nlopez.smartlocation.location.providers.LocationGooglePlayServicesProvider.REQUEST_CHECK_SETTINGS;

public class FragmentHelpPresenter extends BasePresenter<FragmentHelpContract.View>
        implements FragmentHelpContract.Presenter {

    private FragmentHelpModel mFragmentHelpModel;
    private static final int MILLIS_IN_FUTURE = 3100;
    private static final int COUNT_DOWN_INTERVAL = 1000;
    private boolean isCountDownTimerStop = false;
    private boolean isRecord = false;
    private ObjectAnimator mAnimation;
    private CountDownTimer mCountDownTimer;
    private Context mContext;
    private FragmentActivity mActivityContext;

    @Override
    public void viewIsReady() {
        if (getView().getContext() != null) {
            mContext = getView().getContext();
        }
        if (getView().getActivityContext() != null) {
            mActivityContext = getView().getActivityContext();
        }
        mFragmentHelpModel = new FragmentHelpModel();
        getView().setUpPushButton();
    }

    @Override
    public void setUpDialogPopup(String countryCode, String locale) {
        if (!SafeYouApp.getPreference(getView().getContext())
                .getBooleanValue(KEY_LOG_IN_FIRST_TIME_FOR_POPUP, false)) {
            getAllServices(countryCode, locale);
            SafeYouApp.getPreference(getView().getContext()).setValue(KEY_LOG_IN_FIRST_TIME_FOR_POPUP, true);
        }
    }

    @Override
    public void setupGPS() {
        LocationRequest locationRequest = LocationRequest.create();

        //Setting priority of Location request to high
        locationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
        locationRequest.setInterval(10000);

        //5 sec Time interval for location update
        locationRequest.setFastestInterval(5000);
        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder();
        builder.addLocationRequest(locationRequest);
        builder.setNeedBle(true);
        builder.setAlwaysShow(true);

        Task<LocationSettingsResponse> task = LocationServices.getSettingsClient(mContext)
                .checkLocationSettings(builder.build());

        task.addOnSuccessListener(locationSettingsResponse -> {
            if (getView() != null) {
                getView().onLocationSuccessEnable();
            }
        });

        task.addOnFailureListener(e -> {
            if (e instanceof ResolvableApiException) {
                // Location settings are not satisfied, but this can be fixed
                // by showing the user a dialog.
                try {
                    // Show the dialog by calling startResolutionForResult(),
                    // and check the result in onActivityResult().
                    ResolvableApiException resolvable = (ResolvableApiException) e;
                    resolvable.startResolutionForResult(mActivityContext,
                            REQUEST_CHECK_SETTINGS);
                } catch (IntentSender.SendIntentException sendEx) {
                    // Ignore the error.
                }
            }
        });
    }

    @Override
    public void stopRecording() {
        if (isRecord) {
            getView().stopRecord();
            getView().setContainerMoreInfoRecListVisibility(View.VISIBLE);
            getView().setContainerCancelSend(View.INVISIBLE);
            getView().changePushButtonBackground(Types.RecordButtonType.PUSH_HOLD, 0);
            getView().setRecordTimeCounterVisibility(View.GONE);
            isRecord = false;
        }
    }

    @Override
    public void startTimerCountDown(ProgressBar recordProgress) {
        if (!isCountDownTimerStop && !isRecord) {
            mAnimation = ObjectAnimator.ofInt(recordProgress, "progress", 0, 100);
            mAnimation.setDuration(MILLIS_IN_FUTURE);
            mAnimation.setInterpolator(new LinearInterpolator());
            mAnimation.start();
            mCountDownTimer = new CountDownTimer(MILLIS_IN_FUTURE, COUNT_DOWN_INTERVAL) {
                @Override
                public void onTick(long millisUntilFinished) {
                    getView().setProgressVisibility(View.VISIBLE);
                    getView().setContainerMoreInfoRecListVisibility(View.INVISIBLE);
                    getView().setContainerCancelSend(View.INVISIBLE);
                    getView().changePushButtonBackground(Types.RecordButtonType.COUNT_DOWN,
                            ((int) millisUntilFinished / COUNT_DOWN_INTERVAL));
                }

                @Override
                public void onFinish() {
                    isCountDownTimerStop = true;
                    isRecord = true;
                    getView().setProgressVisibility(View.GONE);
                    getView().setOnClickPushButton();
                    getView().setContainerMoreInfoRecListVisibility(View.INVISIBLE);
                    getView().setContainerCancelSend(View.INVISIBLE);
                    getView().changePushButtonBackground(Types.RecordButtonType.STOP_RECORD, 0);
                    getView().setRecordTimeCounterVisibility(View.VISIBLE);
                    getView().setContainerCancelSend(View.VISIBLE);
                    getView().startRecord();
                }
            }.start();
        }
    }

    @Override
    public void configSentCancelButtons() {
        isCountDownTimerStop = false;
        isRecord = false;
        getView().setContainerMoreInfoRecListVisibility(View.VISIBLE);
        getView().setContainerCancelSend(View.INVISIBLE);
        getView().changePushButtonBackground(Types.RecordButtonType.PUSH_HOLD, 0);
        getView().setRecordTimeCounterVisibility(View.GONE);
    }

    @Override
    public void stopTimerCountDown() {
        if (mCountDownTimer != null) {
            mCountDownTimer.cancel();
            mCountDownTimer = null;
        }
        if (mAnimation != null) {
            mAnimation.cancel();
        }

        if (isCountDownTimerStop) {
            isCountDownTimerStop = false;
            return;
        }
        getView().setAppBarTextChange();
        getView().setContainerMoreInfoRecListVisibility(View.VISIBLE);
        getView().setContainerCancelSend(View.INVISIBLE);
        getView().changePushButtonBackground(Types.RecordButtonType.PUSH_HOLD, 0);
        getView().setRecordTimeCounterVisibility(View.GONE);
        getView().setProgressVisibility(View.GONE);
    }

    @Override
    public void getAllServices(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }

        mFragmentHelpModel.getAllServicesName(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    try {
                                        Type listType = new TypeToken<List<EmergencyContactsResponse>>() {
                                        }.getType();
                                        List<EmergencyContactsResponse> emergencyContactsResponses =
                                                new Gson().fromJson(response.body().string(), listType);
                                        StringBuilder stringBuilder = new StringBuilder();
                                        for (EmergencyContactsResponse s : emergencyContactsResponses) {
                                            stringBuilder.append(s.getName()).append(", ");
                                        }
                                        getView().setInfoDialogData(stringBuilder.toString());
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                }
                            } else if (response.code() == HttpURLConnection.HTTP_ACCEPTED) {
                                getView().setInfoDialogData(getView().getContext().getResources().getString(R.string.not_attached_services));
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
    public void sendHelpMessage(Context context, String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        SmartLocation.with(context).location().start(location -> {
            String address = "Location not found";
            if (context != null) {
                Geocoder gcd = new Geocoder(context, Locale.getDefault());
                try {
                    List<Address> addresses =
                            gcd.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
                    if (addresses.size() > 0) {
                        address = addresses.get(0).getAddressLine(0);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            mFragmentHelpModel.sendSms(getView().getContext(), countryCode, locale,
                    String.valueOf(location.getLongitude()),
                    String.valueOf(location.getLatitude()),
                    address,
                    new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {
                            if (response.isSuccessful()) {
                                if (response.code() == HttpURLConnection.HTTP_OK) {
                                    getView().onSmsSend();
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
        });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mFragmentHelpModel != null) {
            mFragmentHelpModel.onDestroy();
        }
        SmartLocation.with(getView().getContext()).activity().stop();
    }
}
