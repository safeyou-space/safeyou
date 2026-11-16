package fambox.pro.view;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
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
    @BindView(R.id.btnPrrivateMessage)
    ToggleButton btnPrrivateMessage;
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
            configToggle(false, false, false, false, false, false);
        });
        boolean isOpenedFromMenu = false;
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            isOpenedFromMenu = bundle.getBoolean("is_opened_from_menu");
        }

        addAppBar(null, false, true,
                !isOpenedFromMenu, getResources().getString(R.string.title_tutorial), false);

        btnNextHelp.setVisibility(!isOpenedFromMenu ? View.VISIBLE : View.GONE);

        int helpImageSize = getResources().getDimensionPixelSize(R.dimen._30sdp);

        Drawable helpDrawable = getDrawable(R.drawable.new_help_totorial_icon);
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
        showInfoDialog.show();
        showInfoDialog.setTxtDescription(infoDialogText);
    }


    @OnCheckedChanged({R.id.btnDualPin, R.id.btnInfo, R.id.btnForums, R.id.btnNGO, R.id.btnHelp, R.id.btnPrrivateMessage})
    void onRadioButtonCheckChanged(CompoundButton button, boolean checked) {
        mHelpPresenter.configToggleButton(button.getId(), checked);
    }

    @Override
    public void configToggle(boolean dualPin, boolean info, boolean help, boolean forum, boolean ngo, boolean prvtMessage) {
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

        btnPrrivateMessage.setChecked(prvtMessage);
        btnPrrivateMessage.setElevation(mHelpPresenter.getElevation(prvtMessage));
    }

    @Override
    public ToggleButton button(int viewId) {
        return findViewById(viewId);
    }

    public void nextClick() {
        nextActivity(this, LoginPageActivity.class);
    }
}
