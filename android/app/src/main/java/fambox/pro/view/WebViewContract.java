package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface WebViewContract {

    interface View extends MvpView {
        void configWebView(String htmlText);

        void setIsTermsAndCondition(String title);

        void goVerifyRegistration();
    }

    interface Presenter extends MvpPresenter<WebViewContract.View> {
        void setBundle(Bundle bundle, String countryCode, String locale, RegistrationBody registrationBody);

        void content(String countryCode, String locale);

        void registerUser();

    }

    interface Model extends BaseModel {
        void getContent(Context context, String countryCode, String locale,
                        String title,
                        String age,
                        NetworkCallback<Response<ContentResponse>> response);
    }
}
