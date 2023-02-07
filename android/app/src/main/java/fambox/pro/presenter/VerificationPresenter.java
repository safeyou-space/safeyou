package fambox.pro.presenter;

import static fambox.pro.Constants.Key.KEY_BIRTHDAY;
import static fambox.pro.Constants.Key.KEY_PHONE_NUMBER;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;
import static fambox.pro.Constants.Key.KEY_VERIFICATION_FOR_NEW_PASSWORD;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;

import com.google.firebase.messaging.FirebaseMessaging;

import java.net.HttpURLConnection;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.DualPinModel;
import fambox.pro.model.ForgotChangePasswordModel;
import fambox.pro.model.VerificationModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ForgotVerifySmsResponse;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.VerifyPhoneBody;
import fambox.pro.network.model.VerifyPhoneResendBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.VerificationContract;
import retrofit2.Response;

public class VerificationPresenter extends BasePresenter<VerificationContract.View>
        implements VerificationContract.Presenter {

    private static final int MILLIS_IN_FUTURE = 51000;
    private static final int COUNT_DOWN_INTERVAL = 1000;
    private static final int OTP_CODE_LENGTH = 6;

    private VerificationModel mVerificationModel;
    private ForgotChangePasswordModel mForgotChangePasswordModel;
    private DualPinModel mDualPinModel;
    private boolean navigateView;
    private String phone;
    private String mPhoneNumber;
    private ForgotVerifySmsResponse mForgotVerifySmsResponse;
    private boolean isPhone;
    private boolean isVerifyAgain;
    private final CountDownTimer mCountDownTimer = new CountDownTimer(MILLIS_IN_FUTURE, COUNT_DOWN_INTERVAL) {
        @Override
        public void onTick(long millisUntilFinished) {
            getView().resendCountDownTimer(getView().getContext().getResources()
                    .getString(R.string.verify_count_down, String.valueOf(millisUntilFinished / COUNT_DOWN_INTERVAL)));
        }

        @Override
        public void onFinish() {
            getView().resendButtonActivation(true, getView().getContext()
                    .getResources().getColor(R.color.textPurpleColor));
        }
    };

    @Override
    public void viewIsReady() {
        mVerificationModel = new VerificationModel();
        mForgotChangePasswordModel = new ForgotChangePasswordModel();
        mDualPinModel = new DualPinModel();
        getView().setUpEditTextOTP();

        mPhoneNumber = SafeYouApp.getPreference(getView().getContext()).getStringValue(KEY_USER_PHONE, "");

        if (!navigateView) {
            getView().setVerificationNumber(getView().getContext().getResources()
                    .getString(R.string.otp_info_text_key, mPhoneNumber));
        }

        resentCountDownTimerInit();
    }

    @Override
    public void initBundle(Bundle bundle, String countryCode, String locale) {
        if (bundle != null) {
            navigateView = bundle.getBoolean(KEY_VERIFICATION_FOR_NEW_PASSWORD);
            phone = bundle.getString(KEY_PHONE_NUMBER);
            getView().setVerificationNumber(getView().getContext().getResources()
                    .getString(R.string.otp_info_text_key, phone));
            isPhone = bundle.getBoolean(Constants.Key.KEY_CHANGE_PHONE_NUMBER_BOOLEAN);
            if (isPhone) {
                getView().configNextButton(getView().getContext().getResources().getString(R.string.verify));
            }

            isVerifyAgain = bundle.getBoolean("is_verify_again");
            mPhoneNumber = bundle.getString("verify_again");
            if (isVerifyAgain) {
                getView().setVerificationNumber(getView().getContext().getResources()
                        .getString(R.string.otp_info_text_key, mPhoneNumber));
                resentActivationCode(countryCode, locale);
            }
        }
    }

    @Override
    public void verification(String countryCode, String locale, Editable verificationCode) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        VerifyPhoneBody verifyPhoneBody = new VerifyPhoneBody();
        if (navigateView) {
            verifyPhoneBody.setPhone(phone);
            verifyPhoneBody.setCode(verificationCode.toString());
            verificationForgotPin(countryCode, locale, verificationCode, verifyPhoneBody);
        } else if (isPhone) {
            verifyPhoneBody.setPhone(phone);
            verifyPhoneBody.setCode(verificationCode.toString());
            verificationChangedPhone(countryCode, locale, verificationCode, verifyPhoneBody);
        } else {
            verifyPhoneBody.setPhone(mPhoneNumber);
            verifyPhoneBody.setCode(verificationCode.toString());
            verificationRegistration(countryCode, locale, verificationCode, verifyPhoneBody);
        }

    }

    @Override
    public void verificationChangedPhone(String countryCode, String locale, Editable verificationCode, VerifyPhoneBody verifyPhoneBody) {
        mVerificationModel.verificationChangedPhone(getView().getContext(), countryCode, locale, verifyPhoneBody,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                if (response.code() == HttpURLConnection.HTTP_OK) {
                                    getView().goToMainActivity();
                                } else if (response.code() == HttpURLConnection.HTTP_ACCEPTED) {
                                    getView().showErrorMessage(response.body().getMessage());
                                }
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void verificationForgotPin(String countryCode, String locale, Editable verificationCode, VerifyPhoneBody verifyPhoneBody) {
        mVerificationModel.verificationForgotRequest(getView().getContext(), countryCode, locale, verifyPhoneBody,
                new NetworkCallback<Response<ForgotVerifySmsResponse>>() {
                    @Override
                    public void onSuccess(Response<ForgotVerifySmsResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                if (response.code() == HttpURLConnection.HTTP_OK) {
                                    getView().showSuccessMessage(response.body().getMessage());
                                    mForgotVerifySmsResponse = response.body();
                                    initBundleNavigateViews(countryCode, locale);
                                } else if (response.code() == HttpURLConnection.HTTP_ACCEPTED) {
                                    getView().showSuccessMessage(response.body().getMessage());
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
    public void verificationRegistration(String countryCode, String locale, Editable verificationCode,
                                         VerifyPhoneBody verifyPhoneBody) {
        mVerificationModel.verificationRequest(getView().getContext(), countryCode, locale, verifyPhoneBody,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                if (response.code() == HttpURLConnection.HTTP_OK) {
                                    getView().showSuccessMessage(response.body().getMessage());
                                    initBundleNavigateViews(countryCode, locale);
                                } else if (response.code() == HttpURLConnection.HTTP_ACCEPTED) {
                                    getView().showSuccessMessage(response.body().getMessage());
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
    public void resentActivationCode(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        resentCountDownTimerInit();
        if (navigateView) {
            mForgotChangePasswordModel.sendPhoneNumber(getView().getContext(), countryCode, locale, phone,
                    new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {
                            if (!response.isSuccessful()) {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }

                        @Override
                        public void onError(Throwable error) {
                            getView().showErrorMessage(error.getMessage());
                        }
                    });
        } else if (isPhone) {
            VerifyPhoneResendBody verifyPhoneResendBody = new VerifyPhoneResendBody();
            verifyPhoneResendBody.setPhone(phone);
            mVerificationModel.resendVerificationCode(getView().getContext(), countryCode, locale,
                    verifyPhoneResendBody, new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {
                            if (!response.isSuccessful()) {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }

                        @Override
                        public void onError(Throwable error) {
                            getView().showErrorMessage(error.getMessage());
                        }
                    });
        } else {
            VerifyPhoneResendBody verifyPhoneResendBody = new VerifyPhoneResendBody();
            verifyPhoneResendBody.setPhone(mPhoneNumber);
            mVerificationModel.verificationRequestResend(getView().getContext(), countryCode, locale,
                    verifyPhoneResendBody, new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {
                            if (!response.isSuccessful()) {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }

                        @Override
                        public void onError(Throwable error) {
                            getView().showErrorMessage(error.getMessage());
                        }
                    });
        }

    }

    @Override
    public TextWatcher otpTextWatcher() {
        return new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == OTP_CODE_LENGTH) {
                    getView().signUpButtonActivation(true, getView().getContext()
                            .getResources().getColor(R.color.textPurpleColor));
                } else {
                    getView().signUpButtonActivation(false, getView().getContext()
                            .getResources().getColor(R.color.gray));
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        };
    }

    private void initBundleNavigateViews(String countryCode, String locale) {
        if (navigateView) {
            Bundle bundle = new Bundle();
            bundle.putBoolean(Constants.Key.KEY_REQUEST_NEW_PASSWORD, true);
            if (mForgotVerifySmsResponse != null) {
                bundle.putString(Constants.Key.KEY_FORGOT_PASSWORD_VERIFY_TOKEN, mForgotVerifySmsResponse.getToken());
            }
            bundle.putString(Constants.Key.KEY_PHONE_NUMBER_BUNDLE, phone);
            getView().goNewPassword(bundle);
        } else if (isVerifyAgain) {
            getView().goBack();
        } else {
            login(countryCode, locale);
        }
    }

    private void resentCountDownTimerInit() {
        getView().resendButtonActivation(false, getView().getContext().getResources().getColor(R.color.gray));
        mCountDownTimer.start();
    }

    private void login(String countryCode, String locale) {
        LoginBody loginBody = new LoginBody();
        loginBody.setPhone(SafeYouApp.getPreference(getView().getContext())
                .getStringValue(Constants.Key.KEY_USER_PHONE, ""));
        loginBody.setPassword(SafeYouApp.getPreference(getView().getContext())
                .getStringValue(Constants.Key.KEY_PASSWORD, ""));
        FirebaseMessaging.getInstance().getToken()
                .addOnCompleteListener(task -> {
                    if (!task.isSuccessful()) {
                        Log.w("Device_token", "getInstanceId failed", task.getException());
                        return;
                    }
                    String deviceToken = Objects.requireNonNull(task.getResult());
                    boolean isNotificationEnabled = SafeYouApp.getPreference(getView().getContext())
                            .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, true);
                    if (isNotificationEnabled) {
                        loginBody.setDeviceToken(deviceToken);
                        loginBody.setDeviceType("android");
                        SafeYouApp.getPreference(getView().getContext())
                                .setValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, true);
                    }
                    mDualPinModel.loginRequest(getView().getContext(), countryCode, locale, loginBody,
                            new NetworkCallback<Response<LoginResponse>>() {
                                @Override
                                public void onSuccess(Response<LoginResponse> response) {
                                    if (response.isSuccessful()) {
                                        if (response.code() == HttpURLConnection.HTTP_OK) {
                                            if (response.body() != null) {
                                                SafeYouApp.getPreference(getView().getContext())
                                                        .setValue(KEY_BIRTHDAY, response.body().getBirthday());
                                                getView().goMainActivity();
                                            }
                                        }
                                    } else {
                                        getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                                        getView().goLoginPage();
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
        if (mVerificationModel != null) {
            mVerificationModel.onDestroy();
        }

        mCountDownTimer.cancel();
    }

}
