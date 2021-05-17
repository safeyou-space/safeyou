package fambox.pro.view;

import android.content.Context;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import okhttp3.ResponseBody;
import retrofit2.Response;

public interface BecomeConsultantContract {

    interface View extends MvpView {
        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<BecomeConsultantContract.View> {
        void sendRequest(String email, String message, String newCategoryName,
                         int categoryId);
    }

    interface Model extends BaseModel {
        void consultantRequest(Context appContext, String countryCode, String language,
                               Object consultantRequest,
                               NetworkCallback<Response<ResponseBody>> response);
    }
}
