package fambox.pro.view;

import android.content.Context;

import androidx.fragment.app.FragmentActivity;

import com.google.android.material.textfield.TextInputEditText;

import java.util.HashMap;
import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileQuestionAnswer;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Response;

public interface EditProfileContract {

    interface View extends MvpView {

        void setFirstName(String text);

        void setLastName(String text);

        void setUserId(String id);

        void setEmail(String text);

        void setMobilePhone(String text);

        void initDialog();

        void setNickname(String nickname);

        void setMaritalStatus(String text);

        void setImage(String imagePath);

        void showProgress();

        void dismissProgress();

        void showNicknameError(String message);

        void updateQuestions(Double filledPercent);

        void setProfileAnswers(HashMap<String, ProfileQuestionAnswer> profileQuestionsAnswers);

        void showSingleQuestion(List<ProfileQuestionsResponse> profileQuestionsResponses, long answerId, String questionTitle);

        void childCountSuccessfullyUpdated();
    }

    interface Presenter extends MvpPresenter<EditProfileContract.View> {
        void getQuestionById(String countryCode, String locale, long questionId, long answerId, String questionTitle);

        void getProfile(String countryCode, String locale);

        void editProfileDetail(String countryCode, String locale, String imagePath);

        void profileSingle(String countryCode, String locale, String fieldName);

        void configEditText(String countryCode, String locale, FragmentActivity context, TextInputEditText editText, boolean isChecked, int viewId);

        void removeProfileImage(String countryCode, String locale);

        void editChildCount(String countryCode, String locale, long questionId,
                            String questionType,
                            long questionOptionId);

    }

    interface Model extends BaseModel {
        void getProfile(Context context, String countryCode, String locale,
                        NetworkCallback<Response<ProfileResponse>> response);

        void getProfileQuestions(Context context, String countryCode, String locale, long questionId, NetworkCallback<Response<List<ProfileQuestionsResponse>>> response);

        void editPhotoNickname(Context context, String countryCode, String locale,
                               MultipartBody.Part image,
                               RequestBody fieldName,
                               RequestBody method,
                               NetworkCallback<Response<Message>> response);

        void getProfileSingle(Context context, String countryCode, String locale, String fieldName,
                              NetworkCallback<Response<ResponseBody>> response);

        void editProfile(Context context, String countryCode, String locale, String key,
                         Object value, NetworkCallback<Response<Message>> response);

        void removeProfileImage(Context context, String countryCode, String locale, NetworkCallback<Response<Message>> response);
    }
}
