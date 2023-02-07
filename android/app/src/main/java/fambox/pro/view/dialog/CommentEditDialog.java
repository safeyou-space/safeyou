package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;

import androidx.annotation.NonNull;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;

public class CommentEditDialog extends Dialog {
    public static final int REPLY = 0;
    public static final int COPY = 1;
    private DialogInterface.OnClickListener onClickListener;

    public CommentEditDialog(@NonNull Context context) {
        super(context);
    }

    public void setOnClickListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_edit_comment);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.txtReply)
    void onClickReply() {
        if (onClickListener != null) {
            onClickListener.onClick(this, REPLY);
        }
    }

    @OnClick(R.id.txtCopy)
    void onClickCopy() {
        if (onClickListener != null) {
            onClickListener.onClick(this, COPY);
        }
    }
}
