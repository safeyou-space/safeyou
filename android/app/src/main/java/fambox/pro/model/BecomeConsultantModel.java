package fambox.pro.model;

import android.content.Context;
import android.util.Log;

import org.jetbrains.annotations.NotNull;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.view.BecomeConsultantContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class BecomeConsultantModel implements BecomeConsultantContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void consultantRequest(Context appContext, String countryCode, String language, Object consultantRequest,
                                  NetworkCallback<Response<ResponseBody>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(appContext).consultantRequest(countryCode, language, consultantRequest)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(@NotNull Response<ResponseBody> listResponse) {
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
