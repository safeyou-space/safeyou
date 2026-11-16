package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;
import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.view.RecordDetailsContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class RecordDetailsModel implements RecordDetailsContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getRecords(Context context, String countryCode, String locale, NetworkCallback<Response<List<RecordResponse>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getRecords(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<RecordResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<RecordResponse>> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void getSingleRecord(Context context, String countryCode, String locale, long recordId,
                                NetworkCallback<Response<RecordResponse>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getSingleRecord(countryCode, locale, recordId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<RecordResponse>>() {
                    @Override
                    public void onSuccess(Response<RecordResponse> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void sendMailRecord(Context context, String countryCode, String locale, long recordId,
                               String longitude, String latitude,
                               NetworkCallback<Response<Message>> response) {
        HashMap<String, String> location = new HashMap<>();
        location.put("longitude", longitude);
        location.put("latitude", latitude);
        mCompositeDisposable.add(SafeYouApp.getApiService(context).sendMailRecord(countryCode, locale, recordId, location)
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
    public void deleteRecord(Context context, String countryCode, String locale, long recordId,
                             NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).deleteRecord(countryCode, locale, recordId)
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
