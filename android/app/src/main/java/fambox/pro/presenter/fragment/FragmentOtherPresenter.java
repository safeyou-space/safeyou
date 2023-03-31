package fambox.pro.presenter.fragment;

import static fambox.pro.Constants.Key.KEY_IS_ABOUT_US;

import android.os.Bundle;
import android.util.Log;

import java.net.HttpURLConnection;
import java.util.List;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ChooseAppLanguageModel;
import fambox.pro.model.fragment.FragmentOtherModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ConsultantRequestResponse;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentOtherContract;
import me.pushy.sdk.Pushy;
import me.pushy.sdk.util.exceptions.PushyException;
import retrofit2.Response;

public class FragmentOtherPresenter extends BasePresenter<FragmentOtherContract.View>
        implements FragmentOtherContract.Presenter {

    private FragmentOtherModel mFragmentOtherModel;
    private ChooseAppLanguageModel mChooseAppLanguageModel;

    @Override
    public void viewIsReady() {
        mFragmentOtherModel = new FragmentOtherModel();
        mChooseAppLanguageModel = new ChooseAppLanguageModel();

        checkIsNotificationEnabled();
        checkIsDarkModeEnabled();
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
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }

        getView().showProgress();
        mFragmentOtherModel.getProfile(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (getView() != null) {
                            if (response.isSuccessful()) {
                                if (response.code() == HttpURLConnection.HTTP_OK) {
                                    if (response.body() != null) {
                                        if (response.body().getCountry().getImage() != null) {
                                            getView().setCountry(response.body().getCountry().getName(),
                                                    response.body().getCountry().getImage());
                                        }
                                        List<ConsultantRequestResponse> consultantRequestResponse
                                                = response.body().getConsultantRequest();
                                        if (consultantRequestResponse != null && consultantRequestResponse.size() > 0) {
                                            ConsultantRequestResponse consultantRequest = consultantRequestResponse.get(0);
                                            getView().configConsultantRequest(consultantRequest.getStatus());
                                        } else {
                                            getView().configConsultantRequest(-1);
                                        }
                                    }
                                }
                            } else {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }

                            getView().dismissProgress();
                        }
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
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        mFragmentOtherModel.logout(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_PASSWORD);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_PHONE);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_ID);

                                ((SafeYouApp) getView().getAppContext()).getSocket().disconnect();
                                ((SafeYouApp) getView().getAppContext()).getChatSocket("").disconnect();

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
    public void deleteAccount(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        mFragmentOtherModel.deleteAccount(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_PASSWORD);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_PHONE);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);
                                SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_ID);

                                ((SafeYouApp) getView().getAppContext()).getSocket().disconnect();
                                ((SafeYouApp) getView().getAppContext()).getChatSocket("").disconnect();

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
    public void clickAboutUs() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_ABOUT_US, true);
        getView().goWebViewActivity(bundle);
    }

    @Override
    public void checkIsNotificationEnabled() {
        boolean isNotificationEnabled = SafeYouApp.getPreference(getView().getContext())
                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, false);
        getView().configNotificationSwitch(isNotificationEnabled);
    }

    @Override
    public void checkIsDarkModeEnabled() {
        boolean isNotificationEnabled = SafeYouApp.getPreference(getView().getContext())
                .getBooleanValue(Constants.Key.KEY_IS_DARK_MODE_ENABLED, false);
        getView().configDarkModeSwitch(isNotificationEnabled);
    }

    @Override
    public void checkNotificationStatus(boolean checked, String countryCode, String locale) {
        getView().showProgress();
        SafeYouApp.getPreference(getView().getContext())
                .setValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, checked);
        new Thread(() -> {
            try {
                String deviceToken = Pushy.register(getView().getContext());
                if (getView() == null) {
                    return;
                }
                if (checked) {
                    if (deviceToken.isEmpty()) {
                        Log.w("Device_token", "getInstanceId failed");
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                        return;
                    }
                }

                deviceToken = checked ? deviceToken : "";

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
            } catch (PushyException e) {
                Log.w("Device_token", "getInstanceId failed", e);
                if (getView() != null) {
                    getView().dismissProgress();
                }
            }
        }).start();

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
