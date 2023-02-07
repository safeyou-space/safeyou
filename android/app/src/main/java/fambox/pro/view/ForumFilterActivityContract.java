package fambox.pro.view;

import android.content.Context;

import java.util.List;
import java.util.TreeMap;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ForumFilterActivityContract {

    interface View extends MvpView {

        void configCategoryChips(TreeMap<String, String> response);

        void configLanguageChips(TreeMap<String, String> response);
    }

    interface Presenter extends MvpPresenter<ForumFilterActivityContract.View> {
        void setUpForumsFilterCategories();
    }

    interface Model extends BaseModel {
        void getForumFilterCategories(Context context, String countryCode, String languageCode,
                                      NetworkCallback<Response<TreeMap<String, String>>> response);

        void getLanguages(Context context, String countryCode, String locale,
                          NetworkCallback<Response<List<CountriesLanguagesResponseBody>>> languageResponse);
    }
}
