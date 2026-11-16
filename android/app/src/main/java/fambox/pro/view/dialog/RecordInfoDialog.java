package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;

public class RecordInfoDialog extends Dialog {

    public static final int DIALOG_TYPE_SENT = 0;
    public static final int DIALOG_TYPE_SMS_SEND = 2;
    public static final int DIALOG_TYPE_HELP_INFO = 3;

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.txtSubTitle)
    TextView txtSubTitle;
    @BindView(R.id.txtHelpInfoDescription)
    TextView txtHelpInfoDescription;
    @BindView(R.id.txtPeopleList)
    TextView txtPeopleList;
    @BindView(R.id.name)
    TextView name;
    @BindView(R.id.time)
    TextView time;
    @BindView(R.id.date)
    TextView date;
    @BindView(R.id.startData)
    TextView startData;
    @BindView(R.id.endData)
    TextView endData;
    @BindView(R.id.startTime)
    TextView startTime;
    @BindView(R.id.endTime)
    TextView endTime;
    @BindView(R.id.containerRecordSent)
    ConstraintLayout containerRecordSent;
    @BindView(R.id.containerAlertMessage)
    ConstraintLayout containerAlertMessage;
    @BindView(R.id.iconSuccess)
    ImageView iconSuccess;

    private final int mDialogType;
    private String mDialogTitle;
    private String mName;
    private String mTime;
    private String mDate;
    private String mStartData;
    private String mEndData;
    private String mStartTime;
    private String mEndTime;
    private String mSubTitle;
    private String mHelpInfoDescription;
    private String mPeopleList;

    public RecordInfoDialog(@NonNull Context context, int dialogType) {
        super(context);
        this.mDialogType = dialogType;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_record_info);
        ButterKnife.bind(this);
        switch (mDialogType) {
            case 0:
                containerRecordSent.setVisibility(View.VISIBLE);
                containerAlertMessage.setVisibility(View.GONE);
                txtTitle.setText(mDialogTitle);
                name.setText(mName);
                time.setText(mTime);
                date.setText(mDate);
                break;
            case 1:
                containerRecordSent.setVisibility(View.GONE);
                containerAlertMessage.setVisibility(View.VISIBLE);
                txtTitle.setText(mDialogTitle);
                startData.setText(mStartData);
                endData.setText(mEndData);
                startTime.setText(mStartTime);
                endTime.setText(mEndTime);
                break;
            case 2:
                containerRecordSent.setVisibility(View.GONE);
                containerAlertMessage.setVisibility(View.GONE);
                txtTitle.setText(mDialogTitle);
                break;
            case 3:
                containerRecordSent.setVisibility(View.GONE);
                containerAlertMessage.setVisibility(View.GONE);
                iconSuccess.setVisibility(View.GONE);
                txtSubTitle.setText(mSubTitle);
                txtHelpInfoDescription.setText(mHelpInfoDescription);
                txtTitle.setText(mDialogTitle);
                txtPeopleList.setText(mPeopleList);
                break;
        }
    }

    @Override
    public void show() {
        try {
            super.show();
            setCancelable(false);
        } catch (Exception ignore) {
        }
    }

    @OnClick(R.id.cancelIcon)
    void dismissDialog() {
        cancel();
    }

    public void setDialogTitle(String mDialogTitle) {
        this.mDialogTitle = mDialogTitle;
    }

    public void setSentActionMessages(String dialogTitle, String name, String time, String date) {
        this.mDialogTitle = dialogTitle;
        this.mName = name;
        this.mTime = time;
        this.mDate = date;
    }

    private void setAlertActionMessages(String dialogTitle, String startData,
                                        String endData, String startTime,
                                        String endTime) {
        this.mDialogTitle = dialogTitle;
        this.mStartData = startData;
        this.mEndData = endData;
        this.mStartTime = startTime;
        this.mEndTime = endTime;
    }

    public void setHelpInfoText(String subTitle, String mHelpInfoDescription, String peopleList) {
        this.mSubTitle = subTitle;
        this.mHelpInfoDescription = mHelpInfoDescription;
        this.mPeopleList = peopleList;
    }
}
