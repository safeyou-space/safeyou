package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface TermsAndConditionsContract {

    interface View extends MvpView {
        void configWebView(String htmlText);

        void setIsTermsAndCondition(boolean isTermsAndCondition);
    }

    interface Presenter extends MvpPresenter<TermsAndConditionsContract.View> {
        void setBundle(Bundle bundle, String countryCode, String locale);

        void content(String countryCode, String locale);
    }

    interface Model extends BaseModel {
        void getContent(Context context, String countryCode, String locale,
                        String title,
                        NetworkCallback<Response<ContentResponse>> response);
    }
}
