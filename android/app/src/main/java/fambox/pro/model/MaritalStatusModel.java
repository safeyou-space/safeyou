package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;
import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.network.model.Message;
import fambox.pro.view.MaritalStatusContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class MaritalStatusModel implements MaritalStatusContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void editProfile(Context context, String countryCode, String locale, String key,
                            Object value, NetworkCallback<Response<Message>> response) {
        HashMap<String, Object> data = new HashMap<>();
        data.put("field_name", key);
        data.put("field_value", value);
        mCompositeDisposable.add(SafeYouApp.getApiService(context).editProfile(countryCode, locale, data)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void getMarriedList(Context context, String countryCode, String locale, NetworkCallback<Response<List<MarriedListResponse>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getMarriedList(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<MarriedListResponse>>>() {

                    @Override
                    public void onSuccess(Response<List<MarriedListResponse>> messageResponse) {
                        response.onSuccess(messageResponse);
                    }

                    @Override
                    public void onError(Throwable e) {

                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
