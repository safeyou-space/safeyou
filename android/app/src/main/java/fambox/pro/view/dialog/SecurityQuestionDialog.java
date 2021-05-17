package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.NonNull;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;

public class SecurityQuestionDialog extends Dialog {

    public static final int CLICK_CLOSE = 0;
    public static final int CLICK_CANCEL = 1;
    public static final int CLICK_CONTINUE = 2;

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.txtSubTitle)
    TextView txtSubTitle;

    private final Context mContext;
    private final boolean mOpenFromPinActivity;
    private DialogInterface.OnClickListener mDialogClickListener;

    public SecurityQuestionDialog(@NonNull Context context, boolean openFromPinActivity) {
        super(context);
        this.mContext = context;
        this.mOpenFromPinActivity = openFromPinActivity;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_security_question);
        ButterKnife.bind(this);
        if (mOpenFromPinActivity) {
            txtTitle.setText(mContext.getResources().getString(R.string.activate_camouflage_icon));
            txtSubTitle.setText(mContext.getResources().getString(R.string.activate_camouflage_icon_body));
        } else {
            txtTitle.setText(mContext.getResources().getString(R.string.activate_dual_pin));
            txtSubTitle.setText(mContext.getResources().getString(R.string.activate_dual_pin_body));
        }
    }

    @Override
    public void show() {
        super.show();
        setCancelable(false);
        getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
    }

    @OnClick(R.id.cancelIcon)
    void dismissDialog() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, CLICK_CLOSE);
        }
    }

    @OnClick(R.id.btnContinue)
    void onClickContinue() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, CLICK_CONTINUE);
        }
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, CLICK_CANCEL);
        }
    }

    public void setDialogClickListener(DialogInterface.OnClickListener dialogClickListener) {
        this.mDialogClickListener = dialogClickListener;
    }
}
