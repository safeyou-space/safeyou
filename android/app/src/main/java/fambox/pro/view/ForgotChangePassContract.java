package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CreateNewPasswordBody;
import fambox.pro.network.model.Message;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ForgotChangePassContract {

    interface View extends MvpView {

        void goVerificationActivity(Bundle bundle);

        void configView(String title, String createNewPassword, String confirmNewPassword);

        void configViewForPhone(String title, String btnText, boolean isPhone);

        void goLoginPage();
    }

    interface Presenter extends MvpPresenter<ForgotChangePassContract.View> {
        void onClickNewPass(String countryCode, String locale, String phoneNumber);

        void initBundle(Bundle bundle);

        void sendPhoneToForgotChangePassword(String countryCode, String locale, String phoneNumber);

        void changePasswordWithForgot(String countryCode, String locale, String password, Editable confirmPassword);

        void editPhoneNumber(String countryCode, String locale, String phoneNumber);

    }

    interface Model extends BaseModel {
        void sendPhoneNumber(Context context, String countryCode, String locale, String phoneNumber,
                             NetworkCallback<Response<Message>> response);

        void createNewPassword(Context context, String countryCode, String locale, CreateNewPasswordBody createNewPasswordBody,
                               NetworkCallback<Response<Message>> response);
    }
}
