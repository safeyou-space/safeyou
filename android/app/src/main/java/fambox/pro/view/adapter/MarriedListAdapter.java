package fambox.pro.view.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.view.adapter.holder.MarriedListHolder;

public class MarriedListAdapter extends RecyclerView.Adapter<MarriedListHolder> {

    private final List<MarriedListResponse> marriedListResponses;
    private ClickListener clickListener;
    private final String maritalStatus;
    private final int maritalStatusRegistration;
    private final boolean isRegistration;
    private final Context context;

    public MarriedListAdapter(Context context, List<MarriedListResponse> marriedListResponses,
                              String maritalStatus, int maritalStatusRegistration, boolean isRegistration) {
        this.context = context;
        this.marriedListResponses = marriedListResponses;
        this.maritalStatus = maritalStatus;
        this.maritalStatusRegistration = maritalStatusRegistration;
        this.isRegistration = isRegistration;
    }

    @NonNull
    @Override
    public MarriedListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.married_adapter, parent, false);
        return new MarriedListHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull MarriedListHolder holder, int position) {
        Drawable img = context.getResources().getDrawable(R.drawable.check_icon);
        if (Objects.equals(marriedListResponses.get(position).getLabel(), maritalStatus)) {
            holder.getBtnMarried().setCompoundDrawablesWithIntrinsicBounds(null, null, img, null);
            holder.getBtnMarried().setTextColor(context.getResources().getColor(R.color.textPurpleColor));
        } else if (Objects.equals(marriedListResponses.get(position).getType(), maritalStatusRegistration)
                && isRegistration) {
            holder.getBtnMarried().setCompoundDrawablesWithIntrinsicBounds(null, null, img, null);
        }
        String label = marriedListResponses.get(position).getLabel();
        holder.getBtnMarried().setText(label);
        holder.getBtnMarried().setOnClickListener
                (v -> clickListener.clickListener(position, marriedListResponses.get(position).getType(), label));

    }

    @Override
    public int getItemCount() {
        return marriedListResponses != null ? marriedListResponses.size() : 0;
    }

    public void setClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener {
        void clickListener(int position, int type, String label);
    }
}
