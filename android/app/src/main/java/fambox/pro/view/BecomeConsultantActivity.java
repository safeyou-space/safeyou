package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_IS_CONSULTANT_CONDITION;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.DrawableRes;
import androidx.annotation.Nullable;
import androidx.annotation.StringRes;
import androidx.constraintlayout.widget.ConstraintLayout;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.presenter.BecomeConsultantPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.dialog.ConsultantRequestDialog;
import fambox.pro.view.dialog.InfoDialog;

public class BecomeConsultantActivity extends BaseActivity implements BecomeConsultantContract.View {

    private static final int REQUEST_CODE = 1010;
    private BecomeConsultantPresenter mBecomeConsultantPresenter;
    private int mCategoryId = BecomeConsultantPresenter.CATEGORY_NOT_SELECTED;
    private String mNewProfessionName;

    @BindView(R.id.consultantDescription)
    TextView consultantDescription;
    @BindView(R.id.professionTxt)
    TextView professionTxt;
    @BindView(R.id.sendRequestBtnCover)
    View sendRequestBtnCover;
    @BindView(R.id.btnSubmit)
    Button btnSubmit;
    @BindView(R.id.inputProfessionDescription)
    EditText inputProfessionDescription;
    @BindView(R.id.inputEmail)
    EditText inputEmail;
    @BindView(R.id.progress)
    LinearLayout progress;
    @BindView(R.id.containerSubmissionDate)
    LinearLayout containerSubmissionDate;
    @BindView(R.id.submissionDate)
    TextView submissionDate;
    @BindView(R.id.containerTermsAndCondition)
    ConstraintLayout containerTermsAndCondition;
    @BindView(R.id.requestStatusContainer)
    ConstraintLayout requestStatusContainer;
    @BindView(R.id.requestStatusRequest)
    TextView requestStatusRequest;
    @BindView(R.id.arrowIcon)
    ImageView arrowIcon;
    @BindView(R.id.containerSelectProfession)
    ConstraintLayout containerSelectProfession;
    @BindView(R.id.btnCancel)
    TextView btnCancel;
    @BindView(R.id.checkTermsAndCondition)
    CheckBox checkTermsAndCondition;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false,
                true, false,
                getResources().getString(R.string.consultant_request), true);
        mBecomeConsultantPresenter = new BecomeConsultantPresenter();
        mBecomeConsultantPresenter.attachView(this);
        mBecomeConsultantPresenter.viewIsReady();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            if (data != null) {
                mCategoryId = data.getIntExtra("consultant_id", BecomeConsultantPresenter.CATEGORY_NOT_SELECTED);
                mNewProfessionName = data.getStringExtra("new_category_name");
                professionTxt.setText(mNewProfessionName);
            }
        }
    }

    @OnClick(R.id.btnSubmit)
    void onClickSubmit() {
        String email = inputEmail.getText() != null ? inputEmail.getText().toString() : "";
        String message = inputProfessionDescription.getText() != null
                ? inputProfessionDescription.getText().toString() : "";
        mBecomeConsultantPresenter.sendRequest(email, message, mNewProfessionName, mCategoryId);
    }

    @OnClick(R.id.containerSelectProfession)
    void onClickContainerSelectProfession() {
        startActivityForResult(new Intent(
                this, ChooseProfessionActivity.class), REQUEST_CODE);
    }

    @OnClick(R.id.termsAndCondition)
    void onClickTermsAndCondition() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_CONSULTANT_CONDITION, true);
        nextActivity(this, WebViewActivity.class, bundle);
    }

    @OnCheckedChanged(R.id.checkTermsAndCondition)
    void checkPolice(CompoundButton button, boolean checked) {
        sendRequestBtnCover.setVisibility(checked ? View.GONE : View.VISIBLE);
        btnSubmit.setEnabled(checked);
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        onBackPressed();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_become_consultant;
    }

    @Override
    public void configRequestPending(boolean isPending) {
        InputMethodManager imm = (InputMethodManager) getSystemService(
                Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(inputEmail.getWindowToken(), 0);
        arrowIcon.setVisibility(isPending ? View.GONE : View.VISIBLE);
        containerTermsAndCondition.setVisibility(isPending ? View.GONE : View.VISIBLE);
        containerSubmissionDate.setVisibility(isPending ? View.VISIBLE : View.GONE);
        requestStatusContainer.setVisibility(isPending ? View.VISIBLE : View.GONE);
        inputProfessionDescription.setEnabled(!isPending);
        inputEmail.setEnabled(!isPending);
        containerSelectProfession.setClickable(!isPending);
        sendRequestBtnCover.setVisibility(isPending ? View.GONE : View.VISIBLE);
    }

    @Override
    public void configRequestStatus(@StringRes int textResourceId,
                                    @StringRes int submitResourceId,
                                    @DrawableRes int iconResourceId,
                                    String date,
                                    String submissionDate) {
        requestStatusRequest.setText(getString(textResourceId, date));
        if (iconResourceId == R.drawable.iocn_approved) {
            requestStatusRequest.setTextColor(getResources().getColor(R.color.colorAccent));
        } else if (iconResourceId == R.drawable.icon_declined) {
            requestStatusRequest.setTextColor(getResources().getColor(R.color.red));
        }
        requestStatusRequest.setCompoundDrawablesWithIntrinsicBounds
                (iconResourceId, 0, 0, 0);
        btnSubmit.setText(getResources().getString(submitResourceId));
        this.submissionDate.setText(submissionDate);
    }

    @Override
    public void configRequestMessages(String email, String message, String submissionDate, String profession) {
        this.professionTxt.setText(profession);
        this.professionTxt.setTextColor(getResources().getColor(R.color.black));
        this.inputEmail.setText(email);
        this.inputEmail.setTextColor(getResources().getColor(R.color.black));
        this.inputProfessionDescription.setText(message);
        this.inputProfessionDescription.setTextColor(getResources().getColor(R.color.black));
        this.submissionDate.setText(submissionDate);
        this.submissionDate.setTextColor(getResources().getColor(R.color.black));
        this.btnCancel.setText(getResources().getString(R.string.back));
        this.btnSubmit.setEnabled(true);
    }

    @Override
    public void newRequest() {
        InputMethodManager imm = (InputMethodManager) getSystemService(
                Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(inputEmail.getWindowToken(), 0);
        btnSubmit.setText(getResources().getString(R.string.continue_txt));
        btnSubmit.setEnabled(false);
        btnCancel.setText(getResources().getString(R.string.cancel));
        professionTxt.setText("");
        professionTxt.setTextColor(getResources().getColor(R.color.gray));
        inputEmail.setText(null);
        inputEmail.setTextColor(getResources().getColor(R.color.gray));
        inputProfessionDescription.setText(null);
        inputProfessionDescription.setTextColor(getResources().getColor(R.color.gray));
        arrowIcon.setVisibility(View.VISIBLE);
        containerTermsAndCondition.setVisibility(View.VISIBLE);
        containerSubmissionDate.setVisibility(View.GONE);
        requestStatusContainer.setVisibility(View.GONE);
        inputProfessionDescription.setEnabled(true);
        inputEmail.setEnabled(true);
        containerSelectProfession.setClickable(true);
        sendRequestBtnCover.setVisibility(View.VISIBLE);
        checkTermsAndCondition.setChecked(false);
        requestStatusRequest.setTextColor(getResources().getColor(R.color.gray));
    }

    @Override
    public void openDialogCancelRequest() {
        ConsultantRequestDialog consultantRequestDialog =
                new ConsultantRequestDialog(this, true);
        consultantRequestDialog.setDialogClickListener((dialog, which) -> {
            mBecomeConsultantPresenter.cancelRequest();
            dialog.cancel();
        });
        consultantRequestDialog.show();
    }

    @Override
    public void openDialogDeactivateRequest() {
        ConsultantRequestDialog consultantRequestDialog =
                new ConsultantRequestDialog(this, false);
        consultantRequestDialog.setDialogClickListener((dialog, which) -> {
            mBecomeConsultantPresenter.deactivateRequest();
            dialog.cancel();
        });
        consultantRequestDialog.show();
    }

    @Override
    public void openSuccessRequestDialog() {
        InfoDialog showInfoDialog = new InfoDialog(this);
        showInfoDialog.setContent("", getResources().getString(R.string.consultant_request_success_message));
        showInfoDialog.show();
        showInfoDialog.goneCloseIcon();

        CountDownTimer countDownTimer = new CountDownTimer(3000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {

            }

            @Override
            public void onFinish() {
                if (showInfoDialog.isShowing()) {
                    showInfoDialog.dismiss();
                }
            }
        };
        countDownTimer.start();
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void showProgress() {
        runOnUiThread(() -> progress.setVisibility(View.VISIBLE));
    }

    @Override
    public void dismissProgress() {
        runOnUiThread(() -> progress.setVisibility(View.GONE));
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