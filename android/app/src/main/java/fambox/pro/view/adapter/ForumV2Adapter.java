package fambox.pro.view.adapter;

import static fambox.pro.Constants.BASE_URL;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.utils.TimeUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.ForumHolder;

public class ForumV2Adapter extends RecyclerView.Adapter<ForumHolder> {

    private ForumItemClick mForumItemClick;
    private final List<ForumResponseBody> mForumDataList;
    private final Context mContext;

    public ForumV2Adapter(List<ForumResponseBody> mForumDataList, Context mContext) {
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
        holder.getImgForumTitle().setContentDescription(String.format(mContext.getString(R.string.forum_image_description), mForumDataList.get(position).getTitle()));
        holder.getTxtTitleForum().setText(mForumDataList.get(position).getTitle());
        holder.getTxtUnderTitle().setText(String.format("%s | %s", mForumDataList.get(position).getAuthor(),
                TimeUtil.convertPrivatChatListDate(mContext.getResources().getConfiguration().locale.getLanguage(),
                        mForumDataList.get(position).getCreatedAt())));
        holder.getTxtShortDescription().setText(Utils.convertStringToHtml(mForumDataList.get(position).getShortDescription()));
        String countryCode = SafeYouApp.getPreference(mContext)
                .getStringValue(KEY_COUNTRY_CODE, "arm");

        if (Objects.equals(countryCode, "irq")) {
            holder.getRateBar().setVisibility(View.GONE);
        } else {
            holder.getRateBar().setVisibility(View.VISIBLE);
        }
        if (mForumDataList.get(position).getRate() == null) {
            holder.getRating().setText("");
            holder.getRateCount().setText("");
            holder.getRating().setVisibility(View.GONE);
        } else {
            Double rate = mForumDataList.get(position).getRate();
            if ((rate == Math.floor(rate)) && !Double.isInfinite(rate)) {
                holder.getRateBar().setContentDescription(
                        String.format(mContext.getString(R.string.average_rate_icon_description), rate.intValue(), 5, mForumDataList.get(position).getRatesCount()));
                holder.getRating().setText(String.format(mContext.getResources().getConfiguration().locale, "%d/5", rate.intValue()));
            } else {
                holder.getRateBar().setContentDescription(
                        String.format(mContext.getString(R.string.average_rate_double_icon_description), rate, 5, mForumDataList.get(position).getRatesCount()));
                holder.getRating().setText(String.format(mContext.getResources().getConfiguration().locale, "%1$,.1f/5", rate));
            }
            holder.getRating().setVisibility(View.VISIBLE);
            holder.getRateCount().setText(String.format("(%d)", mForumDataList.get(position).getRatesCount()));
        }
        if (mForumDataList.get(position).getImage() != null) {
            Glide.with(mContext).load(BASE_URL.concat(mForumDataList.get(position).getImage().getUrl()))
                    .into(holder.getImgForumTitle());
        }

        holder.getTxtCommentCount().setText(String.valueOf(mForumDataList.get(position).getCommentsCount()));
        holder.getTxtViewsCount().setText(String.valueOf(mForumDataList.get(position).getViewsCount()));
        holder.itemView.setOnClickListener(v -> {
            if (mForumItemClick != null) {
                mForumItemClick.onMoreInfoClick(mForumDataList.get(position));
            }
        });
    }

    @SuppressLint("NotifyDataSetChanged")
    public void addForums(List<ForumResponseBody> forums, boolean forumByFilterEnabled, boolean allChipsRemoved) {
        if (forumByFilterEnabled) {
            mForumDataList.clear();
        }
        if (allChipsRemoved) {
            mForumDataList.clear();
        }
        if (forums != null) {
            mForumDataList.addAll(forums);
            notifyDataSetChanged();
        }
    }

    @Override
    public int getItemCount() {
        return mForumDataList == null ? 0 : mForumDataList.size();
    }

    public void setForumItemClick(ForumItemClick mForumItemClick) {
        this.mForumItemClick = mForumItemClick;
    }

    public void setCommentsCount(int forumId, int messagesCount) {
        for (ForumResponseBody forumResponseBody : mForumDataList) {
            if (forumResponseBody.getId() == forumId) {
                forumResponseBody.setCommentsCount(messagesCount);
            }
        }
    }

    public interface ForumItemClick {
        void onMoreInfoClick(ForumResponseBody forumData);
    }
}
