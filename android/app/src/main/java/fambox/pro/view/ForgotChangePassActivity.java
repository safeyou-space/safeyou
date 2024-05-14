
package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.hbb20.CountryCodePicker;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.ForgotChangePassPresenter;
import fambox.pro.utils.EditableUtils;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;

public class ForgotChangePassActivity extends BaseActivity implements ForgotChangePassContract.View {

    private ForgotChangePassPresenter mForgotChangePassPresenter;
    private boolean isPhone;

    @BindView(R.id.txtForgetPass)
    TextView txtForgetPass;
    @BindView(R.id.textInputLayoutLogin)
    TextInputLayout textInputLayoutLogin;
    @BindView(R.id.textInputLayoutPassword)
    TextInputLayout textInputLayoutPassword;
    @BindView(R.id.edtLogin)
    TextInputEditText edtLogin;
    @BindView(R.id.edtPassword)
    TextInputEditText edtPassword;
    @BindView(R.id.btnRequestNewPass)
    Button btnRequestNewPass;
    @BindView(R.id.countryPicker)
    CountryCodePicker countryPicker;
    private String countryCode;
    private TextWatcher changeListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        addAppBar(null, true, true, false, null, false);
        ButterKnife.bind(this);
        btnRequestNewPass.setText(getString(R.string.title_request_new_password));
        txtForgetPass.setText(getString(R.string.title_forgot_password));
        mForgotChangePassPresenter = new ForgotChangePassPresenter();
        mForgotChangePassPresenter.attachView(this);
        mForgotChangePassPresenter.viewIsReady();
        countryPicker.setCcpClickable(false);
        int maxPhoneNumber = 9;
        switch (getCountryCode()) {
            case "geo":
                countryCode = "GE";
                maxPhoneNumber = 10;
                break;
            case "arm":
                countryCode = "AM";
                maxPhoneNumber = 8;
                break;
            case "irq":
                countryCode = "IQ";
                maxPhoneNumber = 10;
                break;
            case "zwe":
                countryCode = "ZW";
                maxPhoneNumber = 9;
                break;
        }
        countryPicker.setCountryForNameCode(countryCode);
        countryPicker.showArrow(false);

        int finalMaxPhoneNumber = maxPhoneNumber;
        countryPicker.registerCarrierNumberEditText(edtLogin);
        changeListener = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                int length = EditableUtils.getCharacterCountWithoutSpaces(editable);
                if (length > finalMaxPhoneNumber) {
                    int selectionEnd = edtLogin.getSelectionEnd();
                    int selectionStart = edtLogin.getSelectionStart();
                    editable.delete(selectionStart - (length - finalMaxPhoneNumber), selectionEnd);
                    countryPicker.registerCarrierNumberEditText(edtLogin);
                }

            }
        };
        mForgotChangePassPresenter.initBundle(getIntent().getExtras());
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_forgot_change_pass;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mForgotChangePassPresenter != null) {
            mForgotChangePassPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mForgotChangePassPresenter != null) {
            mForgotChangePassPresenter.destroy();
        }
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    @OnClick(R.id.btnRequestNewPass)
    void requestNewPass() {
        if (textInputLayoutPassword.getVisibility() == View.VISIBLE) {
            mForgotChangePassPresenter.changePasswordWithForgot(getCountryCode(), LocaleHelper.getLanguage(getContext()), getPhoneNumber(), edtPassword.getText());
        } else if (isPhone) {
            mForgotChangePassPresenter.editPhoneNumber(getCountryCode(), LocaleHelper.getLanguage(getContext()), getPhoneNumber());
        } else {
            mForgotChangePassPresenter.onClickNewPass(getCountryCode(), LocaleHelper.getLanguage(getContext()), getPhoneNumber());
        }
    }

    @Override
    public void goLoginPage() {
        nextActivity(this, LoginWithBackActivity.class);
        finishAffinity();
    }

    @Override
    public void goVerificationActivity(Bundle bundle) {
        nextActivity(this, VerificationActivity.class, bundle);
    }

    @Override
    public void configView(String title, String createNewPassword, String confirmNewPassword) {
        btnRequestNewPass.setText(getString(R.string.update_password_title));
        textInputLayoutPassword.setVisibility(View.VISIBLE);
        countryPicker.setVisibility(View.GONE);
        txtForgetPass.setText(title);
        textInputLayoutLogin.setHint(createNewPassword);
        textInputLayoutPassword.setHint(confirmNewPassword);
        edtLogin.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD);
        edtLogin.setTransformationMethod(PasswordTransformationMethod.getInstance());
        edtLogin.setText("");
        edtLogin.removeTextChangedListener(changeListener);
        countryPicker.deregisterCarrierNumberEditText();
    }


    @Override
    public void configViewForPhone(String title, String btnText, boolean isPhone) {
        txtForgetPass.setText(title);
        btnRequestNewPass.setText(btnText);
        this.isPhone = isPhone;
    }

    private String getPhoneNumber() {
        String number = Utils.getEditableToString(edtLogin.getEditableText());
        if (number.isEmpty()) {
            return "";
        } else if (countryPicker.getVisibility() == View.GONE) {
            return number;
        } else {
            return countryPicker.getFullNumberWithPlus();
        }
    }

}
