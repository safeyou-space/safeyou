package fambox.pro.model.fragment;

import android.content.Context;

import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.view.fragment.FragmentNetworkContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class FragmentNetworkModel implements FragmentNetworkContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getServicesServer(Context context, String countryCode, String locale, boolean isSendSms,
                                  NetworkCallback<Response<List<ServicesResponseBody>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getServices(countryCode, locale, isSendSms)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<ServicesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<ServicesResponseBody>> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void searchServices(Context context, String countryCode, String locale,
                               String searchText, NetworkCallback<Response<List<ServicesSearchResponse>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).searchServices(countryCode, locale, searchText)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<ServicesSearchResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<ServicesSearchResponse>> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void getCategoryTypes(Context context, String countryCode, String locale, boolean isSendSms,
                                 NetworkCallback<Response<ResponseBody>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getCategoryTypes(countryCode, locale, isSendSms)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void getCategoryByTypesID(Context context, String countryCode, String locale,
                                     long categoryId, boolean isSendSms,
                                     NetworkCallback<Response<List<ServicesResponseBody>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getCategoryByTypesID(countryCode, locale, categoryId, isSendSms)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<ServicesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<ServicesResponseBody>> listResponse) {
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
