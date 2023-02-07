package fambox.pro.view;

import android.content.Context;

import java.util.HashMap;
import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ChooseProfessionContract {

    interface View extends MvpView {
        void configRecViewProfessions(List<Integer> ides, List<String> names);
    }

    interface Presenter extends MvpPresenter<ChooseProfessionContract.View> {

    }

    interface Model extends BaseModel {
        void getConsultantCategories(Context appContext, String countryCode, String language,
                                     NetworkCallback<Response<HashMap<Integer, String>>> response);
    }
}
