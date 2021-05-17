package fambox.pro.presenter.fragment;

import android.os.Bundle;
import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;

import java.net.HttpURLConnection;
import java.util.List;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ChooseAppLanguageModel;
import fambox.pro.model.fragment.FragmentOtherModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentOtherContract;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_IS_TERM;

public class FragmentOtherPresenter extends BasePresenter<FragmentOtherContract.View>
        implements FragmentOtherContract.Presenter {

    private FragmentOtherModel mFragmentOtherModel;
    private ChooseAppLanguageModel mChooseAppLanguageModel;

    @Override
    public void viewIsReady() {
        mFragmentOtherModel = new FragmentOtherModel();
        mChooseAppLanguageModel = new ChooseAppLanguageModel();
//        String preferenceRealPin =
//                SafeYouApp.getPreference(getView().getContext())
//                        .getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
//        getView().configSwitchButton(Objects.equals(preferenceRealPin, ""));.

        checkIsNotificationEnabled();
    }

    @Override
    public void setUpLanguage(String countryCode, String locale) {
        mChooseAppLanguageModel.getLanguages(getView().getContext(),
                countryCode,
                locale,
                new NetworkCallback<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {
                                for (CountriesLanguagesResponseBody languagesResponseBody : response.body()) {
                                    if (Objects.equals(languagesResponseBody.getCode(), locale)) {
                                        getView().setLanguage(languagesResponseBody.getTitle());
                                    }
                                }
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void getProfile(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }

        getView().showProgress();
        mFragmentOtherModel.getProfile(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    if (response.body().getCountry().getImage() != null) {
                                        getView().setCountry(response.body().getCountry().getName(),
                                                response.body().getCountry().getImage());
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
    public void logout(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        mFragmentOtherModel.logout(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_ACCESS_TOKEN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_REFRESH_TOKEN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_PASSWORD);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_PHONE);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);

                                ((SafeYouApp) getView().getAppContext()).getSocket().disconnect();

                                getView().logout();
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
    public void clickTermAndCondition() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_TERM, false);
        getView().goTermAndCondition(bundle);
    }

    @Override
    public void checkIsNotificationEnabled() {
        boolean isNotificationEnabled = SafeYouApp.getPreference(getView().getContext())
                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, false);
        getView().configNotificationSwitch(isNotificationEnabled);
    }

    @Override
    public void checkNotificationStatus(boolean checked, String countryCode, String locale) {
        getView().showProgress();
        SafeYouApp.getPreference(getView().getContext())
                .setValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, checked);

        // getting FCM device token
        FirebaseInstanceId.getInstance().getInstanceId()
                .addOnCompleteListener(task -> {
                    if (checked) {
                        if (!task.isSuccessful()) {
                            Log.w("Device_token", "getInstanceId failed", task.getException());
                            if (getView() != null) {
                                getView().dismissProgress();
                            }
                            return;
                        }
                    }

                    String deviceToken = checked ? Objects.requireNonNull(task.getResult()).getToken() : "";
                    Log.i("Device_token", deviceToken);

                    mFragmentOtherModel.editProfile(getView().getAppContext(), countryCode, locale,
                            "device_token", deviceToken, new NetworkCallback<Response<Message>>() {
                                @Override
                                public void onSuccess(Response<Message> response) {
                                    if (getView() != null) {
                                        getView().dismissProgress();
                                    }
                                }

                                @Override
                                public void onError(Throwable error) {
                                    if (getView() != null) {
                                        getView().dismissProgress();
                                    }
                                }
                            });
                });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mFragmentOtherModel != null) {
            mFragmentOtherModel.onDestroy();
        }
        if (mChooseAppLanguageModel != null) {
            mChooseAppLanguageModel.onDestroy();
        }
    }
}
