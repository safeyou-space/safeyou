package fambox.pro.view;

import android.content.Context;

import androidx.annotation.DrawableRes;
import androidx.annotation.StringRes;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import okhttp3.ResponseBody;
import retrofit2.Response;

public interface BecomeConsultantContract {

    interface View extends MvpView {
        void configRequestPending(boolean isPending);

        void configRequestStatus(@StringRes int textResourceId,
                                 @StringRes int submitResourceId,
                                 @DrawableRes int iconResourceId,
                                 String date,
                                 String submissionDate);

        void configRequestMessages(String email, String message, String submissionDate, String profession);

        void newRequest();

        void openDialogCancelRequest();

        void openDialogDeactivateRequest();

        void openSuccessRequestDialog();

        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<BecomeConsultantContract.View> {
        void sendRequest(String email, String message, String newCategoryName,
                         int categoryId);

        void cancelRequest();

        void deactivateRequest();
    }

    interface Model extends BaseModel {
        void consultantRequest(Context appContext, String countryCode, String language,
                               Object consultantRequest,
                               NetworkCallback<Response<ResponseBody>> response);

        void cancelConsultantRequest(Context appContext, String countryCode, String language,
                                     NetworkCallback<Response<ResponseBody>> response);

        void deactivateConsultantRequest(Context appContext, String countryCode, String language,
                                         NetworkCallback<Response<ResponseBody>> response);
    }
}
