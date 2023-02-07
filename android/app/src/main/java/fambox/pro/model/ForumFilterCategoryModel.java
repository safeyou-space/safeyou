package fambox.pro.model;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.List;
import java.util.TreeMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.view.ForumFilterActivityContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ForumFilterCategoryModel implements ForumFilterActivityContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();


    @Override
    public void getForumFilterCategories(Context context, String countryCode, String languageCode,
                                         NetworkCallback<Response<TreeMap<String, String>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getForumFilterCategories(countryCode, languageCode)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<TreeMap<String, String>>>() {
                    @Override
                    public void onSuccess(@NonNull Response<TreeMap<String, String>> hashMapResponse) {
                        response.onSuccess(hashMapResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void getLanguages(Context context, String countryCode, String locale,
                             NetworkCallback<Response<List<CountriesLanguagesResponseBody>>> languageResponse) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getLanguages(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> languagesListResponse) {
                        languageResponse.onSuccess(languagesListResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        languageResponse.onError(e);
                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
