package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.presenter.BecomeConsultantPresenter;
import fambox.pro.utils.SnackBar;

import static fambox.pro.Constants.Key.KEY_IS_CONSULTANT_CONDITION;
import static fambox.pro.Constants.Key.KEY_IS_TERM;

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

//        ActivityBecomeConsultantBinding activityBecomeConsultantBinding
//                = ActivityBecomeConsultantBinding.inflate(getLayoutInflater());
//       View view = activityBecomeConsultantBinding.getRoot();
//       setContentView(view);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            if (data != null) {
                mCategoryId = data.getIntExtra("consultant_id", BecomeConsultantPresenter.CATEGORY_NOT_SELECTED);
                mNewProfessionName = data.getStringExtra("new_category_name");
                Log.i("tagikkkkk", "onActivityResult: " + mNewProfessionName);
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
        bundle.putBoolean(KEY_IS_TERM, false);
        bundle.putBoolean(KEY_IS_CONSULTANT_CONDITION, true);
        nextActivity(this, TermsAndConditionsActivity.class, bundle);
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