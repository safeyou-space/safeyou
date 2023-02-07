package fambox.pro.view;

import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.view.dialog.PinDeleteDialog;

public class SecurityLoginActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false,
                true, false,
                getResources().getString(R.string.title_security_and_login), true);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_security_login;
    }

    @OnClick(R.id.containerDualPin)
    void onClickDualPin() {
        boolean isPinCodeEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_WITHOUT_PIN, false);
        if (isPinCodeEnabled) {
            PinDeleteDialog pinDeleteDialog = new PinDeleteDialog(this, true);
            if (pinDeleteDialog.getWindow() != null) {
                pinDeleteDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            }
            pinDeleteDialog.setSwitchStateListener((canceled) -> {
                if (canceled) {
                    nextActivity(this, DualPinSecurityActivity.class);
                }
            });
            pinDeleteDialog.show();
        } else {
            nextActivity(this, DualPinSecurityActivity.class);
        }
    }

    @OnClick(R.id.containerCamouflage)
    void onClickCamouflageIcon() {
        nextActivity(this, ChangeAppIconActivity.class);
    }

    @OnClick(R.id.containerChangePassword)
    void clickEditPassword() {
        nextActivity(this, SettingsChangePassActivity.class);
    }
}