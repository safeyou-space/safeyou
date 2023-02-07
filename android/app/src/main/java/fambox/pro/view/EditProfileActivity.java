package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_MARITAL_STATUS;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ToggleButton;

import com.bumptech.glide.Glide;
import com.google.android.material.textfield.TextInputEditText;
import com.nabinbhandari.android.permissions.PermissionHandler;
import com.nabinbhandari.android.permissions.Permissions;

import java.util.ArrayList;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.EditProfilePresenter;
import fambox.pro.utils.Utils;
import fambox.pro.view.dialog.ChangePhotoDialog;
import in.mayanknagwanshi.imagepicker.imageCompression.ImageCompressionListener;
import in.mayanknagwanshi.imagepicker.imagePicker.ImagePicker;

public class EditProfileActivity extends BaseActivity implements EditProfileContract.View {

    private EditProfilePresenter mEditProfilePresenter;
    private ImagePicker mImagePicker;
    private String maritalStatus;

    @BindView(R.id.edtChangeNickName)
    TextInputEditText edtChangeNickName;
    @BindView(R.id.imgUserForChange)
    ImageView imgUserForChange;

    @BindView(R.id.edtFirstName)
    TextInputEditText edtFirstName;
    @BindView(R.id.edtLastName)
    TextInputEditText edtLastName;
    @BindView(R.id.txtMaritalStatus)
    TextView txtMaritalStatus;
    @BindView(R.id.txtUserIdStatus)
    TextView txtUserIdStatus;
    @BindView(R.id.edtPhoneNumber)
    TextView edtPhoneNumber;
    @BindView(R.id.edtLocation)
    TextInputEditText edtLocation;
    @BindView(R.id.btnEditFirstName)
    ToggleButton btnEditFirstName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        addAppBar(null, false, true, false,
                getResources().getString(R.string.profile_title_key), true);
        ButterKnife.bind(this);
        mEditProfilePresenter = new EditProfilePresenter();
        mEditProfilePresenter.attachView(this);
        mEditProfilePresenter.viewIsReady();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_edit_profile;
    }

    @Override
    protected void onResume() {
        super.onResume();
        showProgress();
        if (mEditProfilePresenter != null) {
            mEditProfilePresenter.getProfile(getCountryCode(), LocaleHelper.getLanguage(getContext()));
        }
    }

    @Override
    protected void onActivityResult(int requestCode, final int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == ImagePicker.SELECT_IMAGE && resultCode == Activity.RESULT_OK) {
            try {
                mImagePicker.addOnCompressListener(new ImageCompressionListener() {
                    @Override
                    public void onStart() {
                    }

                    @Override
                    public void onCompressed(String s) {
                        mEditProfilePresenter.editProfileDetail(getCountryCode(), LocaleHelper.getLanguage(getContext()), s);
                    }
                });

                String filePath = mImagePicker.getImageFilePath(data);
                if (filePath != null) {
                    mEditProfilePresenter.editProfileDetail(getCountryCode(), LocaleHelper.getLanguage(getContext()), filePath);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mEditProfilePresenter != null) {
            mEditProfilePresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mEditProfilePresenter != null) {
            mEditProfilePresenter.destroy();
        }
    }

    @OnClick(R.id.btnChangeImage)
    void openChangeDialog() {
        initDialog();
    }

    @OnCheckedChanged({R.id.btnEditFirstName, R.id.btnEditSurname, R.id.btnEditLocation, R.id.btnChangeNickName})
    void onRadioButtonCheckChanged(CompoundButton button, boolean checked) {
        switch (button.getId()) {
            case R.id.btnEditFirstName:
                mEditProfilePresenter.configEditText(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                        this, edtFirstName, checked, button.getId());
                break;
            case R.id.btnEditSurname:
                mEditProfilePresenter.configEditText(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                        this, edtLastName, checked, button.getId());
                break;
            case R.id.btnEditLocation:
                mEditProfilePresenter.configEditText(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                        this, edtLocation, checked, button.getId());
                break;
            case R.id.btnChangeNickName:
                mEditProfilePresenter.configEditText(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                        this, edtChangeNickName, checked, button.getId());
                break;
        }
    }

    @OnClick(R.id.containerEditMaritalStatus)
    void onClickMaritalButton() {
        Bundle bundle = new Bundle();
        bundle.putString(KEY_MARITAL_STATUS, maritalStatus);
        nextActivity(this, MaritalStatusActivity.class, bundle);
    }

    @OnClick(R.id.btnEditPhoneNumber)
    void clickEditPhoneNumber() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(Constants.Key.KEY_CHANGE_PHONE_NUMBER, true);
        nextActivity(this, ForgotChangePassActivity.class, bundle);
    }

    @Override
    public void setFirstName(String text) {
        edtFirstName.setText(text);
    }

    @Override
    public void setLastName(String text) {
        edtLastName.setText(text);
    }

    @Override
    public void setUserId(String id) {
        txtUserIdStatus.setText(id);
    }

    @Override
    public void setEmail(String text) {
        txtMaritalStatus.setText(text);
        maritalStatus = text;
    }

    @Override
    public void setMobilePhone(String text) {
        edtPhoneNumber.setText(text);
    }

    @Override
    public void setLocation(String text) {
        edtLocation.setText(text);
    }

    @Override
    public void setNickname(String nickname) {
        edtChangeNickName.setText(nickname);
    }

    @Override
    public void setMaritalStatus(String text) {
        txtMaritalStatus.setText(text);
        maritalStatus = text;
    }

    @Override
    public void setImage(String imagePath) {
        Glide.with(this)
                .asBitmap()
                .load(imagePath.isEmpty() ? R.drawable.avatar : imagePath)
                .placeholder(R.drawable.profile_bottom_icon)
                .error(R.drawable.profile_bottom_icon)
                .into(imgUserForChange);
    }

    @Override
    public void initDialog() {
        ChangePhotoDialog mChangePhotoDialog = new ChangePhotoDialog(this);
        Objects.requireNonNull(mChangePhotoDialog.getWindow())
                .setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        mChangePhotoDialog.setEditPhotoListener(new ChangePhotoDialog.EditPhotoListener() {
            @Override
            public void takeNewPhoto() {
                Permissions.check(EditProfileActivity.this,
                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA},
                        null, null, new PermissionHandler() {
                            @Override
                            public void onGranted() {
                                mImagePicker = new ImagePicker();
                                mImagePicker.withActivity(EditProfileActivity.this)
                                        .chooseFromCamera(true)
                                        .chooseFromGallery(false)
                                        .withCompression(true)
                                        .start();
                            }

                            @Override
                            public void onDenied(Context context, ArrayList<String> deniedPermissions) {

                            }
                        });

            }

            @Override
            public void selectFromGallery() {
                Permissions.check(EditProfileActivity.this,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        null, new PermissionHandler() {
                            @Override
                            public void onGranted() {
                                mImagePicker = new ImagePicker();
                                mImagePicker.withActivity(EditProfileActivity.this)
                                        .chooseFromCamera(false)
                                        .chooseFromGallery(true)
                                        .withCompression(true)
                                        .start();
                            }

                            @Override
                            public void onDenied(Context context, ArrayList<String> deniedPermissions) {

                            }
                        });
            }

            @Override
            public void removePhoto() {
                mEditProfilePresenter.removeProfileImage(getCountryCode(), LocaleHelper.getLanguage(getContext()));
            }
        });
        mChangePhotoDialog.show();
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
    public void showProgress() {
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.VISIBLE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void dismissProgress() {
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.GONE));
        } catch (Exception ignore) {
        }
    }
}
