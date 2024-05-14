package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;
import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.view.ProfileQuestionsContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ProfileQuestionsModel implements ProfileQuestionsContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void editProfile(Context context, String countryCode, String locale, long questionId,
                            String questionType, long questionOptionId, NetworkCallback<Response<Message>> response) {
        HashMap<String, Object> data = new HashMap<>();
        data.put("field_name", "profile_question");
        data.put("question_id", questionId);
        data.put("question_type", questionType);
        data.put("question_option_id", questionOptionId);
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
    public void getProfileQuestions(Context context, String countryCode, String locale, NetworkCallback<Response<List<ProfileQuestionsResponse>>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).getProfileQuestions(countryCode, locale)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<ProfileQuestionsResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<ProfileQuestionsResponse>> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void findTownOrCity(Context context, String countryCode, String locale, String keyword, NetworkCallback<Response<List<ProfileQuestionOption>>> response) {

        mCompositeDisposable.add(SafeYouApp.getApiService(context).findTownOrCity(countryCode, locale, keyword)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<List<ProfileQuestionOption>>>() {
                    @Override
                    public void onSuccess(Response<List<ProfileQuestionOption>> listResponse) {
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
