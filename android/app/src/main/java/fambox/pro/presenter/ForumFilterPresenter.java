package fambox.pro.presenter;

import java.net.HttpURLConnection;
import java.util.List;
import java.util.TreeMap;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ForumFilterCategoryModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.ForumFilterActivityContract;
import retrofit2.Response;

public class ForumFilterPresenter extends BasePresenter<ForumFilterActivityContract.View>
        implements ForumFilterActivityContract.Presenter {

    private ForumFilterCategoryModel mForumFilterCategoryModel;

    @Override
    public void viewIsReady() {
        mForumFilterCategoryModel = new ForumFilterCategoryModel();
        setUpForumsFilterCategories();
        getLanguages();
    }

    @Override
    public void setUpForumsFilterCategories() {
        mForumFilterCategoryModel.getForumFilterCategories(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                LocaleHelper.getLanguage(getView().getContext()),
                new NetworkCallback<Response<TreeMap<String, String>>>() {
                    @Override
                    public void onSuccess(Response<TreeMap<String, String>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (getView() != null) {
                                response.body().put("0", getView().getContext().getResources().getString(R.string.title_all));
                                getView().configCategoryChips(response.body());
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    private void getLanguages() {
        mForumFilterCategoryModel.getLanguages(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                LocaleHelper.getLanguage(getView().getContext()),
                new NetworkCallback<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            TreeMap<String, String> responseMap = new TreeMap<>();
                            responseMap.put("0", getView().getContext().getResources().getString(R.string.title_all));
                            if (response.body() != null) {
                                for (CountriesLanguagesResponseBody countriesLanguagesResponseBody : response.body()) {
                                    responseMap.put(countriesLanguagesResponseBody.getCode(), countriesLanguagesResponseBody.getTitle());
                                }
                                getView().configLanguageChips(responseMap);
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mForumFilterCategoryModel != null) {
            mForumFilterCategoryModel.onDestroy();
        }
    }
}
