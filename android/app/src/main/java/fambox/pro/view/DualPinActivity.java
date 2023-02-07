package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_CHANGE_PIN;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.google.android.material.textfield.TextInputEditText;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.DualPinPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;

public class DualPinActivity extends BaseActivity implements DualPinContract.View {

    private DualPinPresenter mDualPinPresenter;
    private boolean isSettings;

    @BindView(R.id.edtRealPin)
    TextInputEditText edtRealPin;
    @BindView(R.id.edtConfirmRealPin)
    TextInputEditText edtConfirmRealPin;
    @BindView(R.id.edtFakePin)
    TextInputEditText edtFakePin;
    @BindView(R.id.edtConfirmFakePin)
    TextInputEditText edtConfirmFakePin;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        mDualPinPresenter = new DualPinPresenter();
        mDualPinPresenter.attachView(this);
        mDualPinPresenter.viewIsReady();
        if (isSettings) {
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
            addAppBar(null, false, true, false,
                    null, false);
        } else {
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
            addAppBar(null, true, true, false,
                    null, false);
        }
    }

    @Override
    protected int getLayout() {
        if (getIntent().getExtras() != null) {
            isSettings = getIntent().getExtras().getBoolean(KEY_CHANGE_PIN);
            if (isSettings) {
                return R.layout.activity_dual_pin_settings;
            }
        }
        return R.layout.activity_dual_pin;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mDualPinPresenter != null) {
            mDualPinPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mDualPinPresenter != null) {
            mDualPinPresenter.destroy();
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

    @OnClick(R.id.btnSubmit)
    void clickSubmit() {
        mDualPinPresenter.checkRealFakePin(getCountryCode(), getLocale(), edtRealPin.getText(), edtConfirmRealPin.getText(),
                edtFakePin.getText(), edtConfirmFakePin.getText(), isSettings);
    }

    @Override
    public void goMainActivity() {
        if (isSettings) {
            setResult(Activity.RESULT_OK, new Intent());
            finish();
        } else {
            nextActivity(this, PassKeypadActivity.class);
            finishAffinity();
        }

    }

    @Override
    public void goLoginPage() {
        nextActivity(this, LoginPageActivity.class);
        finishAffinity();
    }

    public void backCanceledIntent() {
        resultCanceledIntent();
        onBackPressed();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        resultCanceledIntent();
    }

    private void resultCanceledIntent() {
        Intent returnIntent = new Intent();
        returnIntent.putExtra("is_canceled", true);
        setResult(Activity.RESULT_CANCELED, returnIntent);
        finish();
    }
}
