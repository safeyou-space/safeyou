package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.network.model.Message;
import fambox.pro.view.DualPinContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class DualPinModel implements DualPinContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

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
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
