package fambox.pro.presenter;

import android.os.Bundle;
import android.text.Editable;
import android.util.Log;

import java.util.Objects;

import javax.net.ssl.HttpsURLConnection;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ForgotChangePasswordModel;
import fambox.pro.model.VerificationModel;
import fambox.pro.model.fragment.FragmentProfileModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CreateNewPasswordBody;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.VerifyPhoneResendBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.ForgotChangePassContract;
import retrofit2.Response;

public class ForgotChangePassPresenter extends BasePresenter<ForgotChangePassContract.View>
        implements ForgotChangePassContract.Presenter {

    private ForgotChangePasswordModel mForgotChangePasswordModel;
    private FragmentProfileModel mFragmentProfileModel;
    private String forgotVerifyToken;
    private String bundlePhone;

    @Override
    public void viewIsReady() {
        mForgotChangePasswordModel = new ForgotChangePasswordModel();
        mFragmentProfileModel = new FragmentProfileModel();
    }

    @Override
    public void onClickNewPass(String countryCode, String locale, String phoneNumber) {
        if (phoneNumber.equals("")) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.empty_field));
        } else if (phoneNumber.length() < 12) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.phone_min_length));
        } else {
            sendPhoneToForgotChangePassword(countryCode, locale, phoneNumber);
        }
    }

    @Override
    public void sendPhoneToForgotChangePassword(String countryCode, String locale, String phoneNumber) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.internet_connection));
            return;
        }
        mForgotChangePasswordModel.sendPhoneNumber(getView().getContext(), countryCode, locale, phoneNumber,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpsURLConnection.HTTP_CREATED) {
                                Bundle bundle = new Bundle();
                                bundle.putBoolean(Constants.Key.KEY_VERIFICATION_FOR_NEW_PASSWORD, true);
                                bundle.putString(Constants.Key.KEY_PHONE_NUMBER, phoneNumber);
                                getView().goVerificationActivity(bundle);
                            }
                        } else {
                            if (getView() != null) {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
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
    public void changePasswordWithForgot(String countryCode, String locale, String password, Editable confirmPassword) {
        String createdConfirmPassword = Utils.getEditableToString(confirmPassword);
        if (password.equals("") || createdConfirmPassword.equals("")) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.empty_field));
        } else if (!Objects.equals(password, createdConfirmPassword)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.confirm_pass_field));
        } else if (password.length() < 8 || createdConfirmPassword.length() < 8) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.min_length_8));
        }
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.internet_connection));
            return;
        }
        CreateNewPasswordBody createNewPasswordBody = new CreateNewPasswordBody();
        createNewPasswordBody.setPassword(password);
        createNewPasswordBody.setConfirm_password(createdConfirmPassword);
        createNewPasswordBody.setToken(forgotVerifyToken);
        createNewPasswordBody.setPhone(bundlePhone);
        mForgotChangePasswordModel.createNewPassword(getView().getContext(), countryCode, locale, createNewPasswordBody,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_ACCESS_TOKEN);
                            SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_REFRESH_TOKEN);
                            SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_PASSWORD);
                            SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_PHONE);
                            SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
                            SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);
                            if (response.body() != null) {
                                getView().goLoginPage();
                            }
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
    public void initBundle(Bundle bundle) {
        if (bundle != null) {
            if (bundle.getBoolean(Constants.Key.KEY_REQUEST_NEW_PASSWORD)) {
                getView().configView(
                        getView().getContext().getResources().getString(R.string.new_password),
                        getView().getContext().getResources().getString(R.string.create_new_password),
                        getView().getContext().getResources().getString(R.string.confirm_new_password));
            } else if (bundle.getBoolean(Constants.Key.KEY_CHANGE_PHONE_NUMBER)) {
                getView().configViewForPhone(getView().getContext().getResources().getString(R.string.change_phone_number),
                        getView().getContext().getResources().getString(R.string.change_phone_number), true);
            }
            forgotVerifyToken = bundle.getString(Constants.Key.KEY_FORGOT_PASSWORD_VERIFY_TOKEN);
            bundlePhone = bundle.getString(Constants.Key.KEY_PHONE_NUMBER_BUNDLE);
        }
    }

    @Override
    public void editPhoneNumber(String countryCode, String locale, String phone) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.internet_connection));
            return;
        }
        mFragmentProfileModel.editProfileServer(getView().getContext(), countryCode, locale, "phone", phone,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpsURLConnection.HTTP_ACCEPTED) {
                                Bundle bundle = new Bundle();
                                bundle.putString(Constants.Key.KEY_PHONE_NUMBER, phone);
                                bundle.putBoolean(Constants.Key.KEY_CHANGE_PHONE_NUMBER_BOOLEAN, true);
                                getView().goVerificationActivity(bundle);
                            }
                        } else {
                            if (getView() != null) {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }
}
