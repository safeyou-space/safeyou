package fambox.pro.presenter.fragment;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.fragment.FragmentMoreCommentContract;

public class FragmentMoreCommentPresenter extends BasePresenter<FragmentMoreCommentContract.View> implements
        FragmentMoreCommentContract.Presenter {

    private Comments mParentComment;
    private Comments mChildComment;

    @Override
    public void viewIsReady() {
        setupMainMessage();
        if (mChildComment != null) {
            getView().onReplyChildMessage(mChildComment);
        } else {
            if (mParentComment != null) {
                getView().onClickParentMessage(mParentComment);
            }
        }
    }

    @Override
    public void initBundle(Bundle bundle) {
        if (bundle != null) {
            mParentComment = bundle.getParcelable("parent_message");
            mChildComment = bundle.getParcelable("child_message");
        }

        if (mParentComment != null) {
            Log.i("tagik", "mParentComment: " + mParentComment);
        }
        if (mChildComment != null) {
            Log.i("tagik", "mChildComment: " + mChildComment);
        }
    }

    @Override
    public void setupReplyList(List<Comments> replies) {
        List<Comments> filteredReplies = new ArrayList<>();
        for (Comments comment : replies) {
            if (mParentComment.getGroup_id() == comment.getGroup_id()) {
                filteredReplies.add(comment);
            }
        }

        for (Comments comments : replies) {
            for (Comments reply : filteredReplies) {
                if (comments.getId() == reply.getReply_id()) {
                    String repliedTo = getView().getContext().getResources()
                            .getString(R.string.reply_to, comments.getName());
                    reply.setReplayedTo(repliedTo);
                }
            }
        }

        getView().setupRecViewReply(filteredReplies);
    }

    @Override
    public void clickParentMessageReply() {
        getView().onClickParentMessage(mParentComment);
    }

    private void setupMainMessage() {
        if (mParentComment != null) {
            getView().setUpParentMessage(mParentComment.getImage_path(),
                    mParentComment.getName(),
                    mParentComment.getUser_type(),
                    mParentComment.getMessage(), mParentComment.getCreated_at(),
                    mParentComment.getUser_type_id(), mParentComment.isMy());
        }
    }
}
