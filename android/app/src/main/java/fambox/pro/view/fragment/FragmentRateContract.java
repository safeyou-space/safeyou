package fambox.pro.view.fragment;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.RateForumBody;
import fambox.pro.network.model.RateServiceBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface FragmentRateContract {

    interface View extends MvpView {
        void initBundle();

        void showProgress();

        void dismissProgress();

    }

    interface Presenter extends MvpPresenter<FragmentRateContract.View> {

        void rateForum(int rate, String comment, long forumID, boolean isNGO);
    }

    interface Model extends BaseModel {
        void rateForum(Context appContext, String countryCode, String languageCode, RateForumBody rateBody,
                       NetworkCallback<Response<HashMap<String, String>>> response);

        void rateNGO(Context appContext, String countryCode, String languageCode, RateServiceBody rateBody,
                     NetworkCallback<Response<HashMap<String, String>>> response);
    }
}
