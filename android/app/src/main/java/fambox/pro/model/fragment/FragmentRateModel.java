package fambox.pro.model.fragment;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.RateForumBody;
import fambox.pro.network.model.RateServiceBody;
import fambox.pro.view.fragment.FragmentRateContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class FragmentRateModel implements FragmentRateContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();


    @Override
    public void rateForum(Context appContext, String countryCode, String languageCode, RateForumBody rateBody,
                          NetworkCallback<Response<HashMap<String, String>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(appContext).postForumRate(countryCode, languageCode, rateBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<HashMap<String, String>>>() {
                    @Override
                    public void onSuccess(@NonNull Response<HashMap<String, String>> hashMapResponse) {
                        response.onSuccess(hashMapResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void rateNGO(Context appContext, String countryCode, String languageCode, RateServiceBody rateBody,
                        NetworkCallback<Response<HashMap<String, String>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(appContext).postNGORate(countryCode, languageCode, rateBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<HashMap<String, String>>>() {
                    @Override
                    public void onSuccess(@NonNull Response<HashMap<String, String>> hashMapResponse) {
                        response.onSuccess(hashMapResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
