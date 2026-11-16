package fambox.pro.view;

import android.content.Context;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.network.model.Message;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface MaritalStatusContract {

    interface View extends MvpView {

        void showProgress();

        void dismissProgress();

        void onBack();

        void initRecyclerView(List<MarriedListResponse> marriedListResponses);

    }

    interface Presenter extends MvpPresenter<MaritalStatusContract.View> {
        void getMaritalList(String countryCode, String locale);

        void setMaritalStatus(String countryCode, String locale, Object value);

    }

    interface Model extends BaseModel {
        void editProfile(Context context, String countryCode, String locale,
                         String key,
                         Object value,
                         NetworkCallback<Response<Message>> response);

        void getMarriedList(Context context, String countryCode, String locale,
                            NetworkCallback<Response<List<MarriedListResponse>>> response);
    }
}
