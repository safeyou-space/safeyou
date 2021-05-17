package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.view.NgoMapDetailContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class AddToHelplineModel implements NgoMapDetailContract.Model {

    private CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void addEmergencyService(Context context, String countryCode, String locale,
                                    Long value,
                                    NetworkCallback<Response<Message>> response) {
        HashMap<String, Long> data = new HashMap<>();
        data.put("emergency_service_id", value);
        mCompositeDisposable.add(SafeYouApp.getApiService(context).addEmergencyService(countryCode, locale, data)
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
    public void editEmergencyService(Context context, String countryCode, String locale,
                                     long oldId,
                                     long newId,
                                     NetworkCallback<Response<Message>> response) {
        HashMap<String, Long> data = new HashMap<>();
        data.put("emergency_service_id", newId);
        mCompositeDisposable.add(SafeYouApp.getApiService(context).editEmergencyService(countryCode, locale, oldId, data)
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
    public void deleteEmergencyService(Context context, String countryCode, String locale,
                                       long userServiceId,
                                       NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).deleteEmergencyService(countryCode, locale, userServiceId)
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
    public void getServiceByServiceId(Context context, String countryCode, String locale,
                                      long userServiceId, NetworkCallback<Response<ServicesResponseBody>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getServiceByServiceId(countryCode, locale, userServiceId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ServicesResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ServicesResponseBody> serviceResponse) {
                        response.onSuccess(serviceResponse);
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
