package fambox.pro.presenter.fragment;

import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME_FOR_POPUP;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.os.CountDownTimer;
import android.provider.Settings;
import android.view.View;
import android.view.animation.LinearInterpolator;
import android.widget.ProgressBar;

import androidx.fragment.app.FragmentActivity;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.text.Normalizer;
import java.util.List;
import java.util.Locale;

import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.location.AndroidLocationProvider;
import fambox.pro.location.LocationProvider;
import fambox.pro.enums.Types;
import fambox.pro.model.fragment.FragmentHelpModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentHelpContract;
import okhttp3.ResponseBody;
import retrofit2.Response;

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
    private LocationProvider mLocationProvider;

    @Override
    public void viewIsReady() {
        if (getView().getContext() != null) {
            mContext = getView().getContext();
        }
        if (getView().getActivityContext() != null) {
            mActivityContext = getView().getActivityContext();
        }
        if (mContext != null) {
            mLocationProvider = new AndroidLocationProvider(mContext);
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
        // Standard Android location settings, available without Play Services.
        if (mContext != null && AndroidLocationProvider.isLocationEnabled(mContext)) {
            if (getView() != null) {
                getView().onLocationSuccessEnable();
            }
        } else if (mActivityContext != null) {
            // The user must return to Safe YOU and hold the SOS button again.
            mActivityContext.startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
        }
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
                    .getResources().getString(R.string.check_internet_connection_text_key));
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
    public void getProfile(String countryCode, String locale) {
        mFragmentHelpModel.getProfile(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    getView().setUpEmergencyButtons(response.body().getEmergency_contacts().size() > 0,
                                            response.body().getEmergencyServices().size() > 0,
                                            response.body().getCheck_police() > 0,
                                            response.body().getRecords().size() > 0);
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
    public void sendHelpMessage(Context context, String countryCode, String locale) {
        if (getView() == null || context == null) return;
        if (!Connectivity.isConnected(context)) {
            getView().showErrorMessage(context.getString(R.string.check_internet_connection_text_key));
            return;
        }
        if (mLocationProvider == null) {
            getView().showErrorMessage("Location unavailable. Please try again.");
            return;
        }
        mLocationProvider.getCurrentLocation(new LocationProvider.Callback() {
            @Override
            public void onLocationAvailable(Location location) {
                if (getView() == null) return;
                String address = "Location not found";
                Geocoder geocoder = new Geocoder(context, Locale.getDefault());
                try {
                    List<Address> addresses = geocoder.getFromLocation(
                            location.getLatitude(), location.getLongitude(), 1);
                    if (addresses != null && !addresses.isEmpty()) {
                        address = addresses.get(0).getAddressLine(0);
                    }
                } catch (Exception ignored) {
                    // Send the available coordinates even if reverse geocoding fails.
                }
                address = Normalizer.normalize(address, Normalizer.Form.NFKD)
                        .replaceAll("\\p{M}", "");
                mFragmentHelpModel.sendSms(context, countryCode, LocaleHelper.getLanguage(context),
                        String.valueOf(location.getLongitude()),
                        String.valueOf(location.getLatitude()),
                        address,
                        new NetworkCallback<Response<Message>>() {
                            @Override
                            public void onSuccess(Response<Message> response) {
                                if (getView() == null) return;
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
                                if (getView() != null) {
                                    getView().showErrorMessage(error.getMessage());
                                }
                            }
                        });
            }

            @Override
            public void onLocationUnavailable() {
                if (getView() != null) {
                    getView().showErrorMessage("Location unavailable. Please enable location and try again.");
                }
            }
        });
    }

    @Override
    public void destroy() {
        if (mLocationProvider != null) {
            mLocationProvider.cancel();
        }
        super.destroy();
        if (mFragmentHelpModel != null) {
            mFragmentHelpModel.onDestroy();
        }
    }
}
