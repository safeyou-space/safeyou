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
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.model.EditProfileModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.ProgressRequestBodyObservable;
import fambox.pro.network.model.Message;
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

    @Override
    public void viewIsReady() {
        mEditProfileModel = new EditProfileModel();
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
            switch (viewId) {
                case R.id.btnEditFirstName:
                    editProfile(countryCode, locale, "first_name", Utils.getEditableToString(editText.getText()));
                    break;
                case R.id.btnEditSurname:
                    editProfile(countryCode, locale, "last_name", Utils.getEditableToString(editText.getText()));
                    break;
                case R.id.btnEditLocation:
                    editProfile(countryCode, locale, "location", Utils.getEditableToString(editText.getText()));
                    break;
                case R.id.btnChangeNickName:
                    editProfile(countryCode, locale, "nickname", Utils.getEditableToString(editText.getText()));
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
    public void getProfile(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
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
                                    getView().setLocation(response.body().getLocation());
                                    getView().setNickname(response.body().getNickname());
                                    if (response.body().getImage() != null) {
                                        getView().setImage(BASE_URL.concat(response.body().getImage().getUrl()));
                                    } else {
                                        getView().setImage("");
                                    }

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
}
