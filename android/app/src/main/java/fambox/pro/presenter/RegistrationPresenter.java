package fambox.pro.presenter;

import android.text.Editable;
import android.util.Log;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.RegistrationModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.RegistrationContract;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;

public class RegistrationPresenter extends BasePresenter<RegistrationContract.View> implements RegistrationContract.Presenter {

    private RegistrationModel mRegistrationModel;

    @Override
    public void viewIsReady() {
        mRegistrationModel = new RegistrationModel();
//        getView().setUpSpinner();
    }

    @Override
    public void submitRegistration(String locale, String countryCode,
                                   Editable firstName, Editable lastName,
                                   Editable nickname, int marred,
                                   String phone, Editable birthday,
                                   Editable password, Editable confirmPassword) {
        String firstNameS = Utils.getEditableToString(firstName);
        String lastNameS = Utils.getEditableToString(lastName);
        String nicknameS = Utils.getEditableToString(nickname);
//        String emailS = Utils.getEditableToString(email);
        String birthdayS = Utils.getEditableToString(birthday);
        String passwordS = Utils.getEditableToString(password);
        String confirmPasswordS = Utils.getEditableToString(confirmPassword);

        if (firstNameS.equals("") || lastNameS.equals("")
                || phone.equals("") || birthdayS.equals("")
                || passwordS.equals("") || confirmPasswordS.equals("")) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.empty_field));
        } else if (!Objects.equals(nicknameS, "") && nicknameS.length() < 2) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.min_length_2));
        } else if ((passwordS.length() < 8) || (confirmPasswordS.length() < 8)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.min_length_8));
        } else if (!passwordS.equals(confirmPasswordS)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.confirm_pass_field));
        } else {
            if (!Connectivity.isConnected(getView().getContext())) {
                getView().showErrorMessage(getView().getContext().getResources().getString(R.string.internet_connection));
                return;
            }

            RegistrationBody registrationBody = new RegistrationBody();
            registrationBody.setFirstName(firstNameS);
            registrationBody.setLastName(lastNameS);
            if (!Objects.equals(nicknameS, "")) {
                registrationBody.setNickname(nicknameS);
            }
            registrationBody.setMarital_status(marred);
//            registrationBody.setEmail(emailS);
            registrationBody.setPhone(phone);
            registrationBody.setBirthday(birthdayS);
            registrationBody.setPassword(passwordS);
            registrationBody.setConfirmPassword(confirmPasswordS);

            mRegistrationModel.registrationRequest(getView().getContext(), countryCode,
                    locale, registrationBody, new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {
                            if (response.isSuccessful()) {
                                if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                    if (response.body() != null) {
                                        SafeYouApp.getPreference(getView().getContext()).setValue(KEY_USER_PHONE, phone);
                                        SafeYouApp.getPreference(getView().getContext()).setValue(KEY_PASSWORD, passwordS);
                                        getView().goVerifyRegistration();
                                    }
                                }
                            }
                        }
                        @Override
                        public void onError(Throwable error) {
                        }
                    });
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mRegistrationModel != null) {
            mRegistrationModel.onDestroy();
        }
    }
}
