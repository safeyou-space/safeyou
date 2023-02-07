package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.LoginPagePresenter;
import fambox.pro.utils.Utils;

public class LoginPageActivity extends BaseActivity implements LoginPageContract.View {

    private LoginPagePresenter mLoginPagePresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        addAppBar(null, true, true, false,
                null, false);
        ButterKnife.bind(this);
        mLoginPagePresenter = new LoginPagePresenter();
        mLoginPagePresenter.attachView(this);
        mLoginPagePresenter.viewIsReady();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_login_page;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mLoginPagePresenter != null) {
            mLoginPagePresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mLoginPagePresenter != null) {
            mLoginPagePresenter.destroy();
        }
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }

    @OnClick(R.id.btnLogin)
    void loginClick() {
        nextActivity(this, LoginWithBackActivity.class);
    }

    @OnClick(R.id.btnSignUp)
    void signUpClick() {
        nextActivity(this, RegistrationActivity.class);
    }

}
