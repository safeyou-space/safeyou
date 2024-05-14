package fambox.pro.view.adapter;

import static fambox.pro.Constants.Key.KEY_CURRENT_OCCUPATION_TYPE;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.HashMap;

import fambox.pro.R;
import fambox.pro.network.model.ProfileQuestionAnswer;
import fambox.pro.view.adapter.holder.ProfileAnswersListHolder;

public class ProfileAnswersListAdapter extends RecyclerView.Adapter<ProfileAnswersListHolder> {

    private final ArrayList<String> profileAnswersKeys;
    private final HashMap<String, ProfileQuestionAnswer> profileAnswers;
    private final Context context;
    private ClickListener clickListener;

    public ProfileAnswersListAdapter(Context applicationContext, HashMap<String, ProfileQuestionAnswer> profileAnswers) {
        this.profileAnswers = profileAnswers;
        this.profileAnswersKeys = new ArrayList<>(profileAnswers.keySet());
        this.context = applicationContext;
    }

    @NonNull
    @Override
    public ProfileAnswersListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.profile_answers_adapter, parent, false);
        return new ProfileAnswersListHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ProfileAnswersListHolder holder, int position) {
        holder.getAnswerTitle().setText(profileAnswersKeys.get(position));
        holder.getEdtAnswer().setHint(R.string.not_specified_text_key);
        holder.getEdtAnswer().setText(profileAnswers.get(profileAnswersKeys.get(position)).getAnswer());
        if (profileAnswersKeys.get(position).equals(KEY_CURRENT_OCCUPATION_TYPE)) {
            holder.getBtnAnswerDetails().setImageDrawable(ContextCompat.getDrawable(context, R.drawable.new_arrow_icon_purple));
        }
        holder.getBtnAnswerDetails().setOnClickListener(view -> {
            clickListener.clickListener(profileAnswers.get(profileAnswersKeys.get(position)).getQuestionId(),
                    profileAnswers.get(profileAnswersKeys.get(position)).getQuestionOptionId(),
                    profileAnswers.get(profileAnswersKeys.get(position)).getQuestionType(),
                    profileAnswersKeys.get(position));
        });
    }


    @Override
    public int getItemCount() {
        return profileAnswersKeys != null ? profileAnswersKeys.size() : 0;
    }

    public void setClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }


    public interface ClickListener {
        void clickListener(long questionId, long answerId, String questionType, String s);
    }
}
