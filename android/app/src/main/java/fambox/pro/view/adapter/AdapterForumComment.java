package fambox.pro.view.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.CommentHolder;

import static fambox.pro.Constants.BASE_URL;

public class AdapterForumComment extends RecyclerView.Adapter<CommentHolder> {

    private Context mContext;
    private List<Comments> mForumComments;
    private List<Comments> mForumCommentReplies;
    private String mLocale;
    private ClickCommentListener mClickMoreListener;
    private ClickReplyListener mClickCommentListener;
    private int mReplyPosition;
    private boolean isTypedFromUserSide;

    public AdapterForumComment(Context context, List<Comments> forumComments, List<Comments> forumCommentReplies) {
        this.mContext = context;
        this.mForumComments = forumComments;
        this.mForumCommentReplies = forumCommentReplies;
        this.mLocale = context.getResources().getConfiguration().locale.getLanguage();
    }

    @NonNull
    @Override
    public CommentHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_comment, parent, false);
        return new CommentHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull CommentHolder holder, int position) {
        Comments forumComment = mForumComments.get(position);
        holder.getContainerMessages().setBackground(forumComment.isMy() ? ContextCompat.getDrawable(mContext, R.drawable.comment_frame)
                : ContextCompat.getDrawable(mContext, R.drawable.comment_frame_white));
        holder.getTxtCommentUserName().setText(forumComment.getName());
        holder.getTxtCommentUserComment().setText(forumComment.getMessage());
        if (forumComment.getCreated_at() != null) {
            holder.getTxtCommentDate().setText(Utils.timeUTC(forumComment.getCreated_at(), mLocale));
        }
        holder.getTxtCommentUserPosition().setText(forumComment.getUser_type());
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
                mClickCommentListener.onClickReply(forumComment, null);
                mReplyPosition = position;
            }
        });

        holder.getTxtReplyOne().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickReply(forumComment, comment);
                mReplyPosition = position;
            }
        });

        holder.getTxtReplyTwo().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickReply(forumComment, comment);
                mReplyPosition = position;
            }
        });

        holder.getTxtViewMore().setOnClickListener(v -> {
            if (mClickMoreListener != null) {
                mClickMoreListener.onClickComment(forumComment);
            }
        });

        holder.getContainerMessagesOne().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickReply(forumComment, comment);
                mReplyPosition = position;
            }
        });

        holder.getContainerMessagesTwo().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickReply(forumComment, comment);
                mReplyPosition = position;
            }
        });

        List<Comments> replyCommentFilter = new ArrayList<>();
        for (Comments replyComment : mForumCommentReplies) {
            if (replyComment.getGroup_id() == forumComment.getGroup_id()) {
                replyCommentFilter.add(replyComment);
            }
        }

        holder.addReply(mContext, replyCommentFilter);
    }

    @Override
    public int getItemCount() {
        return mForumComments == null ? 0 : mForumComments.size();
    }

    public void addMessage(Comments comment, RecyclerView recyclerView) {
        if (isTypedFromUserSide) {
            isTypedFromUserSide = false;
            int itemCountAfterAdd = getItemCount();
            mForumComments.add(comment);
            LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
            if (layoutManager != null) {
                if (layoutManager.findLastVisibleItemPosition() == itemCountAfterAdd - 1) {
                    recyclerView.smoothScrollToPosition(getItemCount() - 1);
                } else {
                    recyclerView.scrollToPosition(getItemCount() - 1);
                }
            }
            notifyItemInserted(getItemCount() - 1);
            Log.i("tagik", "isTypedFromUserSide: true");
        } else {
            if (comment.getReply_id() == 0) {
                int itemCountAfterAdd = getItemCount();
                mForumComments.add(comment);
                LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
                if (layoutManager != null) {
                    if (layoutManager.findLastVisibleItemPosition() == itemCountAfterAdd - 1) {
                        recyclerView.smoothScrollToPosition(getItemCount() - 1);
                    }
                }
                notifyItemInserted(getItemCount() - 1);
                Log.i("tagik", "comment.getReply_id() == 0: true");
            } else {
                mForumCommentReplies.add(comment);
                notifyItemChanged(mReplyPosition);
                Log.i("tagik", "comment.getReply_id() == 0: false");
            }
            Log.i("tagik", "isTypedFromUserSide: false");
        }
    }

    public int scrollToReply(long replyIdFromNotification) {
        for (Comments comment : mForumCommentReplies) {
            if (comment.getReply_id() == replyIdFromNotification) {
                for (int i = 0; i < mForumComments.size(); i++) {
                    if (comment.getGroup_id() == mForumComments.get(i).getGroup_id()) {
                        Log.i("tagikkkk", "scrollToReply: " + i);
                        return i;
                    }
                }
            }
        }
        return 0;
    }

    public void setTypedFromUserSide(boolean typedFromUserSide) {
        isTypedFromUserSide = typedFromUserSide;
    }

    public void setClickMoreListener(ClickCommentListener mClickMoreListener) {
        this.mClickMoreListener = mClickMoreListener;
    }

    public void setClickCommentListener(ClickReplyListener clickCommentListener) {
        this.mClickCommentListener = clickCommentListener;
    }

    public interface ClickCommentListener {
        void onClickComment(Comments comment);
    }

    public interface ClickReplyListener {
        void onClickReply(Comments comment, Comments replyComment);
    }
}
