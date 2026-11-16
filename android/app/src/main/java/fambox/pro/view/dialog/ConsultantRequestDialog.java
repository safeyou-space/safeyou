package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.NonNull;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;

public class ConsultantRequestDialog extends Dialog {

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.txtSubTitle)
    TextView txtSubTitle;

    private final Context mContext;
    private final boolean mIsCancel;
    private OnClickListener mDialogClickListener;

    public ConsultantRequestDialog(@NonNull Context context, boolean isCancel) {
        super(context);
        this.mContext = context;
        this.mIsCancel = isCancel;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_consultant_request);
        ButterKnife.bind(this);
        if (mIsCancel) {
            txtTitle.setText(mContext.getResources().getString(R.string.cancel_request));
            txtSubTitle.setText(mContext.getResources().getString(R.string.cancel_request_message));
        } else {
            txtTitle.setText(mContext.getResources().getString(R.string.deactivate_become_consultant));
            txtSubTitle.setText(mContext.getResources().getString(R.string.deactivate_confirm_message));
        }
    }

    @Override
    public void show() {
        super.show();
        setCancelable(false);
        getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
    }

    @OnClick(R.id.cancelIcon)
    void onClickDismissDialog() {
        dismiss();
    }

    @OnClick(R.id.btnContinue)
    void onClickContinue() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, 0);
        }
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        dismiss();
    }

    public void setDialogClickListener(OnClickListener dialogClickListener) {
        this.mDialogClickListener = dialogClickListener;
    }
}
