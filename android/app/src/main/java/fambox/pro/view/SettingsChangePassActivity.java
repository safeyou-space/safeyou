package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.widget.EditText;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.SettingsChangePassPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;

public class SettingsChangePassActivity extends BaseActivity implements SettingsChangePassContract.View {

    private SettingsChangePassPresenter mSettingsChangePassPresenter;

    @BindView(R.id.edtCurrentPass)
    EditText edtCurrentPass;
    @BindView(R.id.edtNewPass)
    EditText edtNewPass;
    @BindView(R.id.edtReTypePass)
    EditText edtReTypePass;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        addAppBar(null, false, true,
                false, getResources().getString(R.string.password_text_key), true);
        ButterKnife.bind(this);
        mSettingsChangePassPresenter = new SettingsChangePassPresenter();
        mSettingsChangePassPresenter.attachView(this);
        mSettingsChangePassPresenter.viewIsReady();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_settings_change_pass;
    }


    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mSettingsChangePassPresenter != null) {
            mSettingsChangePassPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mSettingsChangePassPresenter != null) {
            mSettingsChangePassPresenter.destroy();
        }
    }

    @OnClick(R.id.btnSaveChanges)
    void saveChangesClick() {
        mSettingsChangePassPresenter.newPassValidation(getCountryCode(), getLocale(),
                edtCurrentPass.getText(), edtNewPass.getText(), edtReTypePass.getText());
    }

    @OnClick(R.id.btnForgotPass)
    void btnForgotPass() {
        nextActivity(this, ForgotChangePassActivity.class);
    }

    @Override
    public void clearAllTextInEditTextViews() {
        edtCurrentPass.setText("");
        edtNewPass.setText("");
        edtReTypePass.setText("");
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
