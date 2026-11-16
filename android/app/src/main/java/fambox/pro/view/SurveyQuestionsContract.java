package fambox.pro.view;

import fambox.pro.network.model.Surveys;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface SurveyQuestionsContract {

    interface View extends MvpView {

        void showProgress();

        void dismissProgress();

        void onSuccess();

        void initView(Surveys surveys);
    }

    interface Presenter extends MvpPresenter<View> {
        void getSurveyById(String countryCode, String locale, long surveyId);

        void answerQuestion(String countryCode, String locale, long surveyId,
                            long questionId, Object answer);

    }
}
