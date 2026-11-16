package fambox.pro.model;

import android.content.Context;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.view.WebViewContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class WebViewModel implements WebViewContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();


    @Override
    public void getContent(Context context, String countryCode, String locale,
                           String title, String age,
                           NetworkCallback<Response<ContentResponse>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getContent(countryCode, locale, title, age)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ContentResponse>>() {
                    @Override
                    public void onSuccess(Response<ContentResponse> listResponse) {
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
