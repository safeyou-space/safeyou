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
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupMenu;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.privatechat.network.model.Like;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.Utils;
import fambox.pro.view.ReportActivity;
import fambox.pro.view.adapter.holder.CommentViewMoreHolder;
import fambox.pro.view.fragment.FragmentMoreComment;

public class AdapterForumCommentViewMore extends RecyclerView.Adapter<CommentViewMoreHolder> {

    private final Context mContext;
    private final String mLocale;
    private final long mCurrentUserID;
    private List<Comments> mForumCommentReplies = new ArrayList<>();
    private ClickCommentListener mClickCommentListener;


    public AdapterForumCommentViewMore(Context context) {
        this.mContext = context;
        this.mLocale = LocaleHelper.getLanguage(mContext);
        this.mCurrentUserID = SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0);
    }

    @NonNull
    @Override
    public CommentViewMoreHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_comment_view_more, parent, false);
        return new CommentViewMoreHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull CommentViewMoreHolder holder, @SuppressLint("RecyclerView") int position) {
        Comments forumComment = mForumCommentReplies.get(position);
        holder.getContainerMessages().setBackground(forumComment.isMy() ? ContextCompat.getDrawable(mContext, R.drawable.comment_frame)
                : ContextCompat.getDrawable(mContext, R.drawable.comment_frame_white));
        holder.getTxtCommentUserName().setText(forumComment.getName());
        holder.getTxtCommentUserComment().setText(forumComment.getMessage());
        holder.getPrvtMessageBtn().setVisibility(forumComment.getUser_id() == mCurrentUserID
                || forumComment.getUser_type_id() == 5 || (SafeYouApp.isMinorUser() && forumComment.getUser_id() != 10 && forumComment.getUser_id() != 8) ? View.GONE : View.VISIBLE);
        if (forumComment.getCreated_at() != null) {
            holder.getTxtCommentDate().setText(Utils.timeUTC(forumComment.getCreated_at(), mLocale));
        }
        if (forumComment.getContentImage() != null && !forumComment.getContentImage().equals("")) {
            holder.getForumImage().setVisibility(View.VISIBLE);
            Glide.with(mContext).load(forumComment.getContentImage()).into(holder.getForumImage());
        } else {
            holder.getForumImage().setVisibility(View.GONE);
        }
        holder.getTxtCommentUserPosition().setText(forumComment.getUser_type());
        if (forumComment.getReplayedTo() != null) {
            holder.getTxtReplyTo().setVisibility(View.VISIBLE);
            holder.getTxtReplyTo().setText(forumComment.getReplayedTo());
        } else {
            holder.getTxtReplyTo().setVisibility(View.GONE);
        }
        if (forumComment.getImage_path() != null) {
            Glide.with(mContext).load(forumComment.getImage_path())
                    .into(holder.getImgCommentUser());
        }

        List<Like> likes = forumComment.getLikes();
        if (likes != null) {
            int likeCount = 0;
            for (Like likeForCount : likes) {
                if (likeForCount.getLike_user_id() == SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0)) {
                    if (likeForCount.getLike_type() == 1) {
                        holder.getLikeBtn().setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_licke_coment_full));
                        holder.getLikeBtn().setTag(0);
                    } else {
                        holder.getLikeBtn().setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_like_coment_empty));
                        holder.getLikeBtn().setTag(1);
                    }
                }
                if (likeForCount.getLike_type() > 0) {
                    likeCount++;
                }
            }

            if (likeCount > 0) {
                holder.getCommentLike().setVisibility(View.VISIBLE);
                holder.getCommentLike().setText("" + likeCount);
                holder.getCommentLike().setContentDescription(mContext.getString(R.string.like_icon_description) + likeCount);

            } else {
                holder.getCommentLike().setVisibility(View.GONE);
            }
        } else {
            holder.getCommentLike().setVisibility(View.GONE);
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

        holder.getMoreBtn().setOnClickListener(v -> showPopup(v, forumComment));

        holder.getLikeBtn().setOnClickListener(view -> {
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
        });

        holder.getTxtReply().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickComment(forumComment);
            }
        });

        holder.getPrvtMessageBtn().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickPrivateMessage(forumComment);
            }
        });
        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
        int nightModeFlags =
                mContext.getResources().getConfiguration().uiMode &
                        Configuration.UI_MODE_NIGHT_MASK;
        if (forumComment.isMy() && (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES)) {
            holder.changeStylesForDarkMode(mContext);
        }

    }

    @Override
    public int getItemCount() {
        return mForumCommentReplies == null ? 0 : mForumCommentReplies.size();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void addReplays(List<Comments> comments) {
        mForumCommentReplies.clear();
        if (comments != null) {
            for (Comments comment : comments) {
                if (!comment.isHidden()) {
                    mForumCommentReplies.add(comment);
                }
            }
            notifyDataSetChanged();
        }
    }

    private void deleteMessage(long messageId) {
        Comments comment = new Comments();
        comment.setId(messageId);
        int index = mForumCommentReplies.indexOf(comment);
        if (index >= 0) {
            mForumCommentReplies.remove(index);
            notifyItemRemoved(index);
            notifyItemRangeChanged(index, mForumCommentReplies.size());
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
                    if (mClickCommentListener != null && Connectivity.isConnected(mContext)) {
                        mClickCommentListener.onEditComment(comment, comment1 -> {
                            int index = mForumCommentReplies.indexOf(comment1);
                            if (index >= 0) {
                                mForumCommentReplies.set(index, comment1);
                                notifyItemChanged(index);
                            }
                        });
                    }
                    return true;
                case R.id.menuDelete:
                    if (mClickCommentListener != null && Connectivity.isConnected(mContext)) {
                        deleteMessage(comment.getId());
                        mClickCommentListener.onDeleteComment(comment);
                    }
                    return true;
                case R.id.menuCopy:
                    ClipboardManager clipboard = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
                    ClipData clip = ClipData.newPlainText(comment.getName(), comment.getMessage());
                    clipboard.setPrimaryClip(clip);
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
        popup.show();
    }

    public void addMessage(Comments comment, RecyclerView recyclerView, NestedScrollView nestedScrollView) {
        if (mForumCommentReplies == null) {
            mForumCommentReplies = new ArrayList<>();
        }
        if (!comment.isHidden()) {
            mForumCommentReplies.add(comment);
        }

        notifyItemInserted(getItemCount() - 1);
        recyclerView.smoothScrollToPosition(getItemCount() - 1);
        new Handler().postDelayed(() -> nestedScrollView.fullScroll(View.FOCUS_DOWN), 500);
    }

    public void setClickCommentListener(ClickCommentListener clickCommentListener) {
        this.mClickCommentListener = clickCommentListener;
    }

    public interface ClickCommentListener {
        void onClickComment(Comments comment);

        void onClickPrivateMessage(Comments comments);

        void onClickBlockUser(Comments comments);

        void onClickLike(Comments comments, int likeType);

        void onDeleteComment(Comments comments);

        void onEditComment(Comments comment, FragmentMoreComment.CommentUpdateListener commentUpdateListener);
    }
}
