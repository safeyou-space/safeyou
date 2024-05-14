package fambox.pro.presenter;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.SurveyListModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.Surveys;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.view.SurveyQuestionsContract;
import retrofit2.Response;

public class SurveyQuestionsPresenter extends BasePresenter<SurveyQuestionsContract.View>
        implements SurveyQuestionsContract.Presenter {

    private SurveyListModel mSurveyListModel;

    @Override
    public void viewIsReady() {
        mSurveyListModel = new SurveyListModel();
    }


    @Override
    public void answerQuestion(String countryCode, String locale, long surveyId,
                               long questionId, Object answer) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(SafeYouApp.getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        mSurveyListModel.createSurveyAnswer(getView().getContext(), countryCode, locale, surveyId, questionId, answer,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                getView().onSuccess();
                            }
                        }
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    @Override
    public void getSurveyById(String countryCode, String locale, long surveyId) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(SafeYouApp.getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        mSurveyListModel.getSurveyById(getView().getContext(), countryCode, locale, surveyId, new NetworkCallback<Response<Surveys>>() {
            @Override
            public void onSuccess(Response<Surveys> response) {
                if (response.isSuccessful()) {
                    if (response.body() != null) {
                        getView().initView(response.body());
                    }
                }
                if (getView() != null) {
                    getView().dismissProgress();
                }
            }

            @Override
            public void onError(Throwable error) {
                if (getView() != null) {
                    getView().dismissProgress();
                }

            }
        });
    }

}
