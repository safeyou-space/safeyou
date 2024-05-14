package fambox.pro.view.adapter;

import static fambox.pro.Constants.Key.KEY_BASIC_TYPE;
import static fambox.pro.Constants.Key.KEY_SETTLEMENT_TYPE;

import android.annotation.SuppressLint;
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
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.view.adapter.holder.ProfileQuestionsListHolder;

public class ProfileQuestionListAdapter extends RecyclerView.Adapter<ProfileQuestionsListHolder> {

    private final ProfileQuestionsResponse profileQuestionsResponse;

    private List<ProfileQuestionOption> options;

    private List<ProfileQuestionOption> currentOptions;

    private final Context context;
    private ClickListener clickListener;

    private int selectedPosition = -1;
    private long selectedAnswerId = -1;

    public ProfileQuestionListAdapter(Context applicationContext, ProfileQuestionsResponse profileQuestionsResponse, Object selectedPosition) {
        this.profileQuestionsResponse = profileQuestionsResponse;
        this.options = profileQuestionsResponse.getOptions();
        this.currentOptions = new ArrayList<>(options);
        this.context = applicationContext;
        this.selectedAnswerId = selectedPosition != null ? (long) selectedPosition : -1;
    }

    @NonNull
    @Override
    public ProfileQuestionsListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView;
        if (profileQuestionsResponse.getType().equals(KEY_BASIC_TYPE) || profileQuestionsResponse.getType().equals(KEY_SETTLEMENT_TYPE)) {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.profile_questions_basic_adapter, parent, false);
        } else {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.profile_questions_adapter, parent, false);

        }

        return new ProfileQuestionsListHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ProfileQuestionsListHolder holder, int position) {
        String label = currentOptions.get(position).getName();
        holder.getBtnQuestionOption().setText(label);
        if (currentOptions.get(position).getId() == selectedAnswerId) {
            selectedAnswerId = -1;
            selectedPosition = position;
        }
        if (position == selectedPosition) {
            if (profileQuestionsResponse.getType().equals(KEY_BASIC_TYPE) || profileQuestionsResponse.getType().equals(KEY_SETTLEMENT_TYPE)) {
                holder.getBtnQuestionOption().setBackground(ContextCompat.getDrawable(context, R.drawable.question_item_selected_bg));
                holder.getBtnQuestionOption().setTextColor(ContextCompat.getColor(context, R.color.sort_by_textColor));
            } else {
                holder.getRadioButton().setChecked(true);
            }
        } else {
            if (profileQuestionsResponse.getType().equals(KEY_BASIC_TYPE) || profileQuestionsResponse.getType().equals(KEY_SETTLEMENT_TYPE)) {
                holder.getBtnQuestionOption().setBackground(ContextCompat.getDrawable(context, R.drawable.question_item_bg));
                holder.getBtnQuestionOption().setTextColor(ContextCompat.getColor(context, R.color.lightBlack));
            } else {
                holder.getRadioButton().setChecked(false);
            }
        }
        holder.itemView.setOnClickListener
                (v -> {
                    if (selectedPosition == position) {
                        return;
                    } else {
                        selectedPosition = position;
                        clickListener.clickListener(currentOptions.get(position).getId(), currentOptions.get(position).getType());
                    }
                    notifyDataSetChanged();

                });

    }

    @Override
    public int getItemCount() {
        return currentOptions != null ? currentOptions.size() : 0;
    }

    public void setClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    @SuppressLint("NotifyDataSetChanged")
    public void addData(List<ProfileQuestionOption> data, Object selectedPosition) {
        this.options = data;
        this.currentOptions = new ArrayList<>(options);
        this.selectedAnswerId = selectedPosition != null ? (long) selectedPosition : -1;
        this.selectedPosition = -1;
        if (selectedAnswerId == -1) {
            clickListener.clickListener(-1, null);
        } else {
            for (ProfileQuestionOption option : currentOptions) {
                if (option.getId() == selectedAnswerId) {
                    clickListener.clickListener(option.getId(), option.getType());
                }
            }
        }
        notifyDataSetChanged();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void search(String searchText) {
        currentOptions.clear();
        selectedPosition = -1;
        ArrayList<ProfileQuestionOption> temp = new ArrayList<>(options);
        for (ProfileQuestionOption option : options) {
            if (option.getName().toLowerCase().startsWith(searchText.toLowerCase())) {
                currentOptions.add(option);
                temp.remove(option);
            }
        }
        for (ProfileQuestionOption option : temp) {
            if (option.getName().toLowerCase().contains(searchText.toLowerCase())) {
                currentOptions.add(option);
            }
        }
        notifyDataSetChanged();
    }

    public interface ClickListener {
        void clickListener(long questionId, String selectedOptionType);
    }
}
