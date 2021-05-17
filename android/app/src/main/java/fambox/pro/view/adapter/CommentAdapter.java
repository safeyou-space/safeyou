package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.thoughtbot.expandablerecyclerview.ExpandableListUtils;
import com.thoughtbot.expandablerecyclerview.MultiTypeExpandableRecyclerViewAdapter;
import com.thoughtbot.expandablerecyclerview.models.ExpandableGroup;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.ForumCommentHolder;
import fambox.pro.view.adapter.holder.ReplyCommentHolder;
import fambox.pro.view.adapter.holder.model.CommentModel;

import static fambox.pro.Constants.BASE_URL;

public class CommentAdapter extends MultiTypeExpandableRecyclerViewAdapter<ForumCommentHolder, ReplyCommentHolder> {
    private static final int CURRENT_USER = 0;
    private static final int OTHER_USER = 1;
    private static final int CHILD_VIEW_CURRENT_USER = 2;
    private static final int CHILD_VIEW_OTHER_USER = 3;

    private Context mContext;
    private String mLocale;
    private ClickCommentListener mClickMoreListener;
    private ClickCommentListener mClickCommentListener;

    public CommentAdapter(Context mContext, String locale, List<? extends ExpandableGroup> replyComments) {
        super(replyComments);
        this.mContext = mContext;
        this.mLocale = locale;

        // Expand all groups
        for (ExpandableGroup expandableGroup : getGroups())
            if (!isGroupExpanded(expandableGroup))
                toggleGroup(expandableGroup);
    }

