package fambox.pro.view;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.PassKeypadPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import in.arjsna.passcodeview.PassCodeView;
import me.zhanghai.android.materialprogressbar.MaterialProgressBar;

public class PassKeypadActivity extends BaseActivity implements PassKeypadContract.View {


    private PassKeypadPresenter mPassKeypadPresenter;
    @BindView(R.id.btnForgetPin)
    Button btnForgotPin;
    @BindView(R.id.progress)
    MaterialProgressBar progress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        addAppBar(null, true, false,
                false, null, false);
        ButterKnife.bind(this);
        mPassKeypadPresenter = new PassKeypadPresenter();
        mPassKeypadPresenter.attachView(this);
        mPassKeypadPresenter.checkOpenedFromNotification(getIntent().getExtras());
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mPassKeypadPresenter != null) {
            mPassKeypadPresenter.viewIsReady();
        }
    }

    @Override
    public void setProgressVisibility(int visibility) {
        progress.setVisibility(visibility);
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mPassKeypadPresenter != null) {
            mPassKeypadPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mPassKeypadPresenter != null) {
            mPassKeypadPresenter.destroy();
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_pass_keypad;
    }

    @Override
    public PassCodeView getPassCodeView() {
        return findViewById(R.id.passCodeView);

    }

    @Override
    public void goProfileActivity() {
        nextActivity(this, MainActivity.class);
        finishAffinity();
    }

    @Override
    public void goCommentActivity(Bundle bundle) {
        nextActivity(this, ForumCommentActivity.class, bundle);
        finish();
    }

    @Override
    public void goMainActivity(Bundle bundle) {
        nextActivity(this, MainActivity.class, bundle);
        finish();
    }

    @Override
    public void goSystemGalleryActivity() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.addCategory(Intent.CATEGORY_APP_GALLERY);
        startActivity(intent);
        finishAffinity();
    }

    @Override
    public void goLoginActivity() {
        nextActivity(this, LoginWithBackActivity.class);
        finishAffinity();
    }

    @Override
    public void showForgotPinButton(int visibility) {
        btnForgotPin.setVisibility(visibility);
    }

    @OnClick(R.id.btnForgetPin)
    void forgotPinClick() {
        mPassKeypadPresenter.clearPreference();
    }

    @Override
    public void onBackPressed() {
        if (mPassKeypadPresenter.isLocked()) {
            Intent i = new Intent();
            i.setAction(Intent.ACTION_MAIN);
            i.addCategory(Intent.CATEGORY_HOME);
            this.startActivity(i);
            super.onBackPressed();
        } else {
            super.onBackPressed();
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

    }
}
