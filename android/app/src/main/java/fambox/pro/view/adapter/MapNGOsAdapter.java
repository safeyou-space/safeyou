package fambox.pro.view.adapter;

import static fambox.pro.Constants.BASE_URL;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.MapNGOsHolder;

public class MapNGOsAdapter extends RecyclerView.Adapter<MapNGOsHolder> {

    private MapItemsClick mItemClick;
    private MapItemsClick mItemCallClick;
    private MapItemsClick mItemEmailClick;
    private MapItemsClick mItemPrivatMsgClick;
    private final List<ServicesResponseBody> mServicesResponseBodyList;
    private final Context mContext;

    public MapNGOsAdapter(Context mContext, List<ServicesResponseBody> servicesResponseBodyList) {
        this.mContext = mContext;
        this.mServicesResponseBodyList = servicesResponseBodyList;
    }

    @NonNull
    @Override
    public MapNGOsHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_map_ngos, parent, false);
        return new MapNGOsHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull MapNGOsHolder holder, int position) {

        holder.getTxtMapNgoName().setText(mServicesResponseBodyList.get(position).getTitle());
        holder.getNgoImage().setContentDescription(String.format(mContext.getString(R.string.ngo_image_description), mServicesResponseBodyList.get(position).getTitle()));
        StringBuilder fullAddress = new StringBuilder();
        String city = mServicesResponseBodyList.get(position).getCity();
        String address = mServicesResponseBodyList.get(position).getAddress();
        String phoneNumber = mServicesResponseBodyList.get(position).getPhone();
        String email = mServicesResponseBodyList.get(position).getEmail();
        String shortDescription = mServicesResponseBodyList.get(position).getDescription();


        if (city != null && !city.equals("")) {
            fullAddress.append(city);
        }
        if (address != null && !address.equals("")) {
            fullAddress.append(fullAddress.length() > 0 ? (", " + address) : address);
        }
        holder.getTxtMapNgoAddress().setText(fullAddress);

        holder.itemView.setOnClickListener(v -> mItemClick.onMapItemsClick(position));
        holder.getImgBtnCall().setOnClickListener(v -> mItemCallClick.onMapItemsClick(position));
        holder.getImgBtnEmail().setOnClickListener(v -> mItemEmailClick.onMapItemsClick(position));
        if (SafeYouApp.isMinorUser() && (mServicesResponseBodyList.get(position).getId() != 4 && mServicesResponseBodyList.get(position).getId() != 2)) {
            holder.getImgBtnPrivateMessage().setVisibility(View.GONE);
        }
        holder.getImgBtnPrivateMessage().setOnClickListener(v -> mItemPrivatMsgClick.onMapItemsClick(position));

        if (phoneNumber != null && !phoneNumber.equals("")) {
            holder.getTxtPhoneNumber().setText(phoneNumber);
        } else {
            holder.getTxtPhoneNumber().setVisibility(View.GONE);
            holder.getImgBtnCall().setVisibility(View.GONE);
        }

        if (email != null && !email.equals("")) {
            holder.getTxtEmail().setText(email);
        } else {
            holder.getTxtEmail().setVisibility(View.GONE);
            holder.getImgBtnEmail().setVisibility(View.GONE);
        }

        if (shortDescription != null && !shortDescription.equals("")) {
            holder.getTxtShortDecscription().setText(email);
        } else {
            holder.getTxtShortDecscription().setVisibility(View.GONE);
            holder.getImgInfo().setVisibility(View.GONE);
        }

        holder.getTxtShortDecscription().setText(Utils.convertStringToHtml(mServicesResponseBodyList.get(position).getDescription()));


        String imagePath = BASE_URL.concat(mServicesResponseBodyList.get(position).getUser_detail().getImage().getUrl());
        Glide.with(mContext)
                .asBitmap()
                .load(imagePath)
                .placeholder(R.drawable.profile_bottom_icon)
                .error(R.drawable.profile_bottom_icon)
                .into(holder.getNgoImage());
    }

    @Override
    public int getItemCount() {
        return mServicesResponseBodyList != null ? mServicesResponseBodyList.size() : 0;
    }

    public void setItemClick(MapItemsClick mItemClick) {
        this.mItemClick = mItemClick;
    }

    public void setItemCallClick(MapItemsClick mItemCallClick) {
        this.mItemCallClick = mItemCallClick;
    }

    public void setItemEmailClick(MapItemsClick mItemEmailClick) {
        this.mItemEmailClick = mItemEmailClick;
    }

    public void setItemPrivatMessageClick(MapItemsClick itemPrivatMsgClick) {
        this.mItemPrivatMsgClick = itemPrivatMsgClick;
    }

    public interface MapItemsClick {
        void onMapItemsClick(int position);
    }
}
