package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;
import fambox.pro.utils.Utils;

public class InfoDialog extends Dialog {

    @BindView(R.id.txtSubTitle)
    TextView txtSubTitle;
    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.cancelIcon)
    ImageView cancelIcon;
    private String errors;
    private String title;


    public InfoDialog(@NonNull Context context) {
        super(context);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_info);
        ButterKnife.bind(this);
        if (getWindow() != null) {
            getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }
        txtTitle.setText(Utils.convertStringToHtml(title));
        txtSubTitle.setText(errors);
    }

    @OnClick(R.id.cancelIcon)
    void dismissDialog() {
        cancel();
    }

    @OnClick(R.id.btnContinue)
    void onClickContinue() {
        cancel();
    }

    public void setContent(String title, String errors) {
        this.title = title;
        this.errors = errors;
    }

    public void goneCloseIcon() {
        cancelIcon.setVisibility(View.GONE);
    }
}
