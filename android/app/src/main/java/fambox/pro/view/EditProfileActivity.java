package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_CITY_VILLAGE_TYPE;
import static fambox.pro.Constants.Key.KEY_DO_YOU_HAVE_CHILDREN_TYPE;
import static fambox.pro.Constants.Key.KEY_MARITAL_STATUS;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.ToggleButton;

import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.google.android.material.textfield.TextInputEditText;

import java.util.HashMap;
import java.util.List;
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
import fambox.pro.network.model.ProfileQuestionAnswer;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.presenter.EditProfilePresenter;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.ProfileAnswersListAdapter;
import fambox.pro.view.dialog.ChangeChildCountDialog;
import fambox.pro.view.dialog.ChangePhotoDialog;
import fambox.pro.view.dialog.InfoDialog;
import fambox.pro.view.dialog.ProfileCompletenessDialog;
import in.mayanknagwanshi.imagepicker.ImageSelectActivity;

public class EditProfileActivity extends BaseActivity implements EditProfileContract.View {

    private EditProfilePresenter mEditProfilePresenter;

    private String maritalStatus;

    @BindView(R.id.scrollContainer)
    NestedScrollView scrollContainer;
    @BindView(R.id.edtChangeNickName)
    TextInputEditText edtChangeNickName;
    @BindView(R.id.nickNameErrorIcon)
    AppCompatImageView nickNameErrorIcon;
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

    @BindView(R.id.progressTv)
    AppCompatTextView progressTv;

    @BindView(R.id.profileCompletenessDescription)
    AppCompatTextView profileCompletenessDescription;

    @BindView(R.id.profileCompletenessTitle)
    AppCompatTextView profileCompletenessTitle;

    @BindView(R.id.profileProgress)
    ProgressBar profileProgress;
    @BindView(R.id.btnEditFirstName)
    ToggleButton btnEditFirstName;
    @BindView(R.id.profileCompleteProgress)
    ConstraintLayout profileCompleteProgress;
    @BindView(R.id.profileQuestionAnswersRV)
    RecyclerView profileQuestionAnswersRV;
    @BindView(R.id.profileCompleteProgressContainer)
    ConstraintLayout profileCompleteProgressContainer;
    private ChangeChildCountDialog changeChildCountDialog;
    private boolean isNeedToShowNicknameError;
    private boolean isNeedToShowProfileCompletenessDialog = true;
    private boolean isEditAnswerActivityOpening;

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
        if (getCountryCode().equals("irq")) {
            isNeedToShowProfileCompletenessDialog = false;
            profileCompleteProgress.setVisibility(View.GONE);
            profileQuestionAnswersRV.setVisibility(View.GONE);
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_edit_profile;
    }

    @Override
    protected void onResume() {
        super.onResume();
        showProgress();
        isEditAnswerActivityOpening = false;
        if (mEditProfilePresenter != null) {
            mEditProfilePresenter.getProfile(getCountryCode(), LocaleHelper.getLanguage(getContext()));
        }
    }

