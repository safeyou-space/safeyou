package fambox.pro.view;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface LoginWithBackContract {

    interface View extends MvpView {
        Application getApplication();

        void goDualPinScreen();

        void verify(Bundle bundle);

        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<LoginWithBackContract.View> {
        void loginRequest(String countryCode, String locale, String phoneNumber, Editable password);
    }

    interface Model extends BaseModel {
        void login(Context context,
                   String countryCode,
                   String locale,
                   LoginBody loginBody,
                   NetworkCallback<Response<LoginResponse>> response);
    }
}
