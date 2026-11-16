package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.Surveys;
import fambox.pro.view.adapter.holder.SurveyListHolder;

public class SurveyListAdapter extends RecyclerView.Adapter<SurveyListHolder> {

    private final Context context;
    private final List<Surveys> surveys;
    private ClickListener clickListener;

    public SurveyListAdapter(Context applicationContext, List<Surveys> surveys) {
        this.context = applicationContext;
        this.surveys = surveys;
    }

    @NonNull
    @Override
    public SurveyListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new SurveyListHolder(LayoutInflater.from(parent.getContext()).inflate(
                R.layout.survey_list_adapter, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull SurveyListHolder holder, int position) {
        if ((position + 4) % 4 == 0) {
            holder.getItemContainer().setBackground(ContextCompat.getDrawable(context, R.drawable.survey_item_bg_1));
        } else if ((position + 4) % 4 == 1) {
            holder.getItemContainer().setBackground(ContextCompat.getDrawable(context, R.drawable.survey_item_bg_2));
        } else if ((position + 4) % 4 == 2) {
            holder.getItemContainer().setBackground(ContextCompat.getDrawable(context, R.drawable.survey_item_bg_3));
        } else {
            holder.getItemContainer().setBackground(ContextCompat.getDrawable(context, R.drawable.survey_item_bg_4));
        }
        holder.getSurveyTitle().setText(surveys.get(position).getTranslation().getTitle());
        if (surveys.get(position).isAnswered()) {
            if (surveys.get(position).isQuiz()) {
                holder.getTakeSurvey().setVisibility(View.VISIBLE);
                holder.getSurveyCompleted().setVisibility(View.INVISIBLE);
                holder.getTakeSurvey().setText(R.string.see_result_key);
                holder.itemView.setOnClickListener(view -> clickListener.clickListener(surveys.get(position).getId()));
                return;
            }
            holder.getTakeSurvey().setVisibility(View.INVISIBLE);
            holder.getSurveyCompleted().setVisibility(View.VISIBLE);
            holder.itemView.setOnClickListener(null);
        } else {
            holder.getTakeSurvey().setVisibility(View.VISIBLE);
            holder.getSurveyCompleted().setVisibility(View.INVISIBLE);
            if (surveys.get(position).isQuiz()) {
                holder.getTakeSurvey().setText(R.string.take_quiz_key);
            } else {
                holder.getTakeSurvey().setText(R.string.take_survey_key);
            }
            holder.itemView.setOnClickListener(view -> clickListener.clickListener(surveys.get(position).getId()));
        }
    }

    public void setClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public void addSurveys(List<Surveys> surveys) {
        this.surveys.addAll(surveys);
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return surveys == null ? 0 : surveys.size();
    }

    public interface ClickListener {
        void clickListener(long surveyId);
    }
}
