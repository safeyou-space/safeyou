package fambox.pro.presenter;

import static fambox.pro.Constants.BASE_URL;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.inputmethod.InputMethodManager;

import androidx.fragment.app.FragmentActivity;

import com.google.android.material.textfield.TextInputEditText;

import java.io.File;
import java.net.HttpURLConnection;
import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.model.EditProfileModel;
import fambox.pro.model.ProfileQuestionsModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.ProgressRequestBodyObservable;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.EditProfileContract;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class EditProfilePresenter extends
        BasePresenter<EditProfileContract.View> implements EditProfileContract.Presenter {

    private boolean isTextChanged = false;

    private EditProfileModel mEditProfileModel;
    private ProfileQuestionsModel mProfileQuestionsModel;

    @Override
    public void viewIsReady() {
        mEditProfileModel = new EditProfileModel();
        mProfileQuestionsModel = new ProfileQuestionsModel();
        getView().showProgress();
    }

    @Override
    public void editProfileDetail(String countryCode, String locale, String imagePath) {
        getView().showProgress();
        File imageFile = new File(imagePath);
        ProgressRequestBodyObservable progressRequestBodyObservable =
                new ProgressRequestBodyObservable(imageFile, ProgressRequestBodyObservable.RequestBodyMediaType.IMAGE);
        MultipartBody.Part image = MultipartBody.Part.createFormData("field_value",
                imageFile.getName(), progressRequestBodyObservable);

        // request field_name body.
        RequestBody description = RequestBody.create(MediaType.parse("text/plain"), "image");
        // request method PUT.
        RequestBody method = RequestBody.create(MediaType.parse("text/plain"), "PUT");

        mEditProfileModel.editPhotoNickname(getView().getContext(), countryCode, locale, image, description, method,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                profileSingle(countryCode, locale, "image");
                            }
                        } else {
                            getView().dismissProgress();
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void profileSingle(String countryCode, String locale, String fieldName) {
        mEditProfileModel.getProfileSingle(getView().getContext(), countryCode, locale, fieldName,
                new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (Objects.equals(fieldName, "image")) {
                                    String imagePath = RetrofitUtil.getCustomBody(response, fieldName);
                                    getView().setImage(BASE_URL.concat(imagePath));
                                }
                                getView().dismissProgress();
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void configEditText(String countryCode, String locale, FragmentActivity context,
                               TextInputEditText editText, boolean isChecked, int viewId) {
        editText.setEnabled(isChecked);
        editText.requestFocus();
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (isChecked) {
            if (imm != null) imm.showSoftInput(editText, InputMethodManager.SHOW_IMPLICIT);
        } else {
            if (imm != null) imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
        }
        if (editText.getText() != null) {
            editText.setSelection(editText.getText().length());
        }
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                isTextChanged = true;
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                isTextChanged = true;
            }

            @Override
            public void afterTextChanged(Editable s) {
                isTextChanged = true;
            }
        });

        if (!isChecked && isTextChanged) {
            String text;
            switch (viewId) {
                case R.id.btnEditFirstName:
                    text = Utils.getEditableToString(editText.getText());
                    editProfile(countryCode, locale, "first_name", text);
                    break;
                case R.id.btnEditSurname:
                    text = Utils.getEditableToString(editText.getText());
                    editProfile(countryCode, locale, "last_name", text);
                    break;
                case R.id.btnChangeNickName:
                    text = Utils.getEditableToString(editText.getText());
                    if (text.length() <= 1) {
                        getView().showNicknameError(getView().getContext().getString(R.string.min_length_2));
                        return;
                    }
                    editProfile(countryCode, locale, "nickname", text);
                    break;
            }
        }
        isTextChanged = false;
    }

    @Override
    public void removeProfileImage(String countryCode, String locale) {
        mEditProfileModel.removeProfileImage(getView().getContext(), countryCode, locale, new NetworkCallback<Response<Message>>() {
            @Override
            public void onSuccess(Response<Message> response) {
                if (response.isSuccessful()) {
                    if (response.code() == HttpURLConnection.HTTP_OK) {
                        if (response.body() != null) {
                            getView().showSuccessMessage(response.body().getMessage());
                            profileSingle(countryCode, locale, "image");
                        }
                    }
                } else {
                    getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                }
            }

            @Override
            public void onError(Throwable error) {

            }
        });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mEditProfileModel != null) {
            mEditProfileModel.onDestroy();
        }
    }

    private void editProfile(String countryCode, String locale, String key, Object value) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }

        getView().showProgress();
        mEditProfileModel.editProfile(getView().getContext(), countryCode, locale, key, value,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                if (response.body() != null) {
                                    getProfile(countryCode, locale);
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void getQuestionById(String countryCode, String locale, long questionId, long answerId, String questionTitle) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }
        mEditProfileModel.getProfileQuestions(getView().getContext(), countryCode, locale, questionId,
                new NetworkCallback<Response<List<ProfileQuestionsResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<ProfileQuestionsResponse>> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                getView().showSingleQuestion(response.body(), answerId, questionTitle);
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());

                    }
                });
    }

    @Override
    public void getProfile(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getString(R.string.check_internet_connection_text_key));
            return;
        }

        getView().showProgress();
        mEditProfileModel.getProfile(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null && getView() != null) {
                                    getView().setFirstName(response.body().getFirst_name());
                                    getView().setLastName(response.body().getLast_name());
                                    getView().setUserId(response.body().getUid());
                                    getView().setMaritalStatus(response.body().getMarital_status());
                                    getView().setMobilePhone(response.body().getPhone());
                                    getView().setNickname(response.body().getNickname());
                                    getView().setProfileAnswers(response.body().getProfileQuestionsAnswers());
                                    if (response.body().getImage() != null) {
                                        getView().setImage(BASE_URL.concat(response.body().getImage().getUrl()));
                                    } else {
                                        getView().setImage("");
                                    }
                                    getView().updateQuestions(response.body().getFilledPercent());

                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void editChildCount(String countryCode, String locale, long questionId,
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
                                getView().childCountSuccessfullyUpdated();
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
