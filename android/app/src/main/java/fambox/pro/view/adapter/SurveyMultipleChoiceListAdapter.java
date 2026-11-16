package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.SurveyOptions;
import fambox.pro.network.model.SurveyUserAnswerDetails;
import fambox.pro.view.adapter.holder.SurveyMultipleChoiceListHolder;

public class SurveyMultipleChoiceListAdapter extends RecyclerView.Adapter<SurveyMultipleChoiceListHolder> {

    private final List<SurveyOptions> options;
    private final boolean isCheckbox;
    private final boolean isAnswered;
    private final List<SurveyUserAnswerDetails> userAnswerDetailsList;

    private List<Long> selectedOptionIds = new ArrayList<>();
    private final Context context;

    public SurveyMultipleChoiceListAdapter(Context applicationContext, List<SurveyOptions> options, String currentType, boolean answered,
                                           List<SurveyUserAnswerDetails> userAnswerDetailsList) {
        this.options = options;
        this.context = applicationContext;
        this.isCheckbox = currentType.equals("checkbox");
        this.isAnswered = answered;
        this.userAnswerDetailsList = userAnswerDetailsList;
    }

    @NonNull
    @Override
    public SurveyMultipleChoiceListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(isCheckbox ? R.layout.survey_checkbox_adapter : R.layout.survey_multiple_choice_adapter, parent, false);
        return new SurveyMultipleChoiceListHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull SurveyMultipleChoiceListHolder holder, int position) {
        SurveyOptions currentOption = options.get(position);
        holder.getBtnQuestionOption().setText(currentOption.getTranslation().getTitle());
        if (selectedOptionIds.contains(currentOption.getId())) {
            holder.setChecked(true, isCheckbox);
            holder.itemView.setBackground(ContextCompat.getDrawable(context, R.drawable.survey_multiple_choice_selected_bg));
        } else {
            holder.setChecked(false, isCheckbox);
            holder.itemView.setBackground(ContextCompat.getDrawable(context, R.drawable.survey_multiple_choice_bg));
        }
        if (isAnswered) {
            for (SurveyUserAnswerDetails userAnswerDetails : userAnswerDetailsList) {
                if (currentOption.getId() == userAnswerDetails.getOptionId()) {
                    holder.setChecked(true, isCheckbox);
                    holder.itemView.setBackground(ContextCompat.getDrawable(context, R.drawable.survey_multiple_choice_wrong_bg));
                }
            }
            if (currentOption.isCorrectAnswer()) {
                holder.itemView.setBackground(ContextCompat.getDrawable(context, R.drawable.survey_multiple_choice_correct_bg));

            }

        } else {
            holder.itemView.setOnClickListener(v -> {
                if (selectedOptionIds.contains(currentOption.getId())) {
                    selectedOptionIds.remove(currentOption.getId());
                } else {
                    if (!isCheckbox) {
                        selectedOptionIds.clear();
                    }
                    selectedOptionIds.add(currentOption.getId());
                }
                notifyDataSetChanged();
            });
        }

    }

    @Override
    public int getItemCount() {
        return options == null ? 0 : options.size();
    }

    public List<Long> getSelectedOptionIds() {
        return selectedOptionIds;
    }

    public void setSelectedOptionIds(Object optionIds) {
        this.selectedOptionIds = (List<Long>) optionIds;
        notifyDataSetChanged();
    }
}
