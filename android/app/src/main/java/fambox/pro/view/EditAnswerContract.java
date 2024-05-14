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

public interface EditAnswerContract {

    interface View extends MvpView {

        void showProgress();

        void dismissProgress();

        void onBack();

        void initRecyclerView(List<ProfileQuestionsResponse> marriedListResponses);

        void updateAdapter(List<ProfileQuestionOption> profileQuestionOption);

    }

    interface Presenter extends MvpPresenter<View> {
        void getQuestionOptions(String countryCode, String locale, long questionId);

        void answerQuestion(String countryCode, String locale, long questionId,
                            String questionType,
                            long questionOptionId);

        void findTownOrCity(String countryCode, String locale, String keyword);


    }

    interface Model extends BaseModel {
        void editProfile(Context context, String countryCode, String locale,
                         String key,
                         Object value,
                         NetworkCallback<Response<Message>> response);

        void getQuestionOptions(Context context, String countryCode, String locale, long questionId,
                                NetworkCallback<Response<List<ProfileQuestionsResponse>>> response);
    }
}
