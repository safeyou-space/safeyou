package fambox.pro.view;

import android.content.Context;
import android.text.Editable;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ChangePasswordBody;
import fambox.pro.network.model.Message;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface SettingsChangePassContract {

    interface View extends MvpView {
        void clearAllTextInEditTextViews();
    }

    interface Presenter extends MvpPresenter<View> {
        void newPassValidation(String countryCode, String locale, Editable oldPass, Editable newPass, Editable confirmNewPass);

        void changePass(String countryCode, String locale, String oldPass, String newPass, String confirmNewPass);
    }

    interface Model extends BaseModel {
        void changePassword(Context context,
                            String countryCode,
                            String locale,
                            ChangePasswordBody changePasswordBody,
                            NetworkCallback<Response<Message>> response);
    }
}
