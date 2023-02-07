package fambox.pro.model;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ReportPostBody;
import fambox.pro.view.ReportContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ReportModel implements ReportContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();


    @Override
    public void getReportCategories(Context context, String countryCode, String languageCode,
                                    NetworkCallback<Response<HashMap<String, String>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getReportCategories(countryCode, languageCode)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<HashMap<String, String>>>() {
                    @Override
                    public void onSuccess(@NonNull Response<HashMap<String, String>> hashMapResponse) {
                        response.onSuccess(hashMapResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void postReport(Context context, String countryCode, String languageCode, ReportPostBody reportPostBody,
                           NetworkCallback<Response<HashMap<String, String>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).postReport(countryCode, languageCode, reportPostBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<HashMap<String, String>>>() {
                    @Override
                    public void onSuccess(@NonNull Response<HashMap<String, String>> hashMapResponse) {
                        response.onSuccess(hashMapResponse);
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
