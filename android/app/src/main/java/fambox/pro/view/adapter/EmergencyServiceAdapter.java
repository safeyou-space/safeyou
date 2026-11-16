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

import fambox.pro.R;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.view.adapter.holder.EmergencyServiceHolder;

public class EmergencyServiceAdapter extends RecyclerView.Adapter<EmergencyServiceHolder> {

    private final List<ServicesResponseBody> mServicesResponseBody;
    private final Context mContext;
    private final ServicesResponseBody emergencyContactsResponse0;

    private EmergencyServiceItemClick mEmergencyServiceItemClick;
    private EmergencyServiceItemClick mEmergencyServiceEditClick;

    public EmergencyServiceAdapter(Context context) {
        this.mContext = context;
        this.mServicesResponseBody = new ArrayList<>();
        emergencyContactsResponse0 = new ServicesResponseBody();
        ServicesResponseBody emergencyContactsResponse1 = new ServicesResponseBody();
        ServicesResponseBody emergencyContactsResponse2 = new ServicesResponseBody();
        emergencyContactsResponse0.setTitle(context.getResources().getString(R.string.ngo_title_key, 1));
        emergencyContactsResponse1.setTitle(context.getResources().getString(R.string.ngo_title_key, 2));
        emergencyContactsResponse2.setTitle(context.getResources().getString(R.string.ngo_title_key, 3));
        this.mServicesResponseBody.add(emergencyContactsResponse0);
        this.mServicesResponseBody.add(emergencyContactsResponse1);
        this.mServicesResponseBody.add(emergencyContactsResponse2);
    }

    @NonNull
    @Override
    public EmergencyServiceHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_my_emergency_service, parent, false);
        return new EmergencyServiceHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull EmergencyServiceHolder holder, int position) {
        holder.getTxtServiceTitle().setText(mContext.getResources().getString(R.string.support_contact, position + 1));
        String firstName = mServicesResponseBody.get(position).getTitle();

        holder.getTxtServiceName().setText(firstName);

        if (mServicesResponseBody.get(position).getId() != 0) {
            holder.getTxtServiceClear().setVisibility(View.VISIBLE);
        } else {
            holder.getTxtServiceClear().setVisibility(View.GONE);
            holder.getImgEditService().setVisibility(View.VISIBLE);
        }

        holder.itemView.setOnClickListener(v -> {
            if (mEmergencyServiceItemClick != null) {
                mEmergencyServiceItemClick.onEmergencyServiceClick(mServicesResponseBody.get(position), position);
            }
        });

        holder.getTxtServiceClear().setOnClickListener(v -> {
            if (mEmergencyServiceEditClick != null) {
                mEmergencyServiceEditClick.onEmergencyServiceClick(mServicesResponseBody.get(position), position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mServicesResponseBody != null ? mServicesResponseBody.size() : 0;
    }

    @SuppressLint("NotifyDataSetChanged")
    public void addItem(ServicesResponseBody item, int position) {
        if (mServicesResponseBody != null) {
            mServicesResponseBody.set(position, item);
            if (mServicesResponseBody.size() != 3) {
                this.mServicesResponseBody.add(emergencyContactsResponse0);
                emergencyContactsResponse0.setTitle(mContext.getResources().getString(R.string.ngo_title_key, position + 2));
            }
            notifyDataSetChanged();
        }
    }

    public void setEmergencyServiceItemClick(EmergencyServiceItemClick mEmergencyServiceItemClick) {
        this.mEmergencyServiceItemClick = mEmergencyServiceItemClick;
    }

    public void setEmergencyServiceEditClick(EmergencyServiceItemClick mEmergencyServiceEditClick) {
        this.mEmergencyServiceEditClick = mEmergencyServiceEditClick;
    }

    public interface EmergencyServiceItemClick {
        void onEmergencyServiceClick(ServicesResponseBody emergencyContactsResponse, int position);
    }
}
