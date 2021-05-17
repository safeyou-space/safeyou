package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;

import androidx.annotation.ColorLong;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ForgotVerifySmsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.VerifyPhoneBody;
import fambox.pro.network.model.VerifyPhoneResendBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface VerificationContract {

    interface View extends MvpView {
        void goNewPassword(Bundle bundle);

        void setUpEditTextOTP();

        void goDualPin();

        void goMainActivity();

        void goLoginPage();

        void setVerificationNumber(String number);

        void resendCountDownTimer(String time);

        void resendButtonActivation(boolean isClick, @ColorLong int color);

        void signUpButtonActivation(boolean isClick, @ColorLong int color);

        void configNextButton(String btnText);

        void goToMainActivity();

        void goBack();
    }

    interface Presenter extends MvpPresenter<VerificationContract.View> {
        void initBundle(Bundle bundle, String countryCode, String locale);

        void verification(String countryCode, String locale, Editable verificationCode);

        void verificationForgotPin(String countryCode, String locale, Editable verificationCode, VerifyPhoneBody verifyPhoneBody);

        void verificationRegistration(String countryCode, String locale, Editable verificationCode, VerifyPhoneBody verifyPhoneBody);

        void resentActivationCode(String countryCode, String locale);

        void verificationChangedPhone(String countryCode, String locale, Editable verificationCode, VerifyPhoneBody verifyPhoneBody);

        TextWatcher otpTextWatcher();
    }

    interface Model extends BaseModel {
        void verificationRequest(Context context,
                                 String countryCode,
                                 String locale,
                                 VerifyPhoneBody verifyPhoneBody,
                                 NetworkCallback<Response<Message>> response);

        void verificationRequestResend(Context context,
                                       String countryCode,
                                       String locale,
                                       VerifyPhoneResendBody verifyPhoneResendBody,
                                       NetworkCallback<Response<Message>> response);

        void resendVerificationCode(Context context,
                                       String countryCode,
                                       String locale,
                                       VerifyPhoneResendBody verifyPhoneResendBody,
                                       NetworkCallback<Response<Message>> response);

        void verificationForgotRequest(Context context,
                                       String countryCode,
                                       String locale,
                                       VerifyPhoneBody verifyPhoneBody,
                                       NetworkCallback<Response<ForgotVerifySmsResponse>> response);

        void verificationChangedPhone(Context context,
                                      String countryCode,
                                      String locale,
                                      VerifyPhoneBody verifyPhoneBody,
                                      NetworkCallback<Response<Message>> response);
    }
}
