package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

import com.google.android.material.textfield.TextInputEditText;
import com.hbb20.CountryCodePicker;

import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.LoginWithBackPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;


public class LoginWithBackActivity extends BaseActivity implements LoginWithBackContract.View {

    private LoginWithBackPresenter mLoginWithBackPresenter;

    @BindView(R.id.edtLogin)
    TextInputEditText edtLogin;
    @BindView(R.id.edtPassword)
    TextInputEditText edtPassword;
    @BindView(R.id.countryPicker)
    CountryCodePicker countryPicker;
    private String countryCode;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        addAppBar(null, true, true,
                false, null, false);
        ButterKnife.bind(this);
        mLoginWithBackPresenter = new LoginWithBackPresenter();
        mLoginWithBackPresenter.attachView(this);
        mLoginWithBackPresenter.viewIsReady();
        edtLogin.setSelection(Objects.requireNonNull(edtLogin.getText()).length());
        switch (getCountryCode()) {
            case "geo":
                countryCode = "GE";
                break;
            case "arm":
                countryCode = "AM";
                break;
            case "irq":
                countryCode = "IQ";
                break;
        }
        countryPicker.setCcpClickable(false);
        countryPicker.setCountryForNameCode(countryCode);
        countryPicker.showArrow(false);

    }

    @Override
    protected int getLayout() {
        return R.layout.activity_login_with_back;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mLoginWithBackPresenter != null) {
            mLoginWithBackPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mLoginWithBackPresenter != null) {
            mLoginWithBackPresenter.destroy();
        }
    }

    @OnClick(R.id.btnForgotPass)
    void btnForgotPass() {
        nextActivity(this, ForgotChangePassActivity.class);
    }

    @OnClick(R.id.btnSignUp)
    void signUp() {
        nextActivity(this, RegistrationActivity.class);
    }

    @OnClick(R.id.btnLoginWithBAck)
    void loginWithBAck() {
        mLoginWithBackPresenter.loginRequest(getCountryCode(), getLocale(), getPhoneNumber(), edtPassword.getText());
    }

    private String getPhoneNumber() {
        String number = Utils.getEditableToString(edtLogin.getEditableText());
        if (number.isEmpty()) {
            return "";
        } else {
            countryPicker.registerCarrierNumberEditText(edtLogin);
            return countryPicker.getFullNumberWithPlus();
        }
    }

    @Override
    public void goDualPinScreen() {
        nextActivity(this, MainActivity.class);
        finishAffinity();
    }

    @Override
    public void verify(Bundle bundle) {
        nextActivity(this, VerificationActivity.class, bundle);
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showProgress() {
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.VISIBLE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void dismissProgress() {
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.GONE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }
}
