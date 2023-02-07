package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;

public class ConfirmPinEditDialog extends Dialog {

    private final Context mContext;
    private final ConfirmEditListener mConfirmEditListener;

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.edtDeletePin)
    EditText edtDeletePin;


    public ConfirmPinEditDialog(@NonNull Context context, ConfirmEditListener confirmEditListener) {
        super(context);
        this.mContext = context;
        this.mConfirmEditListener = confirmEditListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_confirm_edit_pin);
        ButterKnife.bind(this);
        String preferenceRealPin = SafeYouApp.getPreference(mContext)
                .getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
        edtDeletePin.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == 4 && s.toString().equals(preferenceRealPin)) {
                    mConfirmEditListener.onConfirmEditListener();
                    dismiss();
                } else if (s.length() == 4 && !s.equals(preferenceRealPin)) {
                    edtDeletePin.setText("");
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
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

    public interface ConfirmEditListener {
        void onConfirmEditListener();
    }
}
