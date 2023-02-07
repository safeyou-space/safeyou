package fambox.pro.model.fragment;

import android.content.Context;

import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.view.fragment.FragmentRecordsContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class FragmentRecordModel implements FragmentRecordsContract.Model {

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
    public void getRecordIsSend(Context context, String countryCode, String locale,
                                String isSent,
                                String search,
                                NetworkCallback<Response<List<RecordResponse>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getRecordIsSentSearch(countryCode, locale, isSent, search)
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

    public void searchRecord(Context context, String countryCode, String locale,
                             String search,
                             NetworkCallback<Response<List<RecordSearchResult>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).searchRecord(countryCode, locale, search)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<RecordSearchResult>>>() {
                    @Override
                    public void onSuccess(Response<List<RecordSearchResult>> listResponse) {
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
