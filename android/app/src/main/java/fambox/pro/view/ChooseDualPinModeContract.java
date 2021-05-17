package fambox.pro.view;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ChooseDualPinModeContract {

    interface View extends MvpView {
        Application getApplication();

        void goMainActivity();

        void goLoginPage();
    }

    interface Presenter extends MvpPresenter<ChooseDualPinModeContract.View> {
        void login(Bundle bundle, String countryCode, String locale);
    }

    interface Model extends BaseModel {
        void loginRequest(Context context,
                          String locale,
                          LoginBody loginBody,
                          NetworkCallback<Response<LoginResponse>> response);
    }
}
