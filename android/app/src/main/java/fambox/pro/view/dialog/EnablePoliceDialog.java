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
import fambox.pro.utils.Utils;

public class EnablePoliceDialog extends Dialog {
    public static final int ENABLE = 1;
    public static final int DISABLE = 0;
    private final String title;
    private final String description;

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.txtSubTitle)
    TextView txtSubTitle;

    private OnClickListener mDialogClickListener;

    public EnablePoliceDialog(@NonNull Context context, String title, String description) {
        super(context);
        this.title = title;
        this.description = description;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_enable_police);
        ButterKnife.bind(this);
        txtTitle.setText(Utils.convertStringToHtml(title));
        txtSubTitle.setText(Utils.convertStringToHtml(description));
    }

    @Override
    public void show() {
        super.show();
        setCancelable(false);
        getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
    }

    @OnClick(R.id.cancelIcon)
    void onClickDismissDialog() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, DISABLE);
        }
    }

    @OnClick(R.id.btnContinue)
    void onClickContinue() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, ENABLE);
        }
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        if (mDialogClickListener != null) {
            mDialogClickListener.onClick(this, DISABLE);
        }
    }

    public void setDialogClickListener(OnClickListener dialogClickListener) {
        this.mDialogClickListener = dialogClickListener;
    }
}
