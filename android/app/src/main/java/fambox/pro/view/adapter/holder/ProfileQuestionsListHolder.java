package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class ProfileQuestionsListHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.btnQuestionOption)
    Button btnQuestionOption;
    @BindView(R.id.radioButton)
    @Nullable
    RadioButton radioButton;

    public ProfileQuestionsListHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public Button getBtnQuestionOption() {
        return btnQuestionOption;
    }

    @Nullable
    public RadioButton getRadioButton() {
        return radioButton;
    }

}
