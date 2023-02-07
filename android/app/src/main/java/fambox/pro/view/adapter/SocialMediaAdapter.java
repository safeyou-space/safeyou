package fambox.pro.view.adapter;

import static fambox.pro.Constants.BASE_URL;

import android.content.Context;
import android.text.util.Linkify;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.SocialMediaBody;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.SocialMediaHolder;

public class SocialMediaAdapter extends RecyclerView.Adapter<SocialMediaHolder> {

    private final Context mContext;
    private final List<SocialMediaBody> socialMediaBodyList;

    public SocialMediaAdapter(Context mContext, List<SocialMediaBody> socialMediaBodyList) {
        this.mContext = mContext;
        this.socialMediaBodyList = socialMediaBodyList;
    }

    @NonNull
    @Override
    public SocialMediaHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_social_media, parent, false);
        return new SocialMediaHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull SocialMediaHolder holder, int position) {
        holder.getSocialMediaName().setText(socialMediaBodyList.get(position).getName());
        holder.getSocialMediaTitle().setText(socialMediaBodyList.get(position).isHtml()
                ? Utils.convertStringToHtml(socialMediaBodyList.get(position).getSocialMediaTitle())
                : socialMediaBodyList.get(position).getSocialMediaLink() == null ?
                socialMediaBodyList.get(position).getSocialMediaTitle() : socialMediaBodyList.get(position).getSocialMediaLink());

        if (socialMediaBodyList.get(position).getSocialMediaIconPath() != null) {
            Glide.with(mContext).load(BASE_URL.concat(socialMediaBodyList.get(position).getSocialMediaIconPath().replaceAll("\"", "")))
                    .into(holder.getSocialMediaIcon());
            holder.getSocialMediaIcon().setContentDescription(socialMediaBodyList.get(position).getName());
        }
        Linkify.addLinks(holder.getSocialMediaTitle(), Linkify.ALL);
        if (position == socialMediaBodyList.size() - 1) {
            holder.getViewDivider().setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return socialMediaBodyList != null ? socialMediaBodyList.size() : 0;
    }
}
