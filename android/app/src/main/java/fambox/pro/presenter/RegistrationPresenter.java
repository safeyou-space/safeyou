package fambox.pro.presenter;

import android.text.Editable;

import java.util.Objects;

import fambox.pro.R;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.Utils;
import fambox.pro.view.RegistrationContract;

public class RegistrationPresenter extends BasePresenter<RegistrationContract.View> {

    @Override
    public void viewIsReady() {
    }

    public void checkFields(Editable firstName, Editable lastName,
                            Editable nickname, int marred,
                            String phone, Editable birthday,
                            Editable password, Editable confirmPassword) {
        String firstNameS = Utils.getEditableToString(firstName);
        String lastNameS = Utils.getEditableToString(lastName);
        String nicknameS = Utils.getEditableToString(nickname);
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
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.please_enter_valid_password_message_key));
        } else if (!passwordS.equals(confirmPasswordS)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.passwords_not_match_text_key));
        } else {
            if (!Connectivity.isConnected(getView().getContext())) {
                getView().showErrorMessage(getView().getContext().getResources().getString(R.string.check_internet_connection_text_key));
                return;
            }
            RegistrationBody registrationBody = new RegistrationBody();
            registrationBody.setFirstName(firstNameS);
            registrationBody.setLastName(lastNameS);
            if (!Objects.equals(nicknameS, "")) {
                registrationBody.setNickname(nicknameS);
            }
            registrationBody.setMarital_status(marred);
            registrationBody.setPhone(phone);
            registrationBody.setBirthday(birthdayS);
            registrationBody.setPassword(passwordS);
            registrationBody.setConfirmPassword(confirmPasswordS);
            getView().goTermsAndConditions(registrationBody);
        }

    }
}
