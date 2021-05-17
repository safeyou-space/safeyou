package fambox.pro.view.adapter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
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
import fambox.pro.view.adapter.holder.SocialMediaHolder;

import static fambox.pro.Constants.BASE_URL;

public class SocialMediaAdapter extends RecyclerView.Adapter<SocialMediaHolder> {

    private Context mContext;
    private List<SocialMediaBody> socialMediaBodyList;

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
        String link = socialMediaBodyList.get(position).getSocialMediaLink();
        holder.getSocialMediaName().setText(socialMediaBodyList.get(position).getName());
        holder.getSocialMediaTitle().setText(socialMediaBodyList.get(position).getSocialMediaTitle());
        if (socialMediaBodyList.get(position).getSocialMediaIconPath() != null) {
            Glide.with(mContext).load(BASE_URL.concat(socialMediaBodyList.get(position).getSocialMediaIconPath().replaceAll("\"", "")))
                    .into(holder.getSocialMediaIcon());
        }
        if (link == null) {
            Linkify.addLinks(holder.getSocialMediaTitle(), Linkify.ALL);
        }
        holder.getSocialMediaTitle().setOnClickListener(v -> {
            if (link != null) {
                Uri webpage = Uri.parse(link);
                if (!link.startsWith("http://") && !link.startsWith("https://")) {
                    webpage = Uri.parse("http://" + link);
                }
                Intent intent = new Intent(Intent.ACTION_VIEW, webpage);
                if (intent.resolveActivity(mContext.getPackageManager()) != null) {
                    mContext.startActivity(intent);
                }
            }
        });
        if (position == socialMediaBodyList.size() - 1) {
            holder.getViewDivider().setVisibility(View.GONE);
        }
    }


    @Override
    public int getItemCount() {
        return socialMediaBodyList != null ? socialMediaBodyList.size() : 0;
    }
}
