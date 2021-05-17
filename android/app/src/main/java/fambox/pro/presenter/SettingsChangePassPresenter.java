package fambox.pro.presenter;

import android.text.Editable;

import java.net.HttpURLConnection;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.model.ChangePasswordModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ChangePasswordBody;
import fambox.pro.network.model.Message;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.SettingsChangePassContract;
import retrofit2.Response;

public class SettingsChangePassPresenter extends BasePresenter<SettingsChangePassContract.View>
        implements SettingsChangePassContract.Presenter {

    private ChangePasswordModel mChangePasswordModel;


    @Override
    public void viewIsReady() {
        mChangePasswordModel = new ChangePasswordModel();
    }

    @Override
    public void newPassValidation(String countryCode, String locale, Editable oldPass, Editable newPass, Editable confirmNewPass) {
        String oldPassword = Utils.getEditableToString(oldPass);
        String newPassword = Utils.getEditableToString(newPass);
        String confirmNewPassword = Utils.getEditableToString(confirmNewPass);
        if (!Objects.equals(newPassword, confirmNewPassword)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.confirm_pass_field));
        } else if ((newPassword.length() < 8) || (confirmNewPass.length() < 8)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.min_length_8));
        } else {
            changePass(countryCode, locale, oldPassword, newPassword, confirmNewPassword);
        }
    }

    @Override
    public void changePass(String countryCode, String locale, String oldPass, String newPass, String confirmNewPass) {
        ChangePasswordBody changePasswordBody = new ChangePasswordBody();
        changePasswordBody.setOld_password(oldPass);
        changePasswordBody.setPassword(newPass);
        changePasswordBody.setConfirm_password(confirmNewPass);
        mChangePasswordModel.changePassword(getView().getContext(), countryCode, locale,
                changePasswordBody, new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                if (response.body() != null) {
                                    getView().showSuccessMessage(response.body().getMessage());
                                    getView().clearAllTextInEditTextViews();
                                }
                            }
                        } else {
                            if (response.code() == HttpURLConnection.HTTP_BAD_REQUEST) {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }
}
