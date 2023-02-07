package fambox.pro.presenter;

import static fambox.pro.Constants.Key.KEY_BIRTHDAY;
import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_USER_ID;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;

import android.os.Bundle;
import android.text.Editable;
import android.util.Log;

import com.google.firebase.messaging.FirebaseMessaging;

import java.net.HttpURLConnection;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.LoginWithBackModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.Utils;
import fambox.pro.view.LoginWithBackContract;
import retrofit2.Response;

public class LoginWithBackPresenter extends BasePresenter<LoginWithBackContract.View> implements LoginWithBackContract.Presenter {

    private LoginWithBackModel mLoginWithBackModel;

    @Override
    public void viewIsReady() {
        mLoginWithBackModel = new LoginWithBackModel();
    }

    @Override
    public void loginRequest(String countryCode, String locale, String phoneNumber, Editable password) {
        String passwordS = Utils.getEditableToString(password);
        if (phoneNumber.equals("") || passwordS.equals("")) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.empty_field));
        } else {
            if (!Connectivity.isConnected(getView().getContext())) {
                getView().showErrorMessage(getView().getContext().getResources().getString(R.string.check_internet_connection_text_key));
                return;
            }

            getView().showProgress();

            // getting FCM device token
            FirebaseMessaging.getInstance().getToken()
                    .addOnCompleteListener(task -> {
                        if (!task.isSuccessful()) {
                            Log.w("Device_token", "getInstanceId failed", task.getException());
                            return;
                        }
                        String deviceToken = Objects.requireNonNull(task.getResult());
                        LoginBody loginBody = new LoginBody();
                        loginBody.setPhone(phoneNumber);
                        loginBody.setPassword(passwordS);
                        boolean isNotificationEnabled = SafeYouApp.getPreference(getView().getContext())
                                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, true);
                        if (isNotificationEnabled) {
                            loginBody.setDeviceToken(deviceToken);
                            loginBody.setDeviceType("android");
                            SafeYouApp.getPreference(getView().getContext())
                                    .setValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, true);
                        }
                        mLoginWithBackModel.login(getView().getContext(), countryCode, locale,
                                loginBody, new NetworkCallback<Response<LoginResponse>>() {
                                    @Override
                                    public void onSuccess(Response<LoginResponse> response) {
                                        if (response.isSuccessful()) {
                                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                                if (response.body() != null) {
                                                    SafeYouApp.getPreference(getView().getContext())
                                                            .setValue(KEY_USER_PHONE, phoneNumber);
                                                    SafeYouApp.getPreference(getView().getContext())
                                                            .setValue(KEY_PASSWORD, passwordS);
                                                    SafeYouApp.getPreference(getView().getContext())
                                                            .setValue(KEY_USER_ID, response.body().getId());
                                                    SafeYouApp.getPreference(getView().getContext())
                                                            .setValue(KEY_BIRTHDAY, response.body().getBirthday());

                                                    Log.i("login", "onSuccess: ");
                                                    getView().goDualPinScreen();
                                                }
                                            } else if (response.code() == HttpURLConnection.HTTP_ACCEPTED) {
                                                getView().showSuccessMessage(getView().getContext().getResources().getString(R.string.verify_phone_number));
                                                Bundle bundle = new Bundle();
                                                bundle.putBoolean("is_verify_again", true);
                                                bundle.putString("verify_again", phoneNumber);
                                                getView().verify(bundle);
                                            }
                                            getView().dismissProgress();
                                        }
                                        getView().dismissProgress();
                                    }

                                    @Override
                                    public void onError(Throwable error) {
                                        getView().dismissProgress();
                                    }
                                });
                    });
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mLoginWithBackModel != null) {
            mLoginWithBackModel.onDestroy();
        }
    }
}
