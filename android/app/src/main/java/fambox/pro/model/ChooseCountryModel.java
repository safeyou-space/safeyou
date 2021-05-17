package fambox.pro.model;

import android.content.Context;

import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.DeviceConfigBody;
import fambox.pro.view.ChooseCountryContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class ChooseCountryModel implements ChooseCountryContract.Model {

    private CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getCountries(Context context, String countryCode, String locale,
                             NetworkCallback<Response<List<CountriesLanguagesResponseBody>>> countryResponse) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getCountries(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> countriesListResponse) {
                        countryResponse.onSuccess(countriesListResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        countryResponse.onError(e);
                    }
                }));
    }

    @Override
    public void getDeviceConfig(Context context, String countryCode, String apiKey, NetworkCallback<Response<List<DeviceConfigBody>>> configResponse) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getDeviceConfig(countryCode, apiKey)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<DeviceConfigBody>>>() {
                    @Override
                    public void onSuccess(@NonNull Response<List<DeviceConfigBody>> responseConfigBody) {
                        configResponse.onSuccess(responseConfigBody);
                    }

                    @Override
                    public void onError(@NonNull Throwable e) {
                        configResponse.onError(e);
                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
