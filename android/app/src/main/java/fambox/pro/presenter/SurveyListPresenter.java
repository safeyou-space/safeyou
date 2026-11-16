package fambox.pro.presenter;

import fambox.pro.R;
import fambox.pro.model.SurveyListModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.SurveyListResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.view.SurveyListContract;
import retrofit2.Response;

public class SurveyListPresenter extends BasePresenter<SurveyListContract.View>
        implements SurveyListContract.Presenter {

    private SurveyListModel mSurveyListModel;

    @Override
    public void viewIsReady() {
        mSurveyListModel = new SurveyListModel();
    }


    @Override
    public void answerQuestion(String countryCode, String locale, long surveyId,
                               long questionId, Object answer) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
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
    public void getSurveyList(String countryCode, String locale, int page) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        mSurveyListModel.getSurveyList(getView().getContext(), countryCode, locale, page, new NetworkCallback<Response<SurveyListResponse>>() {
            @Override
            public void onSuccess(Response<SurveyListResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body() != null) {
                        if (page == 1) {
                            getView().initView(response.body());
                        } else {
                            getView().updateAdapter(response.body());
                        }
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
