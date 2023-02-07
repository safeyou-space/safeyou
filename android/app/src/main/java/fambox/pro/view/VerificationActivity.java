package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.VerificationPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;

public class VerificationActivity extends BaseActivity implements VerificationContract.View {

    private VerificationPresenter mVerificationPresenter;

    @BindView(R.id.btnOTPSignUp)
    Button btnOTPSignUp;
    @BindView(R.id.btnResend)
    Button btnResend;
    @BindView(R.id.txtOTPCountdown)
    TextView txtOTPCountdown;
    @BindView(R.id.txtVerifyingDescription)
    TextView txtVerifyingDescription;
    @BindView(R.id.edtOTP)
    EditText edtOTP;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        addAppBar(null, true, true,
                false, null, false);
        mVerificationPresenter = new VerificationPresenter();
        mVerificationPresenter.attachView(this);
        mVerificationPresenter.viewIsReady();
        mVerificationPresenter.initBundle(getIntent().getExtras(), getCountryCode(), getLocale());
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_verification;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mVerificationPresenter != null) {
            mVerificationPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mVerificationPresenter != null) {
            mVerificationPresenter.destroy();
        }
    }

    @OnClick(R.id.btnResend)
    void onClickResent() {
        mVerificationPresenter.resentActivationCode(getCountryCode(), LocaleHelper.getLanguage(getContext()));
    }

    @Override
    public void setVerificationNumber(String number) {
        txtVerifyingDescription.setText(number);
    }

    @Override
    public void resendCountDownTimer(String time) {
        txtOTPCountdown.setText(time);
    }

    @Override
    public void resendButtonActivation(boolean isClick, int color) {
        btnResend.setClickable(isClick);
        btnResend.setTextColor(color);
    }

    @Override
    public void signUpButtonActivation(boolean isClick, int color) {
        if (isClick) {
            btnOTPSignUp.setOnClickListener(
                    v -> mVerificationPresenter.verification(getCountryCode(), LocaleHelper.getLanguage(getContext()), edtOTP.getText()));
        } else {
            btnOTPSignUp.setOnClickListener(null);
        }
        btnOTPSignUp.setTextColor(color);
    }

    @Override
    public void configNextButton(String btnText) {
        btnOTPSignUp.setText(btnText);
    }

    @Override
    public void setUpEditTextOTP() {
        edtOTP.addTextChangedListener(mVerificationPresenter.otpTextWatcher());
    }

    @Override
    public void goNewPassword(Bundle bundle) {
        nextActivity(this, ForgotChangePassActivity.class, bundle);
    }

    @Override
    public void goToMainActivity() {
        nextActivity(this, MainActivity.class);
        finish();
    }

    @Override
    public void goMainActivity() {
        nextActivity(this, MainActivity.class);
        finishAffinity();
    }

    @Override
    public void goLoginPage() {
        nextActivity(this, LoginPageActivity.class);
        finishAffinity();
    }

    @Override
    public void goBack() {
        onBackPressed();
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
}
