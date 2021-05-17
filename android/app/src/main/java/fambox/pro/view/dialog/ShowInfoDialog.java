package fambox.pro.view.dialog;


import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.NonNull;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;
import fambox.pro.enums.Types;

public class ShowInfoDialog extends Dialog {

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.txtDescription)
    TextView txtDescription;

    public ShowInfoDialog(@NonNull Context context) {
        super(context);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_show_info);
        ButterKnife.bind(this);
    }

    public void setTxtDescription(Types.InfoDialogText infoDialogText) {
        txtTitle.setText(infoDialogText.getTitle());
        txtDescription.setText(infoDialogText.getText());
    }

    @OnClick(R.id.cancelIcon)
    void clickCloseDialog(){
        cancel();
    }
}
