package fambox.pro.view.adapter.holder;

import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.textfield.TextInputEditText;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class ProfileAnswersListHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.edtAnswer)
    TextInputEditText edtAnswer;

    @BindView(R.id.answerTitle)
    AppCompatTextView answerTitle;

    @BindView(R.id.btnAnswerDetails)
    AppCompatImageView btnAnswerDetails;

    public ProfileAnswersListHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public AppCompatTextView getAnswerTitle() {
        return answerTitle;
    }

    public TextInputEditText getEdtAnswer() {
        return edtAnswer;
    }

    public AppCompatImageView getBtnAnswerDetails() {
        return btnAnswerDetails;
    }
}
