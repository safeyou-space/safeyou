package fambox.pro.model.fragment;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.view.fragment.FragmentOtherContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class FragmentOtherModel implements FragmentOtherContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getProfile(Context context, String countryCode, String locale, NetworkCallback<Response<ProfileResponse>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getProfile(countryCode, locale)
                .subscribeOn(Schedulers.io())
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
    public void logout(Context context, String countryCode, String locale,
                       NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).logout(countryCode, locale)
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
    public void deleteAccount(Context context, String countryCode, String locale,
                              NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).deleteAccount(countryCode, locale)
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
