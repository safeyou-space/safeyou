package fambox.pro.view.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.UnityNetworkResponse;
import fambox.pro.view.adapter.holder.MapNGOsHolder;

public class MapNGOsAdapter extends RecyclerView.Adapter<MapNGOsHolder> {

    private MapItemsClick mItemClick;
    private MapItemsClick mItemCallClick;
    private MapItemsClick mItemEmailClick;
    private List<ServicesResponseBody> mServicesResponseBodyList;


    public MapNGOsAdapter(List<ServicesResponseBody> servicesResponseBodyList) {
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
        holder.getTxtMapNgoAddress().setText(mServicesResponseBodyList.get(position).getUser_detail().getLocation());
        holder.itemView.setOnClickListener(v -> mItemClick.onMapItemsClick(position));
        holder.getImgBtnCall().setOnClickListener(v -> mItemCallClick.onMapItemsClick(position));
        holder.getImgBtnEmail().setOnClickListener(v -> mItemEmailClick.onMapItemsClick(position));
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

    public interface MapItemsClick {
        void onMapItemsClick(int position);
    }
}
