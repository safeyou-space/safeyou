package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;

public class PinDeleteDialog extends Dialog {

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.txtTitle1)
    TextView txtTitle1;
    @BindView(R.id.edtDeletePin)
    EditText edtDeletePin;
    @BindView(R.id.containerEditPinInfo)
    ConstraintLayout containerEditPinInfo;
    @BindView(R.id.containerEnterPin)
    ConstraintLayout containerEnterPin;

    private SwitchStateListener mSwitchStateListener;
    private boolean mIsPinDialog;

    private Context mContext;

    public PinDeleteDialog(@NonNull Context context, boolean isPinDialog) {
        super(context);
        this.mContext = context;
        this.mIsPinDialog = isPinDialog;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_delete_pin);
        ButterKnife.bind(this);
        String preferenceRealPin = SafeYouApp.getPreference(mContext)
                .getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
        if (mIsPinDialog) {
            txtTitle1.setText(mContext.getResources().getString(R.string.edit_deactivate_pin_code));
        } else {
            txtTitle1.setText(mContext.getResources().getString(R.string.edit_deactivate_camouflage_icon));
        }

        edtDeletePin.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == 4 && s.toString().equals(preferenceRealPin)) {
//                    SafeYouApp.getPreference(mContext).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
//                    SafeYouApp.getPreference(mContext).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);
//                    SafeYouApp.getPreference(mContext).setValue(Constants.Key.KEY_WITHOUT_PIN, false);
                    mSwitchStateListener.onStateChanged(true);
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
//        mSwitchStateListener.onStateChanged(true);
        cancel();
    }

    @OnClick(R.id.btnContinue)
    void onClickContinue() {
        if (!mIsPinDialog) {
            mSwitchStateListener.onStateChanged(true);
            dismiss();
            return;
        }
        containerEditPinInfo.setVisibility(View.GONE);
        containerEnterPin.setVisibility(View.VISIBLE);
    }

    public void setSwitchStateListener(SwitchStateListener mSwitchStateListener) {
        this.mSwitchStateListener = mSwitchStateListener;
    }

    public interface SwitchStateListener {
        void onStateChanged(boolean canceled);
    }
}
