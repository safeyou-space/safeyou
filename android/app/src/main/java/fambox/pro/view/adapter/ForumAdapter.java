package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.ForumData;
import fambox.pro.view.adapter.holder.ForumHolder;

import static fambox.pro.Constants.BASE_URL;

public class ForumAdapter extends RecyclerView.Adapter<ForumHolder> {

    private ForumItemClick mForumItemClick;
    private List<ForumData> mForumDataList;
    private Context mContext;

    public ForumAdapter(List<ForumData> mForumDataList, Context mContext) {
        this.mForumDataList = mForumDataList;
        this.mContext = mContext;
    }

    @NonNull
    @Override
    public ForumHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_forum, parent, false);
        return new ForumHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ForumHolder holder, int position) {
        holder.getTxtTitleForum().setText(mForumDataList.get(position).getTitle());
        holder.getTxtUnderTitle().setText(mForumDataList.get(position).getSub_title());
        holder.getTxtShortDescription().setText(mForumDataList.get(position).getShort_description());
        if (mForumDataList.get(position).getImage_path() != null) {
            Glide.with(mContext).load(BASE_URL.concat(mForumDataList.get(position).getImage_path()))
                    .into(holder.getImgForumTitle());
        }

        String forumCommentCount = mContext.getResources().getString(R.string.forum_comment_count,
                mForumDataList.get(position).getComments_count());
        holder.getTxtCommentCount().setText(forumCommentCount);
        holder.itemView.setOnClickListener(v -> {
            if (mForumItemClick != null) {
                mForumItemClick.onMoreInfoClick(mForumDataList.get(position));
            }
        });

        if (mForumDataList.get(position).getNEW_MESSAGES_COUNT() > 0) {
            holder.getContainerHigLightFrame().setVisibility(View.VISIBLE);
            holder.getTxtRecentlyCount().setText(mContext.getResources().getString(
                    R.string.people_recently_commented_on_this_post, mForumDataList.get(position).getNEW_MESSAGES_COUNT()));
        } else {
            holder.getContainerHigLightFrame().setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return mForumDataList == null ? 0 : mForumDataList.size();
    }

    public void setForumItemClick(ForumItemClick mForumItemClick) {
        this.mForumItemClick = mForumItemClick;
    }

    public interface ForumItemClick {
        void onMoreInfoClick(ForumData forumData);
    }
}
