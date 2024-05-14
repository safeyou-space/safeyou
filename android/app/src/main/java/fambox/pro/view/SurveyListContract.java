package fambox.pro.view;

import android.content.Context;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.SurveyListResponse;
import fambox.pro.network.model.Surveys;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface SurveyListContract {

    interface View extends MvpView {

        void showProgress();

        void dismissProgress();

        void onSuccess();

        void initView(SurveyListResponse profileQuestionsResponses);

        void updateAdapter(SurveyListResponse profileQuestionsResponses);

    }

    interface Presenter extends MvpPresenter<View> {
        void getSurveyList(String countryCode, String locale, int page);

        void answerQuestion(String countryCode, String locale, long surveyId,
                            long questionId, Object answer);

    }

    interface Model extends BaseModel {
        void createSurveyAnswer(Context context, String countryCode, String locale, long surveyId,
                                long questionId, Object answer, NetworkCallback<Response<Message>> response);

        void getSurveyList(Context context, String countryCode, String locale, int page, NetworkCallback<Response<SurveyListResponse>> response);

        void getSurveyById(Context context, String countryCode, String locale, long surveyId, NetworkCallback<Response<Surveys>> response);
    }
}
