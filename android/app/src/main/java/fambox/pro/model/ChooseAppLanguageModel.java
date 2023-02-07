package fambox.pro.model;

import android.content.Context;

import org.jetbrains.annotations.NotNull;

import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.view.ChooseAppLanguageContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class ChooseAppLanguageModel implements ChooseAppLanguageContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

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
    public void changeLanguage(Context context, String countryCode, String locale,
                               NetworkCallback<Response<ResponseBody>> languageResponse) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).changeLanguage(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(@NotNull Response<ResponseBody> languagesListResponse) {
                        languageResponse.onSuccess(languagesListResponse);
                    }

                    @Override
                    public void onError(@NotNull Throwable e) {
                        languageResponse.onError(e);
                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
