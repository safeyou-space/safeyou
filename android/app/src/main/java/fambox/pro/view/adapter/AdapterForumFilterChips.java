package fambox.pro.view.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.forum.ForumFilter;
import fambox.pro.view.adapter.holder.ForumFilterChipsHolder;

public class AdapterForumFilterChips extends RecyclerView.Adapter<ForumFilterChipsHolder> {

    private final List<ForumFilter> filters;
    private OnClickChipDeleteListener mOnClickChipDeleteListener;

    public AdapterForumFilterChips(List<ForumFilter> filters) {
        this.filters = filters;
    }

    @NonNull
    @Override
    public ForumFilterChipsHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_filter_chip, parent, false);
        return new ForumFilterChipsHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ForumFilterChipsHolder holder, int position) {
        holder.getChipName().setText(filters.get(position).getName());
        holder.getBtnChipsClose().setOnClickListener(v -> {
            if (mOnClickChipDeleteListener != null) {
                ForumFilter deletedFilter = filters.remove(position);
                notifyItemRemoved(position);
                notifyItemRangeChanged(position, filters.size());
                JSONObject category = new JSONObject();
                String language = null;
                try {
                    for (ForumFilter forumFilter : filters) {
                        if (forumFilter.getType() == 1) {
                            language = forumFilter.getName();
                        } else {
                            category.put(String.valueOf(forumFilter.getId()), forumFilter.getId());
                        }
                    }
                    mOnClickChipDeleteListener.onClickDeleteChip(category.toString(), language, filters);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return filters != null ? filters.size() : 0;
    }

    public void setOnClickChipDeleteListener(OnClickChipDeleteListener mOnClickChipDeleteListener) {
        this.mOnClickChipDeleteListener = mOnClickChipDeleteListener;
    }

    public interface OnClickChipDeleteListener {
        void onClickDeleteChip(String category, String language, List<ForumFilter> filters);
    }
}
