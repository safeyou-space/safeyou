package fambox.pro.view.adapter;

import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;

import android.annotation.SuppressLint;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupMenu;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.privatechat.network.model.Like;
import fambox.pro.utils.Utils;
import fambox.pro.view.ReportActivity;
import fambox.pro.view.adapter.holder.CommentHolder;

public class AdapterForumComment extends RecyclerView.Adapter<CommentHolder> {

    private final Context mContext;
    private final List<Comments> mForumComments;
    private final String mLocale;
    private final long mCurrentUserID;
    private ClickCommentListener mClickMoreListener;
    private ClickReplyListener mClickCommentListener;
    private boolean isTypedFromUserSide;

    public AdapterForumComment(Context context, List<Comments> forumComments, List<Comments> forumCommentReplies) {
        this.mContext = context;
        this.mForumComments = forumComments;
        this.mLocale = LocaleHelper.getLanguage(mContext);
        this.mCurrentUserID = SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0);
    }

    @NonNull
    @Override
    public CommentHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_comment, parent, false);
        return new CommentHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull CommentHolder holder, @SuppressLint("RecyclerView") int position) {
        Comments forumComment = mForumComments.get(position);
        List<Comments> mForumCommentReplies = new ArrayList<>();
        if (forumComment.getMessageReplies() != null) {
            for (Comments comments : forumComment.getMessageReplies()) {
                if (!comments.isHidden()) {
                    mForumCommentReplies.add(comments);
                }
            }
        }
        holder.getContainerMessages().setBackground(forumComment.isMy() ? ContextCompat.getDrawable(mContext, R.drawable.comment_frame)
                : ContextCompat.getDrawable(mContext, R.drawable.comment_frame_white));
        holder.getTxtCommentUserName().setText(forumComment.getName());
        holder.getTxtCommentUserComment().setText(forumComment.getMessage());
        holder.getPrvtMessageBtn().setVisibility(forumComment.getUser_id() == mCurrentUserID
                || forumComment.getUser_type_id() == 5 || (SafeYouApp.isMinorUser() && forumComment.getUser_id() != 10 && forumComment.getUser_id() != 8) ? View.GONE : View.VISIBLE);

        if (forumComment.getContentImage() != null && !forumComment.getContentImage().equals("")) {
            holder.getForumImage().setVisibility(View.VISIBLE);
            Glide.with(mContext).load(forumComment.getContentImage()).into(holder.getForumImage());
        } else {
            holder.getForumImage().setVisibility(View.GONE);
        }

        if (forumComment.getCreated_at() != null) {
            holder.getTxtCommentDate().setText(Utils.timeUTC(forumComment.getCreated_at(), mLocale));
        }
        holder.getTxtCommentUserPosition().setText(forumComment.getUser_type());
        if (forumComment.getImage_path() != null) {
            Glide.with(mContext).load(forumComment.getImage_path())
                    .into(holder.getImgCommentUser());
        }

        List<Like> likes = forumComment.getLikes();
        if (likes != null) {
            int likeCount = 0;
            for (Like likeForCount : likes) {
                if (likeForCount.getLike_user_id() == mCurrentUserID) {
                    if (likeForCount.getLike_type() == 1) {
                        holder.getLikeBtn().setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_licke_coment_full));
                        holder.getLikeBtn().setTag(0);
                    } else {
                        holder.getLikeBtn().setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_like_coment_empty));
                        holder.getLikeBtn().setTag(1);
                    }
                } else {
                    holder.getLikeBtn().setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_like_coment_empty));
                    holder.getLikeBtn().setTag(1);
                }
                if (likeForCount.getLike_type() > 0) {
                    likeCount++;
                }
            }

            if (likeCount > 0) {
                holder.getCommentLikeOne().setVisibility(View.VISIBLE);
                holder.getCommentLikeOne().setText("" + likeCount);
                holder.getCommentLikeOne().setContentDescription(mContext.getString(R.string.like_icon_description) + likeCount);
            } else {
                holder.getCommentLikeOne().setVisibility(View.GONE);
            }
        } else {
            holder.getCommentLikeOne().setVisibility(View.GONE);
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
                holder.getTxtCommentUserPosition().setVisibility(View.VISIBLE);
                break;
            case 5:
                holder.getTxtCommentUserPosition().setVisibility(View.GONE);
                holder.getImgCommentUserBadge().setVisibility(View.GONE);
                break;
            default:
                holder.getImgCommentUserBadge().setVisibility(View.VISIBLE);
        }

        holder.getLikeBtn().setOnClickListener(v ->
                setLickClick(v, forumComment));

        holder.getLikeBtnOne().setOnClickListener(v -> {
            Comments comment = (Comments) holder.getPrvtMessageBtnOne().getTag();
            setLickClick(v, comment);
        });

        holder.getLikeBtnTwo().setOnClickListener(v -> {
            Comments comment = (Comments) holder.getPrvtMessageBtnTwo().getTag();
            setLickClick(v, comment);
        });

        holder.getTxtReply().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickReply(forumComment, null);
            }
        });

        holder.getPrvtMessageBtn().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickPrivateMessage(forumComment);
            }
        });

        holder.getPrvtMessageBtnOne().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickPrivateMessage(comment);
            }
        });

        holder.getPrvtMessageBtnTwo().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickPrivateMessage(comment);
            }
        });

        holder.getTxtReplyOne().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickReply(forumComment, comment);
            }
        });

        holder.getTxtReplyTwo().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                Comments comment = (Comments) v.getTag();
                mClickCommentListener.onClickReply(forumComment, comment);
            }
        });

        holder.getTxtViewMore().setOnClickListener(v -> {
            if (mClickMoreListener != null) {
                mClickMoreListener.onClickComment(forumComment);
            }
        });
        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
        int nightModeFlags =
                mContext.getResources().getConfiguration().uiMode &
                        Configuration.UI_MODE_NIGHT_MASK;
        if (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES) {
            if (forumComment.isMy()) {
                holder.changeMyStylesForDarkMode(mContext);
            } else {
                holder.changeStylesForDarkMode(mContext);
            }
        }

        holder.getMoreBtn().setOnClickListener((View.OnClickListener) v -> showPopup(v, forumComment));

        holder.getMoreBtnOne().setOnClickListener((View.OnClickListener) v -> {
            Comments comment = (Comments) holder.getContainerMessagesOne().getTag();
            showPopup(v, comment);
        });

        holder.getMoreBtnTwo().setOnClickListener((View.OnClickListener) v -> {
            Comments comment = (Comments) holder.getContainerMessagesTwo().getTag();
            showPopup(v, comment);
        });

        holder.addReply(mContext, mForumCommentReplies);
    }

    @Override
    public int getItemCount() {
        return mForumComments == null ? 0 : mForumComments.size();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void addMessages(List<Comments> forumComments) {
        Collections.reverse(forumComments);
        for (Comments comments : forumComments) {
            if (!comments.isHidden()) {
                mForumComments.add(comments);

            }
        }
        notifyDataSetChanged();
    }

    public void addMessage(Comments comment, RecyclerView recyclerView) {
        if (comment.isHidden()) {
            return;
        }
        if (isTypedFromUserSide) {
            isTypedFromUserSide = false;
            int itemCountAfterAdd = getItemCount();
            mForumComments.add(0, comment);
            LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
            if (layoutManager != null) {
                if (layoutManager.findLastVisibleItemPosition() == itemCountAfterAdd - 1) {
                    recyclerView.smoothScrollToPosition(0);
                } else {
                    recyclerView.scrollToPosition(0);
                }
            }
            notifyItemInserted(0);
        } else {
            if (comment.getReply_id() == 0) {
                int itemCountAfterAdd = getItemCount();
                mForumComments.add(0, comment);
                LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
                if (layoutManager != null) {
                    if (layoutManager.findLastVisibleItemPosition() == itemCountAfterAdd - 1) {
                        recyclerView.smoothScrollToPosition(0);
                    }
                }
                notifyItemInserted(0);
                if (mClickCommentListener != null) {
                    mClickCommentListener.onNewComment(0);
                }
            } else {
                for (Comments c : mForumComments) {
                    if (c.getId() == comment.getReply_id()) {
                        if (c.getMessageReplies() == null) {
                            c.setMessageReplies(new ArrayList<>());
                        }
                        c.getMessageReplies().add(comment);
                    }
                }
                notifyDataSetChanged();
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    public void editComment(Comments comment) {
        int index = mForumComments.indexOf(comment);
        if (index >= 0) {
            mForumComments.set(index, comment);
            notifyItemChanged(index);
        } else {
            for (Comments mainComment : mForumComments) {
                List<Comments> replayedComments = mainComment.getMessageReplies();
                if (replayedComments != null) {
                    int replayIndex = replayedComments.indexOf(comment);
                    if (replayIndex >= 0) {
                        replayedComments.set(replayIndex, comment);
                        notifyDataSetChanged();
                    }
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    public void deleteComment(long messageId) {
        Comments comment = new Comments();
        comment.setId(messageId);
        int index = mForumComments.indexOf(comment);
        if (index >= 0) {
            mForumComments.remove(index);
            notifyItemRemoved(index);
            notifyItemRangeChanged(index, mForumComments.size());
        } else {
            for (Comments mainComment : mForumComments) {
                List<Comments> replayedComments = mainComment.getMessageReplies();
                if (replayedComments != null) {
                    int replayIndex = replayedComments.indexOf(comment);
                    if (replayIndex >= 0) {
                        replayedComments.remove(replayIndex);
                        notifyDataSetChanged();
                    }
                }
            }
        }
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

    private void setLickClick(View view, Comments forumComment) {
        ImageView imageButton = (ImageView) view;
        if (view.getTag() != null && view.getTag()
                instanceof Integer && (Integer) view.getTag() == 0) {
            imageButton.setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_like_coment_empty));
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickLike(forumComment, 0);
            }
            view.setTag(1);
        } else {
            imageButton.setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_licke_coment_full));
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickLike(forumComment, 1);
            }
            view.setTag(0);
        }
    }

    private void showPopup(View v, Comments comment) {
        PopupMenu popup = new PopupMenu(mContext, v);
        popup.setOnMenuItemClickListener(item -> {
            switch (item.getItemId()) {
                case R.id.menuReport:
                    Bundle bundle = new Bundle();
                    bundle.putParcelable("comment", comment);
                    Intent intent = new Intent(mContext, ReportActivity.class);
                    intent.putExtras(bundle);
                    mContext.startActivity(intent);
                    return true;
                case R.id.menuEdit:
                    if (mClickMoreListener != null)
                        mClickMoreListener.onEditComment(comment);
                    return true;
                case R.id.menuDelete:
                    if (mClickMoreListener != null)
                        mClickMoreListener.onDeleteComment(comment);
                    return true;
                case R.id.menuCopy:
                    ClipboardManager clipboard = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
                    ClipData clip = ClipData.newPlainText(comment.getName(), comment.getMessage());
                    clipboard.setPrimaryClip(clip);
                    Toast.makeText(mContext, "Copied", Toast.LENGTH_SHORT).show();
                    return true;
                case R.id.menuBlockUser:
                    mClickCommentListener.onClickBlockUser(comment);
                    return true;
                default:
                    return false;
            }
        });
        popup.inflate(R.menu.menu_comment_action);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            popup.setForceShowIcon(true);
        } else {
            try {
                Field fMenuHelper = PopupMenu.class.getDeclaredField("mPopup");
                fMenuHelper.setAccessible(true);
                Object menuHelper = fMenuHelper.get(popup);
                Class[] argTypes = new Class[]{boolean.class};
                if (menuHelper != null) {
                    menuHelper.getClass()
                            .getDeclaredMethod("setForceShowIcon", argTypes)
                            .invoke(menuHelper, true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (comment.getUser_id() != mCurrentUserID) {
            popup.getMenu().getItem(1).setVisible(false);
            popup.getMenu().getItem(2).setVisible(false);
        } else {
            popup.getMenu().getItem(0).setVisible(false);
            popup.getMenu().getItem(4).setVisible(false);

        }
        popup.getMenu().getItem(0).setTitle(mContext.getString(R.string.report));
        popup.getMenu().getItem(1).setTitle(mContext.getString(R.string.edit_key));
        popup.getMenu().getItem(2).setTitle(mContext.getString(R.string.delete_key));
        popup.getMenu().getItem(3).setTitle(mContext.getString(R.string.copy));
        popup.getMenu().getItem(4).setTitle(mContext.getString(R.string.block_user));
        popup.show();
    }

    public void removeBlockedUser(long userId) {
        Iterator<Comments> commentsIterator = mForumComments.iterator();
        while (commentsIterator.hasNext()) {
            Comments comment = commentsIterator.next();
            if (comment.getUser_id() == userId) {
                commentsIterator.remove();
            }
            if (comment.getMessageReplies() != null) {
                Iterator<Comments> commentsReplyIterator = comment.getMessageReplies().iterator();
                while (commentsReplyIterator.hasNext()) {
                    if (commentsReplyIterator.next().getUser_id() == userId) {
                        commentsReplyIterator.remove();
                    }
                }
            }
        }
        notifyDataSetChanged();
    }

    public interface ClickCommentListener {
        void onClickComment(Comments comment);

        void onDeleteComment(Comments comment);

        void onEditComment(Comments comment);
    }

    public interface ClickReplyListener {
        void onClickReply(Comments comment, Comments replyComment);

        void onClickPrivateMessage(Comments comments);

        void onClickBlockUser(Comments comments);

        void onClickLike(Comments comments, int likeType);

        void onNewComment(int count);
    }
}
