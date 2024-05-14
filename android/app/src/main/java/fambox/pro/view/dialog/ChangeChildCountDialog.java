package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.widget.NumberPicker;
import android.widget.TextView;

import androidx.annotation.NonNull;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;

public class ChangeChildCountDialog extends Dialog {

    public static final int CLICK_CLOSE = -1;
    private final List<ProfileQuestionsResponse> profileQuestionsResponses;
    private final long answerId;
    private final String questionTitle;

    private OnClickListener mDialogClickListener;
    private int selectedPosition;
    private List<ProfileQuestionOption> profileQuestionOption;

    @BindView(R.id.txtTitle)
    TextView txtTitle;
    @BindView(R.id.numberPicker)
    NumberPicker numberPicker;
    public ChangeChildCountDialog(@NonNull Context context, List<ProfileQuestionsResponse> profileQuestionsResponses, long answerId, String questionTitle) {
        super(context);
        this.profileQuestionsResponses = profileQuestionsResponses;
        this.answerId = answerId;
        this.questionTitle = questionTitle;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_change_child_count);
        ButterKnife.bind(this);
        txtTitle.setText(questionTitle);
        profileQuestionOption = profileQuestionsResponses.get(0).getOptions();
        String[] options = new String[profileQuestionOption.size()];
        for (int i = 0; i < profileQuestionOption.size(); i++) {
            if (answerId == profileQuestionOption.get(i).getId()) {
                selectedPosition = i;
            }
            options[i] = profileQuestionOption.get(i).getName();
        }
        numberPicker.setDisplayedValues(options);
        numberPicker.setMinValue(0);
        numberPicker.setWrapSelectorWheel(false);
        numberPicker.setMaxValue(options.length - 1);
        numberPicker.setValue(selectedPosition);
        numberPicker.setOnValueChangedListener((numberPicker, oldValue, newValue) -> selectedPosition = newValue);
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
            mDialogClickListener.onClick(this, selectedPosition);
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
