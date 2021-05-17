package fambox.pro.model;

import android.content.Context;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.view.DualPinContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class DualPinModel implements DualPinContract.Model {

    private CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void loginRequest(Context context, String countryCode, String locale,
                             LoginBody loginBody,
                             NetworkCallback<Response<LoginResponse>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).login(countryCode, locale, loginBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<LoginResponse>>() {
                    @Override
                    public void onSuccess(Response<LoginResponse> listResponse) {
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
