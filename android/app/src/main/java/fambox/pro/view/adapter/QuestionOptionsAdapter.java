package fambox.pro.view.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.view.adapter.holder.ProfileQuestionsListHolder;

public class QuestionOptionsAdapter extends RecyclerView.Adapter<ProfileQuestionsListHolder> {

    private List<ProfileQuestionOption> questionOptions;
    private ArrayList<ProfileQuestionOption> currentOptions;
    private long answerId;
    private ClickListener clickListener;
    private final Context context;

    public QuestionOptionsAdapter(Context context, List<ProfileQuestionOption> questionOptions, long answerId) {
        this.context = context;
        this.questionOptions = questionOptions;
        this.answerId = answerId;
        this.currentOptions = new ArrayList<>(questionOptions);
    }

    @NonNull
    @Override
    public ProfileQuestionsListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.profile_questions_adapter, parent, false);
        return new ProfileQuestionsListHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ProfileQuestionsListHolder holder, int position) {
        holder.getRadioButton().setChecked(Objects.equals(currentOptions.get(position).getId(), answerId));
        String label = currentOptions.get(position).getName();
        holder.getBtnQuestionOption().setText(label);
        holder.itemView.setOnClickListener
                (v -> {
                    this.answerId = currentOptions.get(position).getId();
                    notifyDataSetChanged();
                    clickListener.clickListener(currentOptions.get(position).getId(), currentOptions.get(position).getType());

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
    public void search(String searchText) {
        currentOptions.clear();
        answerId = -1;
        ArrayList<ProfileQuestionOption> temp = new ArrayList<>(questionOptions);
        for (ProfileQuestionOption option : questionOptions) {
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

    @SuppressLint("NotifyDataSetChanged")
    public void addData(List<ProfileQuestionOption> data) {
        this.questionOptions = data;
        this.currentOptions = new ArrayList<>(questionOptions);
        notifyDataSetChanged();
    }


    public interface ClickListener {
        void clickListener(long questionId, String selectedOptionType);
    }
}
