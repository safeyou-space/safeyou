package fambox.pro.model;

import android.content.Context;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.view.ChooseProfessionContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ChooseProfessionModel implements ChooseProfessionContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getConsultantCategories(Context appContext, String countryCode, String language,
                                        NetworkCallback<Response<HashMap<Integer, String>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(appContext).getConsultantCategories(countryCode, language)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<HashMap<Integer, String>>>() {
                    @Override
                    public void onSuccess(@NotNull Response<HashMap<Integer, String>> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(@NotNull Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
