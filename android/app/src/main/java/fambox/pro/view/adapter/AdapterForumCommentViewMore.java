package fambox.pro.view.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.CommentViewMoreHolder;

import static fambox.pro.Constants.BASE_URL;

public class AdapterForumCommentViewMore extends RecyclerView.Adapter<CommentViewMoreHolder> {

    private Context mContext;
    private List<Comments> mForumCommentReplies;
    private String mLocale;
    private ClickCommentListener mClickCommentListener;
    private int mReplyPosition;

    public AdapterForumCommentViewMore(Context context, List<Comments> forumCommentReplies) {
        this.mContext = context;
        this.mForumCommentReplies = forumCommentReplies;
        this.mLocale = context.getResources().getConfiguration().locale.getLanguage();
    }

    @NonNull
    @Override
    public CommentViewMoreHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_comment_view_more, parent, false);
        return new CommentViewMoreHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull CommentViewMoreHolder holder, int position) {
        Comments forumComment = mForumCommentReplies.get(position);
        holder.getContainerMessages().setBackground(forumComment.isMy() ? ContextCompat.getDrawable(mContext, R.drawable.comment_frame)
                : ContextCompat.getDrawable(mContext, R.drawable.comment_frame_white));
        holder.getTxtCommentUserName().setText(forumComment.getName());
        holder.getTxtCommentUserComment().setText(forumComment.getMessage());
        if (forumComment.getCreated_at() != null) {
            holder.getTxtCommentDate().setText(Utils.timeUTC(forumComment.getCreated_at(), mLocale));
        }
        holder.getTxtCommentUserPosition().setText(forumComment.getUser_type());
        if (forumComment.getReplayedTo() != null) {
            holder.getTxtReplyTo().setVisibility(View.VISIBLE);
            holder.getTxtReplyTo().setText(forumComment.getReplayedTo());
        } else {
            holder.getTxtReplyTo().setVisibility(View.GONE);
        }
        if (forumComment.getImage_path() != null) {
            Glide.with(mContext).load(BASE_URL.concat(forumComment.getImage_path()))
                    .into(holder.getImgCommentUser());
        }

        switch (forumComment.getUser_type_id()) {
            case 1:
                holder.getImgCommentUserBadge().setVisibility(View.GONE);
                break;
            case 2:
                holder.getImgCommentUserBadge().setVisibility(View.VISIBLE);
                break;
            case 3:
                holder.getImgCommentUserBadge().setVisibility(View.VISIBLE);
                break;
            case 4:
                holder.getImgCommentUserBadge().setVisibility(View.VISIBLE);
                break;
            case 5:
                holder.getTxtCommentUserPosition().setVisibility(View.GONE);
                holder.getImgCommentUserBadge().setVisibility(View.GONE);
                break;
            default:
                holder.getImgCommentUserBadge().setVisibility(View.VISIBLE);
        }

        holder.getTxtReply().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickComment(forumComment);
                mReplyPosition = position;
            }
        });
    }

    @Override
    public int getItemCount() {
        return mForumCommentReplies == null ? 0 : mForumCommentReplies.size();
    }

    public void addMessage(Comments comment, RecyclerView recyclerView) {
        for (Comments reply : mForumCommentReplies) {
            if (comment.getReply_id() == reply.getId()) {
                Log.i("tagik", "addMessage: " + reply);
                String repliedTo = mContext.getResources()
                        .getString(R.string.reply_to, reply.getName());
                comment.setReplayedTo(repliedTo);
            }
        }
        mForumCommentReplies.add(comment);
        recyclerView.smoothScrollToPosition(getItemCount() - 1);
        notifyItemInserted(getItemCount() - 1);
    }

    public void setClickCommentListener(ClickCommentListener clickCommentListener) {
        this.mClickCommentListener = clickCommentListener;
    }

    public interface ClickCommentListener {
        void onClickComment(Comments comment);
    }
}
