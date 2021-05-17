package fambox.pro.view;

import android.content.Context;
import android.text.Editable;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface RegistrationContract {

    interface View extends MvpView {
        void goVerifyRegistration();

//        void setUpSpinner();
    }

    interface Presenter extends MvpPresenter<RegistrationContract.View> {
        void submitRegistration(String locale, String countryCode,
                                Editable firstName, Editable lastName,
                                Editable nickname, int marred,
                                String phone, Editable birthday,
                                Editable password, Editable confirmPassword);
    }

    interface Model extends BaseModel {
        void registrationRequest(Context context, String countryCode, String locale,
                                 RegistrationBody registrationBody,
                                 NetworkCallback<Response<Message>> response);
    }
}
