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
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.UnityNetworkResponse;
import fambox.pro.network.model.UserDetail;
import fambox.pro.view.adapter.holder.EmergencyServiceHolder;

public class EmergencyServiceAdapter extends RecyclerView.Adapter<EmergencyServiceHolder> {

    private EmergencyServiceItemClick mEmergencyServiceItemClick;
    private EmergencyServiceItemClick mEmergencyServiceEditClick;
    private List<ServicesResponseBody> mServicesResponseBody;
    private Context mContext;
    private ServicesResponseBody emergencyContactsResponse0;

    public EmergencyServiceAdapter(Context context) {
        this.mContext = context;
        this.mServicesResponseBody = new ArrayList<>();
        emergencyContactsResponse0 = new ServicesResponseBody();
//        ServicesResponseBody emergencyContactsResponse1 = new ServicesResponseBody();
//        ServicesResponseBody emergencyContactsResponse2 = new ServicesResponseBody();
        UserDetail userDetail = new UserDetail();
        userDetail.setFirst_name(context.getResources().getString(R.string.name_of_service, 1));
        emergencyContactsResponse0.setUser_detail(userDetail);
//        UserDetail userDetail1 = new UserDetail();
//        userDetail1.setFirst_name(context.getResources().getString(R.string.name_of_service, 2));
//        emergencyContactsResponse1.setUser_detail(userDetail1);
//        UserDetail userDetail2 = new UserDetail();
//        userDetail2.setFirst_name(context.getResources().getString(R.string.name_of_service, 3));
//        emergencyContactsResponse2.setUser_detail(userDetail2);
        this.mServicesResponseBody.add(emergencyContactsResponse0);
//        this.mServicesResponseBody.add(emergencyContactsResponse1);
//        this.mServicesResponseBody.add(emergencyContactsResponse2);
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
        String firstName = mServicesResponseBody.get(position).getUser_detail().getFirst_name() == null ?
                "" : mServicesResponseBody.get(position).getUser_detail().getFirst_name();
//        String lastName = mEmergencyContactsResponses.get(position).getUser_detail().getLast_name() == null ?
//                "" : mEmergencyContactsResponses.get(position).getUser_detail().getLast_name();

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

    public void addItem(ServicesResponseBody item, int position) {
        if (mServicesResponseBody != null) {
            mServicesResponseBody.set(position, item);
            if (mServicesResponseBody.size() != 3) {
                this.mServicesResponseBody.add(emergencyContactsResponse0);
                UserDetail userDetail = new UserDetail();
                userDetail.setFirst_name(mContext.getResources().getString(R.string.name_of_service, position + 2));
                emergencyContactsResponse0.setUser_detail(userDetail);
            }
            notifyDataSetChanged();
        }
    }

    public void removeItem(Context context, UnityNetworkResponse item, int position) {
        if (mServicesResponseBody != null) {
            if (mServicesResponseBody.remove(item)) {
                ServicesResponseBody emergencyContactsResponse = new ServicesResponseBody();
                String text = context.getResources().getString(R.string.ngo, position + 1);
                emergencyContactsResponse.getUser_detail().setFirst_name(text);
                mServicesResponseBody.set(position, emergencyContactsResponse);
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
