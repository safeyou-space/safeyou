package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.skydoves.powerspinner.IconSpinnerAdapter;
import com.skydoves.powerspinner.IconSpinnerItem;
import com.skydoves.powerspinner.OnSpinnerItemSelectedListener;
import com.skydoves.powerspinner.PowerSpinnerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.ReportPresenter;
import fambox.pro.utils.Utils;

public class ReportActivity extends BaseActivity implements ReportContract.View {

    private ReportPresenter mReportPresenter;

    @BindView(R.id.reportableUserImage)
    CircleImageView reportableUserImage;
    @BindView(R.id.reportableUserName)
    TextView reportableUserName;
    @BindView(R.id.reportableUserProfession)
    TextView reportableUserProfession;
    @BindView(R.id.reportableDate)
    TextView reportableDate;
    @BindView(R.id.reportableForumContent)
    TextView reportableForumContent;
    @BindView(R.id.categorySpinner)
    PowerSpinnerView categorySpinner;
    @BindView(R.id.editTextReport)
    EditText editTextReport;
    @BindView(R.id.btnReport)
    Button btnReport;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        ButterKnife.bind(this);
        mReportPresenter = new ReportPresenter();
        mReportPresenter.attachView(this);
        mReportPresenter.initBundle(getIntent().getExtras());
        mReportPresenter.viewIsReady();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_report;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mReportPresenter != null) {
            mReportPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mReportPresenter != null) {
            mReportPresenter.destroy();
        }
    }

    @Override
    public void configSpinnerView(List<IconSpinnerItem> iconSpinnerItems) {
        IconSpinnerAdapter iconSpinnerAdapter = new IconSpinnerAdapter(categorySpinner);
        categorySpinner.setSpinnerAdapter(iconSpinnerAdapter);
        categorySpinner.setItems(iconSpinnerItems);
        categorySpinner.setLifecycleOwner(this);
        categorySpinner.setOnSpinnerItemSelectedListener(
                (OnSpinnerItemSelectedListener<IconSpinnerItem>) (i, iconSpinnerItem, i1, t1) ->
                        mReportPresenter.selectCategory(t1.getText().toString()));
    }

    @Override
    public void configViews(String imagePath,
                            String reportableUserName, String reportableUserProfession,
                            String reportableComment, String reportableDate) {
        this.reportableUserName.setText(reportableUserName);
        this.reportableUserProfession.setText(reportableUserProfession);
        this.reportableForumContent.setText(reportableComment);
        this.reportableDate.setText(reportableDate);
        Glide.with(this).load(imagePath).into(reportableUserImage);
    }

    @Override
    public void finishActivity() {
        finish();
    }

    @OnClick(R.id.actionBarBack)
    void btnBackClicked() {
        onBackPressed();
    }

    @OnClick(R.id.btnReport)
    void btnReportClicked() {
        mReportPresenter.inputText(Utils.getEditableToString(editTextReport.getText()));
        mReportPresenter.postReport();
    }

    @OnClick(R.id.btnCancel)
    void btnCancelClicked() {
        onBackPressed();
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
}