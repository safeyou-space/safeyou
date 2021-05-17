package fambox.pro.presenter;

import android.os.Bundle;
import android.text.Editable;
import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;

import java.net.HttpURLConnection;
import java.util.Objects;

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

import static fambox.pro.Constants.Key.KEY_ACCESS_TOKEN;
import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_REFRESH_TOKEN;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;

public class LoginWithBackPresenter extends BasePresenter<LoginWithBackContract.View> implements LoginWithBackContract.Presenter {

    private LoginWithBackModel mLoginWithBackModel;

    @Override
    public void viewIsReady() {
        mLoginWithBackModel = new LoginWithBackModel();
    }

    @Override
    public void loginRequest(String countryCode, String locale, String phoneNumber, Editable password) {
//        String phoneNumberS = Utils.getEditableToString(phoneNumber);
        String passwordS = Utils.getEditableToString(password);
        if (phoneNumber.equals("") || passwordS.equals("")) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.empty_field));
        } else {
            if (!Connectivity.isConnected(getView().getContext())) {
                getView().showErrorMessage(getView().getContext().getResources().getString(R.string.internet_connection));
                return;
            }

            getView().showProgress();

            // getting FCM device token
            FirebaseInstanceId.getInstance().getInstanceId()
                    .addOnCompleteListener(task -> {
                        if (!task.isSuccessful()) {
                            Log.w("Device_token", "getInstanceId failed", task.getException());
                            return;
                        }
                        String deviceToken = Objects.requireNonNull(task.getResult()).getToken();
                        Log.i("Device_token", deviceToken);
                        LoginBody loginBody = new LoginBody();
                        loginBody.setPhone(phoneNumber);
                        loginBody.setPassword(passwordS);
                        loginBody.setDeviceToken(deviceToken);
                        loginBody.setDeviceType("android");
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
                                                            .setValue(KEY_ACCESS_TOKEN, response.body().getAccessToken());
                                                    SafeYouApp.getPreference(getView().getContext())
                                                            .setValue(KEY_REFRESH_TOKEN, response.body().getRefreshToken());

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
//                            getView().showErrorMessage(error.getMessage());
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
