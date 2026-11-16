package fambox.pro.model.fragment;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.view.fragment.FragmentHelpContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class FragmentHelpModel implements FragmentHelpContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void sendSms(Context context, String countryCode, String locale, String longitude, String latitude, String location1,
                        NetworkCallback<Response<Message>> response) {
        HashMap<String, String> location = new HashMap<>();
        location.put("longitude", longitude);
        location.put("latitude", latitude);
        location.put("location", location1);
        mCompositeDisposable.add(SafeYouApp.getApiService(context).sendHelpSms(countryCode, locale, location)
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
    public void getAllServicesName(Context context, String countryCode, String locale,
                                   NetworkCallback<Response<ResponseBody>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getAllServicesNameLit(countryCode, locale)
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
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
