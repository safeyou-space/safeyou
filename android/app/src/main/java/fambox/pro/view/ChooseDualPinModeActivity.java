package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.enums.Types;
import fambox.pro.presenter.ChooseDualPinModePresenter;
import fambox.pro.utils.Utils;

public class ChooseDualPinModeActivity extends BaseActivity implements ChooseDualPinModeContract.View {

    private ChooseDualPinModePresenter mChooseDualPinModePresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        ButterKnife.bind(this);
        mChooseDualPinModePresenter = new ChooseDualPinModePresenter();
        mChooseDualPinModePresenter.attachView(this);
        mChooseDualPinModePresenter.viewIsReady();
        addAppBar(null,true,
                true,false,null,false);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_choose_dual_pin_mode;
    }

    @OnClick(R.id.btnWithoutDualPin)
    void continueWithoutDualPin(){
        mChooseDualPinModePresenter.login(getIntent().getExtras(), getCountryCode(), getLocale());
    }

    @OnClick(R.id.btnAddDualPin)
    void continueWithDualPin(){
        SafeYouApp.getPreference(this).setValue(Constants.Key.KEY_WITHOUT_PIN, true);
        nextActivity(this, DualPinActivity.class);
    }

    @Override
    public void goMainActivity() {
        SafeYouApp.getPreference(this).setValue(Constants.Key.KEY_WITHOUT_PIN, false);
        nextActivity(this, MainActivity.class);
        finishAffinity();
    }

    @Override
    public void goLoginPage() {
        nextActivity(this, LoginPageActivity.class);
        finishAffinity();
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mChooseDualPinModePresenter != null) {
            mChooseDualPinModePresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mChooseDualPinModePresenter != null) {
            mChooseDualPinModePresenter.destroy();
        }
    }
}
