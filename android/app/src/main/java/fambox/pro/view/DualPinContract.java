package fambox.pro.view;

import android.app.Application;
import android.content.Context;
import android.text.Editable;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface DualPinContract {

    interface View extends MvpView {
        Application getApplication();

        void goMainActivity();

        void goLoginPage();
    }

    interface Presenter extends MvpPresenter<DualPinContract.View> {
        void checkRealFakePin(String countryCode,
                              String locale,
                              Editable realPin,
                              Editable confirmRealPin,
                              Editable fakePin,
                              Editable confirmFakePin,
                              boolean isSettings);
    }

    interface Model extends BaseModel {
        void loginRequest(Context context,
                          String countryCode,
                          String locale,
                          LoginBody loginBody,
                          NetworkCallback<Response<LoginResponse>> response);
    }
}
