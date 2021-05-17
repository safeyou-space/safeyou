package fambox.pro.view.adapter.holder.model;

import android.content.Context;

import com.thoughtbot.expandablerecyclerview.models.ExpandableGroup;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;

public class CommentModel extends ExpandableGroup<Comments> {
    private Comments comment;

    public CommentModel(String title, List<Comments> replyComments, Comments comment) {
        super(title, replyComments);
        this.comment = comment;
    }

    public Comments getComment() {
        return comment;
    }

    public static List<CommentModel> commentModels(Context context, List<Comments> comments,
                                                   List<Comments> replyComments) {
        List<CommentModel> commentModels = new ArrayList<>();
        for (Comments comment : comments) {
            String repliedTo = "";
            List<Comments> replyCommentFilter = new ArrayList<>();
            for (Comments replyComment : replyComments) {
                if (replyComment.getReply_id() == comment.getId()) {
                    replyCommentFilter.add(replyComment);
                    comment.setReplied(true);
                    if (replyComment.isMy() && comment.isMy()) {
                        repliedTo = context.getResources()
                                .getString(R.string.you_replaed_to_you);
                    } else if (replyComment.isMy()) {
                        repliedTo = context.getResources()
                                .getString(R.string.reply_to,
                                        context.getResources().getString(R.string.you), comment.getName());
                    } else if (comment.isMy()) {
                        repliedTo = context.getResources()
                                .getString(R.string.reply_to,
                                        replyComment.getName(), context.getResources().getString(R.string.you_end));
                    } else {
                        repliedTo = context.getResources()
                                .getString(R.string.reply_to, replyComment.getName(), comment.getName());
                    }
                }
            }
            commentModels.add(new CommentModel(repliedTo, replyCommentFilter, comment));
        }
        return commentModels;
    }
}