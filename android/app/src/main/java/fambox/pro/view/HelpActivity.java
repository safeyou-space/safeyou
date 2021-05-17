package fambox.pro.view;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.RelativeSizeSpan;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.widget.ToggleButton;

import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.HelpPresenter;
import fambox.pro.utils.Utils;
import fambox.pro.view.dialog.ShowInfoDialog;

public class HelpActivity extends BaseActivity implements HelpContract.View {

    private ShowInfoDialog showInfoDialog;
    private HelpPresenter mHelpPresenter;

    @BindView(R.id.btnInfo)
    ToggleButton btnInfo;
    @BindView(R.id.btnDualPin)
    ToggleButton btnDualPin;
    @BindView(R.id.btnForums)
    ToggleButton btnForums;
    @BindView(R.id.btnNGO)
    ToggleButton btnNGO;
    @BindView(R.id.btnHelp)
    ToggleButton btnHelp;
    @BindView(R.id.btnNextHelp)
    TextView btnNextHelp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        mHelpPresenter = new HelpPresenter();
        mHelpPresenter.attachView(this);
        mHelpPresenter.viewIsReady();
        if (Objects.equals(getCountryCode(), "geo") || Objects.equals(getLocale(), "ka")) {
            btnHelp.setText("SOS");
            btnHelp.setTextOn("SOS");
            btnHelp.setTextOff("SOS");
        }
        showInfoDialog = new ShowInfoDialog(this);
        showInfoDialog.setOnCancelListener(dialog -> {
            //do whatever you want the back key to do
            configToggle(false, false, false, false, false);
        });
//        if (!SafeYouApp.getPreference(this).getBooleanValue(KEY_LOG_IN_FIRST_TIME, false)) {
//            configToggle(false, false, true, false, false);
//            openDialog(Types.InfoDialogText.TEXT_HELP);
//        }

        boolean isOpenedFromMenu = false;
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            isOpenedFromMenu = bundle.getBoolean("is_opened_from_menu");
        }
        addAppBar(null, false, true,
                !isOpenedFromMenu, getResources().getString(R.string.login_help), false);

        btnNextHelp.setVisibility(!isOpenedFromMenu ? View.VISIBLE : View.GONE);

        int helpImageSize = getResources().getDimensionPixelSize(R.dimen._30sdp);

//        String dualPinText = getResources().getString(R.string.dual_pin);

//        Spannable word = new SpannableString(dualPinText);
//        word.setSpan(new RelativeSizeSpan(0.7f), !dualPinText.contains("\n")
//                        ? 0 : dualPinText.indexOf("\n"), dualPinText.length(),
//                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
//        btnDualPin.setText(word);

        Drawable helpDrawable = getDrawable(R.drawable.icon_tutorial_help);
        if (helpDrawable != null) {
            helpDrawable.setBounds(0, 0, helpImageSize, helpImageSize);
            btnHelp.setCompoundDrawables(helpDrawable, null, null, null);
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_help;
    }

    @OnClick(R.id.btnNextHelp)
    void onCliCkNext() {
        nextClick();
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mHelpPresenter != null) {
            mHelpPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mHelpPresenter != null) {
            mHelpPresenter.destroy();
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


    @Override
    public void openDialog(Types.InfoDialogText infoDialogText) {
        if (showInfoDialog.isShowing()) {
            showInfoDialog.dismiss();
        }
        Objects.requireNonNull(showInfoDialog.getWindow())
                .setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        Window window = showInfoDialog.getWindow();
        window.setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
//        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        showInfoDialog.show();
//        WindowManager.LayoutParams params = showInfoDialog.getWindow().getAttributes();
//        params.x = (int) button.getX();
//        params.y = (int) button.getY();
//        params.gravity = Gravity.START | Gravity.END | Gravity.BOTTOM;
//        showInfoDialog.getWindow().setAttributes(params);
        showInfoDialog.setTxtDescription(infoDialogText);
    }


    @OnCheckedChanged({R.id.btnDualPin, R.id.btnInfo, R.id.btnForums, R.id.btnNGO, R.id.btnHelp})
    void onRadioButtonCheckChanged(CompoundButton button, boolean checked) {
        mHelpPresenter.configToggleButton(button.getId(), checked);
    }

    @Override
    public void configToggle(boolean dualPin, boolean info, boolean help, boolean forum, boolean ngo) {
        btnDualPin.setChecked(dualPin);
        btnDualPin.setElevation(mHelpPresenter.getElevation(dualPin));

        btnInfo.setChecked(info);
        btnInfo.setElevation(mHelpPresenter.getElevation(info));

        btnForums.setChecked(forum);
        btnForums.setElevation(mHelpPresenter.getElevation(forum));

        btnNGO.setChecked(ngo);
        btnNGO.setElevation(mHelpPresenter.getElevation(ngo));

        btnHelp.setChecked(help);
        btnHelp.setElevation(mHelpPresenter.getElevation(help));
    }

    @Override
    public ToggleButton button(int viewId) {
        return findViewById(viewId);
    }

    public void nextClick() {
        nextActivity(this, LoginPageActivity.class);
    }
}
