package fambox.pro.presenter;

import java.util.Collections;
import java.util.List;

import fambox.pro.R;
import fambox.pro.model.EditAnswerModel;
import fambox.pro.model.ProfileQuestionsModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.view.EditAnswerContract;
import retrofit2.Response;

public class EditAnswerPresenter extends BasePresenter<EditAnswerContract.View>
        implements EditAnswerContract.Presenter {

    private EditAnswerModel editAnswerModel;
    private ProfileQuestionsModel mProfileQuestionsModel;

    @Override
    public void viewIsReady() {
        editAnswerModel = new EditAnswerModel();
        mProfileQuestionsModel = new ProfileQuestionsModel();
    }


    @Override
    public void answerQuestion(String countryCode, String locale, long questionId,
                               String questionType,
                               long questionOptionId) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        mProfileQuestionsModel.editProfile(getView().getContext(), countryCode, locale, questionId, questionType, questionOptionId,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                getView().onBack();
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
    public void findTownOrCity(String countryCode, String locale, String keyword) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        if (keyword == null || keyword.length() < 2) {
            getView().updateAdapter(Collections.emptyList());
            return;
        }
        mProfileQuestionsModel.findTownOrCity(getView().getContext(), countryCode, locale, keyword, new NetworkCallback<Response<List<ProfileQuestionOption>>>() {
            @Override
            public void onSuccess(Response<List<ProfileQuestionOption>> response) {
                if (response.isSuccessful()) {
                    if (response.body() != null) {
                        getView().updateAdapter(response.body());
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
    public void getQuestionOptions(String countryCode, String locale, long questionId) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        editAnswerModel.getQuestionOptions(getView().getContext(), countryCode, locale, questionId,
                new NetworkCallback<Response<List<ProfileQuestionsResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<ProfileQuestionsResponse>> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                getView().initRecyclerView(response.body());
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
