package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.view.adapter.holder.EmergencyContactHolder;

public class EmergencyContactAdapter extends RecyclerView.Adapter<EmergencyContactHolder> {

    private EmergencyContactItemClick mEmergencyContactItemClick;
    private EmergencyContactItemClick mEmergencyContactEditClick;
    private List<EmergencyContactsResponse> mEmergencyContactsResponses;
    private Context mContext;
    private EmergencyContactsResponse emergencyContactsResponse0;
//    EmergencyContactsResponse emergencyContactsResponse1;
//    EmergencyContactsResponse emergencyContactsResponse2;

    public EmergencyContactAdapter(Context context) {
        this.mContext = context;
        this.mEmergencyContactsResponses = new ArrayList<>();
        emergencyContactsResponse0 = new EmergencyContactsResponse();
//        emergencyContactsResponse1 = new EmergencyContactsResponse();
//        emergencyContactsResponse2 = new EmergencyContactsResponse();
        emergencyContactsResponse0.setName(context.getResources().getString(R.string.name_lastname));
//        emergencyContactsResponse1.setName(context.getResources().getString(R.string.name_lastname));
//        emergencyContactsResponse2.setName(context.getResources().getString(R.string.name_lastname));
        this.mEmergencyContactsResponses.add(emergencyContactsResponse0);
//        this.mEmergencyContactsResponses.add(emergencyContactsResponse1);
//        this.mEmergencyContactsResponses.add(emergencyContactsResponse2);
    }

    @NonNull
    @Override
    public EmergencyContactHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_my_emergency_contact, parent, false);
        return new EmergencyContactHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull EmergencyContactHolder holder, int position) {
        holder.getTxtContactTitle().setText(mContext.getResources().getString(R.string.emergency_contact,
                position + 1));
        holder.getTxtContactName().setText(mEmergencyContactsResponses.get(position).getName());
        if (mEmergencyContactsResponses.get(position).getId() != 0) {
            holder.getTxtContactClear().setVisibility(View.VISIBLE);
        } else {
            holder.getTxtContactClear().setVisibility(View.GONE);
            holder.getImgEditContact().setVisibility(View.VISIBLE);
        }

        holder.itemView.setOnClickListener(v -> {
            if (mEmergencyContactItemClick != null) {
                mEmergencyContactItemClick.onEmergencyContactClick(mEmergencyContactsResponses.get(position), position);
            }
        });

        holder.getTxtContactClear().setOnClickListener(v -> {
            if (mEmergencyContactEditClick != null) {
                mEmergencyContactEditClick.onEmergencyContactClick(mEmergencyContactsResponses.get(position), position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mEmergencyContactsResponses != null ? mEmergencyContactsResponses.size() : 0;
    }

    public void addItem(EmergencyContactsResponse item, int position) {
        if (mEmergencyContactsResponses != null) {
            mEmergencyContactsResponses.set(position, item);
            if (mEmergencyContactsResponses.size() != 3) {
                this.mEmergencyContactsResponses.add(emergencyContactsResponse0);
            }
            notifyDataSetChanged();
        }
    }

    public void removeItem(Context context, EmergencyContactsResponse item, int position) {
        if (mEmergencyContactsResponses != null) {
            if (mEmergencyContactsResponses.remove(item)) {
                EmergencyContactsResponse emergencyContactsResponse = new EmergencyContactsResponse();
                String text = context.getResources().getString(R.string.emergency_contact, position + 1);
                emergencyContactsResponse.setName(text);
                mEmergencyContactsResponses.set(position, emergencyContactsResponse);
            }
            notifyDataSetChanged();
        }
    }

    public void setEmergencyContactItemClick(EmergencyContactItemClick mEmergencyContactItemClick) {
        this.mEmergencyContactItemClick = mEmergencyContactItemClick;
    }

    public void setEmergencyContactEditClick(EmergencyContactItemClick mEmergencyContactEditClick) {
        this.mEmergencyContactEditClick = mEmergencyContactEditClick;
    }

    public interface EmergencyContactItemClick {
        void onEmergencyContactClick(EmergencyContactsResponse emergencyContactsResponse, int position);
    }
}