    @Override
    protected void onActivityResult(int requestCode, final int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1213 && resultCode == Activity.RESULT_OK) {
            String filePath = data.getStringExtra(ImageSelectActivity.RESULT_FILE_PATH);
            if (filePath != null) {
                mEditProfilePresenter.editProfileDetail(getCountryCode(), LocaleHelper.getLanguage(getContext()), filePath);
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

    @OnCheckedChanged({R.id.btnEditFirstName, R.id.btnEditSurname, R.id.btnChangeNickName})
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
    public void setNickname(String nickname) {
        isNeedToShowNicknameError = nickname == null || nickname.isEmpty();
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
                Intent intent = new Intent(EditProfileActivity.this, ImageSelectActivity.class);
                intent.putExtra(ImageSelectActivity.FLAG_COMPRESS, false);//default is true
                intent.putExtra(ImageSelectActivity.FLAG_CAMERA, true);//default is true
                intent.putExtra(ImageSelectActivity.FLAG_GALLERY, false);//default is true
                nextActivity(intent, 1213);
            }

            @Override
            public void selectFromGallery() {
                Intent intent = new Intent(EditProfileActivity.this, ImageSelectActivity.class);
                intent.putExtra(ImageSelectActivity.FLAG_COMPRESS, false);//default is true
                intent.putExtra(ImageSelectActivity.FLAG_CAMERA, false);//default is true
                intent.putExtra(ImageSelectActivity.FLAG_GALLERY, true);//default is true
                nextActivity(intent, 1213);
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
    public void showNicknameError(String message) {
        InfoDialog infoDialog = new InfoDialog(EditProfileActivity.this);
        String title = getString(R.string.error_text_key);
        infoDialog.setContent(title, message);
        infoDialog.setOnDismissListener(dialogInterface -> mEditProfilePresenter.getProfile(getCountryCode(), LocaleHelper.getLanguage(getContext())));
        infoDialog.show();
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

    @Override
    public void updateQuestions(Double filledPercentDouble) {
        long filledPercent = Math.round(filledPercentDouble);
        String percentageText = filledPercent + "%";
        profileProgress.setProgress((int) filledPercent);
        progressTv.setText(percentageText);
        if (filledPercent == 100) {
            progressTv.setTextColor(ContextCompat.getColor(getContext(), R.color.icon_success_tint_color));
            profileProgress.setProgressDrawable(ContextCompat.getDrawable(getContext(), R.drawable.profile_progress_completed_style));
            profileCompleteProgress.setOnClickListener(null);
            profileCompleteProgressContainer.setBackground(ContextCompat.getDrawable(getContext(), R.drawable.profile_progress_completed_bg));
            profileCompletenessTitle.setTextColor(ContextCompat.getColor(getContext(), R.color.icon_success_tint_color));
            profileCompletenessDescription.setText(getString(R.string.profile_completed_description));
        } else {
            if (isNeedToShowProfileCompletenessDialog) {
                ProfileCompletenessDialog profileCompletenessDialog = new ProfileCompletenessDialog(getContext(), filledPercent);
                profileCompletenessDialog.setDialogClickListener((dialogInterface, which) -> {
                    if (which == ChangeChildCountDialog.CLICK_CLOSE) {
                        dialogInterface.dismiss();
                    } else {
                        dialogInterface.dismiss();
                        if (isNeedToShowNicknameError) {
                            showNicknameError();
                        } else {
                            Bundle bundle = new Bundle();
                            nextActivity(EditProfileActivity.this, ProfileQuestionsActivity.class, bundle);
                        }
                    }

                });
                profileCompletenessDialog.show();
                isNeedToShowProfileCompletenessDialog = false;

            }
            progressTv.setTextColor(ContextCompat.getColor(getContext(), R.color.textPurpleColor));
            profileProgress.setProgressDrawable(ContextCompat.getDrawable(getContext(), R.drawable.profile_progress_style));
            profileCompletenessTitle.setTextColor(ContextCompat.getColor(getContext(), R.color.sort_by_textColor));
            profileCompleteProgressContainer.setBackground(ContextCompat.getDrawable(getContext(), R.drawable.profile_progress_bg));
            profileCompleteProgress.setOnClickListener(view -> {
                Bundle bundle = new Bundle();
                nextActivity(EditProfileActivity.this, ProfileQuestionsActivity.class, bundle);
            });
        }
        if (isNeedToShowNicknameError) {
            profileCompleteProgress.setOnClickListener(view -> {
                scrollContainer.scrollTo(0, 0);
                showNicknameError();
            });
        }
    }

    private void showNicknameError() {
        nickNameErrorIcon.setVisibility(View.VISIBLE);
        edtChangeNickName.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                nickNameErrorIcon.setVisibility(View.GONE);
            }
        });
    }


    @Override
    public void setProfileAnswers(HashMap<String, ProfileQuestionAnswer> profileQuestionsAnswers) {
        ProfileQuestionAnswer settlement = profileQuestionsAnswers.remove("specify_settlement_type");

        for (String key : profileQuestionsAnswers.keySet()) {
            if (profileQuestionsAnswers.get(key).getAnswer() == null) {
                if (key.equals(KEY_CITY_VILLAGE_TYPE) && settlement.getAnswer() != null) {
                    continue;
                }
                isNeedToShowNicknameError = false;
                break;
            }
        }

        ProfileAnswersListAdapter profileAnswersListAdapter = new ProfileAnswersListAdapter(this, profileQuestionsAnswers);

        profileQuestionAnswersRV.setLayoutManager(new LinearLayoutManager(this) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        });
        profileQuestionAnswersRV.setAdapter(profileAnswersListAdapter);

        profileAnswersListAdapter.setClickListener((questionId, answerId, questionType, s) -> {
            if (s.equals(KEY_DO_YOU_HAVE_CHILDREN_TYPE)) {
                mEditProfilePresenter.getQuestionById(getCountryCode(), LocaleHelper.getLanguage(getContext()), questionId, answerId, s);
                return;
            }
            if (isEditAnswerActivityOpening) {
                return;
            }
            isEditAnswerActivityOpening = true;
            Bundle bundle = new Bundle();
            bundle.putLong(Constants.Key.KEY_QUESTION_ID, questionId);
            bundle.putLong(Constants.Key.KEY_ANSWER_ID, answerId);
            bundle.putString(Constants.Key.KEY_QUESTION_TYPE, questionType);
            bundle.putString(Constants.Key.KEY_QUESTION_TITLE, s);
            nextActivity(this, EditAnswerActivity.class, bundle);
        });
    }

    @Override
    public void showSingleQuestion(List<ProfileQuestionsResponse> profileQuestionsResponses, long answerId, String questionTitle) {
        ProfileQuestionsResponse question = profileQuestionsResponses.get(0);
        if (changeChildCountDialog != null) {
            changeChildCountDialog.dismiss();
        }
        changeChildCountDialog = new ChangeChildCountDialog(this, profileQuestionsResponses, answerId, questionTitle);
        changeChildCountDialog.setDialogClickListener((dialogInterface, which) -> {
            if (which == ChangeChildCountDialog.CLICK_CLOSE) {
                changeChildCountDialog.dismiss();
            } else {
                mEditProfilePresenter.editChildCount(getCountryCode(), LocaleHelper.getLanguage(getContext()), question.getId(), question.getType(),
                        question.getOptions().get(which).getId());

            }

        });
        changeChildCountDialog.show();
    }

    @Override
    public void childCountSuccessfullyUpdated() {
        showProgress();
        if (mEditProfilePresenter != null) {
            mEditProfilePresenter.getProfile(getCountryCode(), LocaleHelper.getLanguage(getContext()));
        }

        changeChildCountDialog.dismiss();
    }
}
