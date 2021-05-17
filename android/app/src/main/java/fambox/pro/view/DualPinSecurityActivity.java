package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.presenter.DualPinSecurityPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.dialog.SecurityQuestionDialog;

public class DualPinSecurityActivity extends BaseActivity implements DualPinSecurityContract.View {

    @BindView(R.id.edtRealPin)
    TextInputEditText edtRealPin;
    @BindView(R.id.edtConfirmRealPin)
    TextInputEditText edtConfirmRealPin;
    @BindView(R.id.edtFakePin)
    TextInputEditText edtFakePin;
    @BindView(R.id.edtConfirmFakePin)
    TextInputEditText edtConfirmFakePin;
    @BindView(R.id.pinSwitch)
    Switch pinSwitch;
    @BindView(R.id.dualPinDisableView)
    View dualPinDisableView;
    @BindView(R.id.pinSwitchTitle)
    TextView pinSwitchTitle;

    private DualPinSecurityPresenter mDualPinSecurityPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false,
                true, false,
                getResources().getString(R.string.dual_pin_security), true);
        mDualPinSecurityPresenter = new DualPinSecurityPresenter();
        mDualPinSecurityPresenter.attachView(this);
        mDualPinSecurityPresenter.initBundle(getIntent().getExtras());
        mDualPinSecurityPresenter.viewIsReady();

        boolean isDualPinEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_WITHOUT_PIN, false);
        pinSwitchTitle.setText(isDualPinEnabled ? getResources().getString(R.string.edit_deactivate_dual_pin)
                : getResources().getString(R.string.add_a_new_dual_pin));
        pinSwitch.setChecked(isDualPinEnabled);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_dual_pin_security;
    }

    @OnClick(R.id.btnSubmit)
    void clickSubmit() {
        boolean isDualPinEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_IS_CAMOUFLAGE_ICON_ENABLED, false);
        if (!isDualPinEnabled && pinSwitch.isChecked() && !mDualPinSecurityPresenter.isSaveCamouflageIcon()) {
            StringBuilder message = new StringBuilder();
            if (mDualPinSecurityPresenter.checkFields(message,
                    edtRealPin.getText(), edtConfirmRealPin.getText(),
                    edtFakePin.getText(), edtConfirmFakePin.getText())) {
                showPopup();
            } else {
                showErrorMessage(message.toString());
            }
            return;
        }

        onSubmit(true);
    }

    @Override
    public void showPopup() {
        SecurityQuestionDialog securityQuestionDialog = new SecurityQuestionDialog(this, true);
        securityQuestionDialog.setDialogClickListener((dialog, which) -> {
            switch (which) {
                case SecurityQuestionDialog.CLICK_CLOSE:
                    dialog.dismiss();
                    break;
                case SecurityQuestionDialog.CLICK_CANCEL:
                    onSubmit(true);
                    dialog.dismiss();
                    break;
                case SecurityQuestionDialog.CLICK_CONTINUE:
                    onSubmit(false);
                    goBack();
                    dialog.dismiss();
                    nextActivity(DualPinSecurityActivity.this, ChangeAppIconActivity.class);
                    break;
            }
        });
        securityQuestionDialog.show();
    }

    @Override
    public void onSubmit(boolean save) {
        mDualPinSecurityPresenter.checkRealFakePin(save, pinSwitch.isChecked(),
                edtRealPin.getText(), edtConfirmRealPin.getText(),
                edtFakePin.getText(), edtConfirmFakePin.getText());
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        goBack();
    }

    @OnCheckedChanged(R.id.pinSwitch)
    void switchDualPin(CompoundButton button, boolean checked) {
        dualPinDisableView.setVisibility(checked ? View.GONE : View.VISIBLE);
        edtRealPin.setEnabled(checked);
        edtConfirmRealPin.setEnabled(checked);
        edtFakePin.setEnabled(checked);
        edtConfirmFakePin.setEnabled(checked);
    }

    @Override
    public void goBack() {
        onBackPressed();
    }

    @Override
    public void finishCamouflageActivity() {
        setResult(Activity.RESULT_OK);
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
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