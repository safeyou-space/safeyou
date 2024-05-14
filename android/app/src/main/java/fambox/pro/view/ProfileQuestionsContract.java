package fambox.pro.view;

import android.content.Context;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ProfileQuestionsContract {

    interface View extends MvpView {

        void showProgress();

        void dismissProgress();

        void onSuccess();

        void initView(List<ProfileQuestionsResponse> profileQuestionsResponses);

        void updateAdapter(List<ProfileQuestionOption> profileQuestionOption);

    }

    interface Presenter extends MvpPresenter<View> {
        void getProfileQuestions(String countryCode, String locale);

        void findTownOrCity(String countryCode, String locale, String keyword);

        void answerQuestion(String countryCode, String locale, long questionId,
                            String questionType,
                            long questionOptionId);

    }

    interface Model extends BaseModel {
        void editProfile(Context context, String countryCode, String locale, long questionId,
                                                               String questionType, long questionOptionId, NetworkCallback<Response<Message>> response);

        void getProfileQuestions(Context context, String countryCode, String locale, NetworkCallback<Response<List<ProfileQuestionsResponse>>> response);

        void findTownOrCity(Context context, String countryCode, String locale, String keyword, NetworkCallback<Response<List<ProfileQuestionOption>>> response);
    }
}
