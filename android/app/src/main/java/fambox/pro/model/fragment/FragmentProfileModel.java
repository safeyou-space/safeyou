package fambox.pro.model.fragment;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CheckPoliceResponseBody;
import fambox.pro.network.model.EmergencyContactBody;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.view.fragment.FragmentProfileContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class FragmentProfileModel implements FragmentProfileContract.Model {

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
    public void editProfileServer(Context context, String countryCode, String locale, String key,
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
    public void addEmergencyContact(Context context, String countryCode, String locale,
                                    EmergencyContactBody body,
                                    NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).addEmergencyContact(countryCode, locale, body)
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
    public void editEmergencyContact(Context context, String countryCode, String locale,
                                     long id,
                                     EmergencyContactBody body,
                                     NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).editEmergencyContact(countryCode, locale, id, body)
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
    public void deleteEmergencyContact(Context context, String countryCode, String locale,
                                       long id,
                                       NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).deleteEmergencyContact(countryCode, locale, id)
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
    public void getCheckPolice(Context context, String countryCode, String locale, NetworkCallback<Response<CheckPoliceResponseBody>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getPolice(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<CheckPoliceResponseBody>>() {
                    @Override
                    public void onSuccess(Response<CheckPoliceResponseBody> listResponse) {
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
