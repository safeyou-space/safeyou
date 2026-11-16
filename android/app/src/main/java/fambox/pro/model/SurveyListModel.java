package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.SurveyListResponse;
import fambox.pro.network.model.Surveys;
import fambox.pro.view.SurveyListContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class SurveyListModel implements SurveyListContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void createSurveyAnswer(Context context, String countryCode, String locale, long surveyId,
                                   long questionId, Object answer, NetworkCallback<Response<Message>> response) {
        HashMap<String, Object> data = new HashMap<>();
        data.put("survey_id", surveyId);
        data.put("questions", answer);

        mCompositeDisposable.add(SafeYouApp.getApiService(context).createSurveyAnswer(countryCode, locale, data)
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
    public void getSurveyList(Context context, String countryCode, String locale, int page, NetworkCallback<Response<SurveyListResponse>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getSurveyList(countryCode, locale, page)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<SurveyListResponse>>() {
                    @Override
                    public void onSuccess(Response<SurveyListResponse> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void getSurveyById(Context context, String countryCode, String locale, long surveyId, NetworkCallback<Response<Surveys>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getSurveyById(countryCode, locale, surveyId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<Surveys>>() {
                    @Override
                    public void onSuccess(Response<Surveys> listResponse) {
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
