package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RadioButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class SurveyMultipleChoiceListHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.btnQuestionOption)
    Button btnQuestionOption;
    @BindView(R.id.radioButton)
    @Nullable
    RadioButton radioButton;

    @BindView(R.id.survey_check_box)
    @Nullable
    CheckBox checkBox;

    public SurveyMultipleChoiceListHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public Button getBtnQuestionOption() {
        return btnQuestionOption;
    }

    public void setChecked(boolean isChecked, boolean isCheckbox) {
        if (isCheckbox) {
            checkBox.setChecked(isChecked);
        } else {
            radioButton.setChecked(isChecked);
        }
    }

    public RadioButton getRadioButton() {
        return radioButton;
    }

}
