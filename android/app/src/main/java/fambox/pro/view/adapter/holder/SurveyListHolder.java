package fambox.pro.view.adapter.holder;

import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class SurveyListHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.itemContainer)
    ConstraintLayout itemContainer;
    @BindView(R.id.surveyTitle)
    AppCompatTextView surveyTitle;
    @BindView(R.id.takeSurvey)
    AppCompatTextView takeSurvey;
    @BindView(R.id.surveyCompleted)
    AppCompatTextView surveyCompleted;

    public SurveyListHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public AppCompatTextView getSurveyTitle() {
        return surveyTitle;
    }

    public AppCompatTextView getTakeSurvey() {
        return takeSurvey;
    }

    public ConstraintLayout getItemContainer() {
        return itemContainer;
    }

    public AppCompatTextView getSurveyCompleted() {
        return surveyCompleted;
    }
}