    @Override
    public void onAttachedToRecyclerView(@NotNull RecyclerView recyclerView) {
        super.onAttachedToRecyclerView(recyclerView);
        RecyclerView.LayoutManager manager = recyclerView.getLayoutManager();
        if (manager instanceof LinearLayoutManager && getItemCount() > 0) {
            LinearLayoutManager llm = (LinearLayoutManager) manager;
            recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
                @Override
                public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                    super.onScrollStateChanged(recyclerView, newState);
                }

                @Override
                public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                    super.onScrolled(recyclerView, dx, dy);
                    int visiblePosition = llm.findLastVisibleItemPosition();
                    if (visiblePosition > -1) {
                        View v = llm.findViewByPosition(visiblePosition);
                        //do something
//                        v.setBackgroundColor(Color.parseColor("#777777"));
                    }
                }
            });
        }
    }

    @Override
    public int getGroupViewType(int position, ExpandableGroup group) {
        Comments comment = ((CommentModel) group).getComment();
        if (comment == null) {
            return -1;
        }
        if (comment.isMy()) {
            return CURRENT_USER;
        } else {
            return OTHER_USER;
        }
    }

    @Override
    public boolean isGroup(int viewType) {
        return viewType == CURRENT_USER || viewType == OTHER_USER;
    }

    @Override
    public int getChildViewType(int position, ExpandableGroup group, int childIndex) {
        Comments comment = ((CommentModel) group).getItems().get(childIndex);
        if (comment.isMy()) {
            return CHILD_VIEW_CURRENT_USER;
        } else {
            return CHILD_VIEW_OTHER_USER;
        }
    }

    @Override
    public boolean isChild(int viewType) {
        return viewType == CHILD_VIEW_CURRENT_USER || viewType == CHILD_VIEW_OTHER_USER;
    }

    @Override
    public ForumCommentHolder onCreateGroupViewHolder(ViewGroup parent, int viewType) {
        int layout = R.layout.adapter_forum_comment;
        switch (viewType) {
            case CURRENT_USER:
                layout = R.layout.adapter_my_comment;
                break;
            case OTHER_USER:
                layout = R.layout.adapter_forum_comment;
                break;
        }
        View v = LayoutInflater
                .from(parent.getContext())
                .inflate(layout, parent, false);
        return new ForumCommentHolder(v);
    }

    @Override
    public ReplyCommentHolder onCreateChildViewHolder(ViewGroup parent, int viewType) {
        int layout = R.layout.adapter_reply_comment;
        switch (viewType) {
            case CHILD_VIEW_CURRENT_USER:
                layout = R.layout.adapter_reply_my_comment;
                break;
            case CHILD_VIEW_OTHER_USER:
                layout = R.layout.adapter_reply_comment;
                break;
        }
        View v = LayoutInflater
                .from(parent.getContext())
                .inflate(layout, parent, false);
        return new ReplyCommentHolder(v);
    }

    @Override
    public void onBindChildViewHolder(ReplyCommentHolder holder, int flatPosition, ExpandableGroup group, int childIndex) {
        Comments replyComment = ((CommentModel) group).getItems().get(childIndex);
        holder.getTxtCommentUserName().setText(replyComment.getName());
        holder.getTxtCommentUserComment().setText(replyComment.getMessage());
        holder.getTxtCommentDate().setText(Utils.timeUTC(replyComment.getCreated_at(), mLocale));
        holder.getTxtCommentUserPosition().setText(replyComment.getUser_type());
        if (replyComment.getImage_path() != null) {
            Glide.with(mContext).load(BASE_URL.concat(replyComment.getImage_path()))
                    .into(holder.getImgCommentUser());
        }

        holder.getTxtReply().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickComment(replyComment);
            }
        });

        holder.getTxtViewMore().setOnClickListener(v -> {
            if (mClickMoreListener != null) {
                mClickMoreListener.onClickComment(replyComment);
            }
        });
    }

    @Override
    public void onBindGroupViewHolder(ForumCommentHolder holder, int flatPosition, ExpandableGroup group) {
        if (((CommentModel) group).getComment() == null) {
            return;
        }
        Comments replyComment = ((CommentModel) group).getComment();
        holder.getTxtCommentUserName().setText(replyComment.getName());
        holder.getTxtCommentUserComment().setText(replyComment.getMessage());
        holder.getTxtCommentDate().setText(Utils.timeUTC(replyComment.getCreated_at(), mLocale));
        holder.getTxtCommentUserPosition().setText(replyComment.getUser_type());
        if (replyComment.getImage_path() != null) {
            Glide.with(mContext).load(BASE_URL.concat(replyComment.getImage_path()))
                    .into(holder.getImgCommentUser());
        }

        holder.getTxtReply().setOnClickListener(v -> {
            if (mClickCommentListener != null) {
                mClickCommentListener.onClickComment(replyComment);
            }
        });
    }

    public void addMessage(Comments comment, RecyclerView recyclerView) {
        List<CommentModel> commentModels = ((List<CommentModel>) getGroups());
        if (comment.getReply_id() > 0) {
            List<CommentModel> temp = new ArrayList<>(commentModels);
            for (int i = 0; i < temp.size(); i++) {
                Comments comments1 = temp.get(i).getComment();
                String repliedTo;
                List<Comments> replyCommentFilter = temp.get(i).getItems();
                if (comment.getReply_id() == comments1.getId()) {
                    replyCommentFilter.add(comment);
                    comments1.setReplied(true);
                    if (comment.isMy() && comments1.isMy()) {
                        repliedTo = mContext.getResources()
                                .getString(R.string.you_replaed_to_you);
                    } else if (comment.isMy()) {
                        repliedTo = mContext.getResources()
                                .getString(R.string.reply_to,
                                        mContext.getResources().getString(R.string.you), comments1.getName());
                    } else if (comments1.isMy()) {
                        repliedTo = mContext.getResources()
                                .getString(R.string.reply_to,
                                        comment.getName(), mContext.getResources().getString(R.string.you_end));
                    } else {
                        repliedTo = mContext.getResources()
                                .getString(R.string.reply_to, comment.getName(), comments1.getName());
                    }
                    commentModels.set(i, new CommentModel(repliedTo, replyCommentFilter, comments1));
                }
            }
        } else {
            commentModels.add(new CommentModel("", new ArrayList<>(), comment));
        }

        ExpandableListUtils.notifyGroupDataChanged(this);
        notifyDataSetChanged();
        LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
        if (layoutManager != null) {
            if (layoutManager.findFirstCompletelyVisibleItemPosition() < getItemCount() - 4) {
                recyclerView.smoothScrollToPosition(layoutManager.findFirstCompletelyVisibleItemPosition());
            } else {
                recyclerView.smoothScrollToPosition(getItemCount() - 1);
            }
        }

        // Expand all groups
        for (ExpandableGroup expandableGroup : getGroups())
            if (!isGroupExpanded(expandableGroup))
                toggleGroup(expandableGroup);
    }

    public void setClickMoreListener(ClickCommentListener mClickMoreListener) {
        this.mClickMoreListener = mClickMoreListener;
    }

    public void setClickCommentListener(ClickCommentListener clickCommentListener) {
        this.mClickCommentListener = clickCommentListener;
    }

    public interface CommentLongClickListener {
        void onLongClick(long commentId, String commentMassage, String fullName, String imagePath);
    }

    public interface ClickCommentListener {
        void onClickComment(Comments comment);
    }
}
