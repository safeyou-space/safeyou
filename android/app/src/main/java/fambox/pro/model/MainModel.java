package fambox.pro.model;

import android.content.Context;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.view.MainContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class MainModel implements MainContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getProfile(Context context, String countryCode, String locale,
                           NetworkCallback<Response<ProfileResponse>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getProfile(countryCode, locale).subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> listResponse) {
                        response.onSuccess(listResponse);
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
