package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;

import androidx.annotation.NonNull;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;

public class ProfileCompletenessDialog extends Dialog {

    public static final int CLICK_CLOSE = -1;
    private final long filledPercent;

    private OnClickListener mDialogClickListener;

    public ProfileCompletenessDialog(@NonNull Context context, long filledPercent) {
        super(context);
        this.filledPercent = filledPercent;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_profile_completeness);
        ButterKnife.bind(this);
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
            mDialogClickListener.onClick(this, 0);
        }
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, CLICK_CLOSE);
        }
    }

    public void setDialogClickListener(OnClickListener dialogClickListener) {
        this.mDialogClickListener = dialogClickListener;
    }
}
