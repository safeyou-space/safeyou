package fambox.pro.view;

import android.content.Context;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface RegistrationContract {

    interface View extends MvpView {
        void goTermsAndConditions(RegistrationBody registrationBody);
    }

    interface Model extends BaseModel {
        void registrationRequest(Context context, String countryCode, String locale,
                                 RegistrationBody registrationBody,
                                 NetworkCallback<Response<Message>> response);
    }
}
