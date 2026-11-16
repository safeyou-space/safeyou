package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import fambox.pro.R;
import fambox.pro.view.adapter.holder.CategoryTypesHolder;

public class AdapterCategoryType extends RecyclerView.Adapter<CategoryTypesHolder> {

    public static final Long ALL = -111L;
    private final CategoryTypeClickListener mCategoryTypeClickListener;
    private final List<String> buttonNames = new ArrayList<>();
    private final List<Long> ides = new ArrayList<>();
    private final Context mContext;

    private ToggleButton lastCheckedToggleBTN = null;

    public AdapterCategoryType(Context context, Map<String, String> mCategoryServices,
                               CategoryTypeClickListener categoryTypeClickListener) {
        this.mContext = context;
        this.mCategoryTypeClickListener = categoryTypeClickListener;
        buttonNames.addAll(mCategoryServices.values());
        for (String id : mCategoryServices.keySet()) {
            ides.add(Long.valueOf(id));
        }
        if (buttonNames.size() > 0) {
            buttonNames.add(0, context.getResources().getString(R.string.title_all));
            ides.add(0, ALL);
        }
    }

    @NonNull
    @Override
    public CategoryTypesHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_category_types, parent, false);
        return new CategoryTypesHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull CategoryTypesHolder holder, int position) {

        if (buttonNames != null) {
            holder.getTglCategoryType().setTextOn(buttonNames.get(position));
            holder.getTglCategoryType().setTextOff(buttonNames.get(position));
            holder.getTglCategoryType().setText(buttonNames.get(position));
        }
        if (position == 0) {
            holder.getTglCategoryType().setChecked(true);
            holder.getTglCategoryType().setClickable(false);
            holder.getTglCategoryType().setTextColor(mContext.getResources().getColor(R.color.white));
        }
        if (holder.getTglCategoryType().isChecked()) {
            lastCheckedToggleBTN = holder.getTglCategoryType();
        }
        holder.getTglCategoryType().setOnClickListener(v -> {
            ToggleButton toggleButton = (ToggleButton) v;
            if (toggleButton.isChecked()) {
                if (lastCheckedToggleBTN != null) {
                    lastCheckedToggleBTN.setChecked(false);
                    lastCheckedToggleBTN.setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
                    holder.getTglCategoryType().setTextColor(mContext.getResources().getColor(R.color.white));
                    holder.getTglCategoryType().setSelected(false);
                    holder.getTglCategoryType().setClickable(false);
                    lastCheckedToggleBTN.setClickable(true);
                }
                lastCheckedToggleBTN = toggleButton;
            } else {
                lastCheckedToggleBTN = null;
            }
            mCategoryTypeClickListener.onCategoryTypeClickListener(ides.get(position));
        });
        lastCheckedToggleBTN.setClickable(false);
    }

    @Override
    public int getItemCount() {
        return ides == null ? 0 : ides.size();
    }

    public interface CategoryTypeClickListener {
        void onCategoryTypeClickListener(Long categoryId);
    }
}
