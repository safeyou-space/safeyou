package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.RadioButton;
import android.widget.Switch;

import androidx.annotation.Nullable;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.presenter.ChangeAppIconPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.dialog.SecurityQuestionDialog;

public class ChangeAppIconActivity extends BaseActivity implements ChangeAppIconContract.View {

    private ChangeAppIconPresenter mChangeAppIconPresenter;

    @BindView(R.id.camouflageSwitch)
    Switch camouflageSwitch;
    @BindView(R.id.camouflageIconDisableView)
    View camouflageIconDisableView;
    @BindView(R.id.artGalleryRadioButton)
    RadioButton artGalleryRadioButton;
    @BindView(R.id.galleryEditorRadioButton)
    RadioButton galleryEditorRadioButton;
    @BindView(R.id.photoEditorRadioButton)
    RadioButton photoEditorRadioButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false,
                true, false,
                getResources().getString(R.string.camouflage_icon), true);
        mChangeAppIconPresenter = new ChangeAppIconPresenter();
        mChangeAppIconPresenter.attachView(this);
        mChangeAppIconPresenter.viewIsReady();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_change_app_icon;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1010 && resultCode == Activity.RESULT_OK) {
            goBack();
        }
    }

    @OnClick(R.id.btnSubmit)
    void clickSubmit() {
        boolean isPinCodeEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_WITHOUT_PIN, false);
        if (!isPinCodeEnabled && camouflageSwitch.isChecked()) {
            showPopup();
            return;
        }
        onSubmit(true);
    }

    @Override
    public void showPopup() {
        SecurityQuestionDialog securityQuestionDialog = new SecurityQuestionDialog(this, false);
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
                    dialog.dismiss();
                    Bundle bundle = new Bundle();
                    bundle.putBoolean("is_art_gallery_selected", artGalleryRadioButton.isChecked());
                    bundle.putBoolean("is_gallery_edit_selected", galleryEditorRadioButton.isChecked());
                    bundle.putBoolean("is_photo_editor_selected", photoEditorRadioButton.isChecked());
                    Intent intent = new Intent(ChangeAppIconActivity.this, DualPinSecurityActivity.class);
                    intent.putExtras(bundle);
                    startActivityForResult(intent, 1010);
                    break;
            }
        });
        securityQuestionDialog.show();
    }

    @Override
    public void onSubmit(boolean save) {
        mChangeAppIconPresenter.checkRealFakePin(save,
                camouflageSwitch.isChecked(),
                artGalleryRadioButton.isChecked(),
                galleryEditorRadioButton.isChecked(),
                photoEditorRadioButton.isChecked());
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        goBack();
    }

    @OnCheckedChanged(R.id.camouflageSwitch)
    void switchPin(CompoundButton button, boolean checked) {
        camouflageIconDisableView.setVisibility(checked ? View.GONE : View.VISIBLE);
        artGalleryRadioButton.setChecked(checked);
        artGalleryRadioButton.setEnabled(checked);
        galleryEditorRadioButton.setEnabled(checked);
        photoEditorRadioButton.setEnabled(checked);
        if (!checked) {
            artGalleryRadioButton.setChecked(false);
            galleryEditorRadioButton.setChecked(false);
            photoEditorRadioButton.setChecked(false);
        }
    }

    @Override
    public void roundButtonConfig() {
        artGalleryRadioButton.setOnClickListener(view -> {
            galleryEditorRadioButton.setChecked(false);
            photoEditorRadioButton.setChecked(false);
        });

        galleryEditorRadioButton.setOnClickListener(view -> {
            artGalleryRadioButton.setChecked(false);
            photoEditorRadioButton.setChecked(false);
        });

        photoEditorRadioButton.setOnClickListener(view -> {
            galleryEditorRadioButton.setChecked(false);
            artGalleryRadioButton.setChecked(false);
        });

        boolean isCamouflageIconEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_IS_CAMOUFLAGE_ICON_ENABLED, false);
        camouflageSwitch.setChecked(isCamouflageIconEnabled);

        boolean isArtGalleryEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_IS_ART_GALLERY_ENABLED, false);
        boolean isGalleryEditEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_IS_GALLERY_EDIT_ENABLED, false);
        boolean isPhotoEditorEnabled = SafeYouApp.getPreference(this).getBooleanValue(Constants.Key.KEY_IS_PHOTO_EDITOR_ENABLED, false);

        artGalleryRadioButton.setChecked(isArtGalleryEnabled);
        galleryEditorRadioButton.setChecked(isGalleryEditEnabled);
        photoEditorRadioButton.setChecked(isPhotoEditorEnabled);
    }

    @Override
    public void goBack() {
        onBackPressed();
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public Context getPackageContext() {
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