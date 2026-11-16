package fambox.pro.presenter.fragment;

import android.os.Bundle;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import fambox.pro.model.ForumCommentModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.BlockUserPostBody;
import fambox.pro.network.model.chat.BlockUserResponse;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.fragment.FragmentMoreCommentContract;

public class FragmentMoreCommentPresenter extends BasePresenter<FragmentMoreCommentContract.View> implements
        FragmentMoreCommentContract.Presenter {

    private Comments mParentComment;
    private Comments mChildComment;
    private ForumCommentModel mForumCommentModel;

    @Override
    public void viewIsReady() {
        setupMainMessage();
        mForumCommentModel = new ForumCommentModel();
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
    }

    @Override
    public void setupReplyList(List<Comments> replies) {
        getView().setupRecViewReply(replies);
    }

    @Override
    public void clickPrivateMessage() {
        Bundle bundle = new Bundle();
        bundle.putBoolean("opened_from_network", true);
        bundle.putString("user_id", String.valueOf(mParentComment.getUser_id()));
        bundle.putString("user_name", mParentComment.getName());
        try {
            bundle.putString("user_image", new URL(mParentComment.getImage_path()).getPath());
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        bundle.putString("user_profession", mParentComment.getUser_type());
        getView().goPrivateMessage(bundle);
    }

    @Override
    public void onClickBlockUser(Comments comments) {
        BlockUserPostBody blockUserPostBody = new BlockUserPostBody();
        blockUserPostBody.setUserId(comments.getUser_id());

        mForumCommentModel.blockUser(getView().getContext(), blockUserPostBody, new NetworkCallback<BlockUserResponse>() {
            @Override
            public void onSuccess(BlockUserResponse response) {
                getView().removeBlockedUser(comments);
                if (mParentComment.getUser_id() == comments.getUser_id()) {
                    getView().goBack();
                }
            }

            @Override
            public void onError(Throwable error) {

            }
        });
    }

    @Override
    public void clickMoreBtn(android.view.View view) {
        getView().clickMoreBtn(mParentComment, view);
    }

    @Override
    public void onClickLike(int likeType) {
        getView().onClickLike(mParentComment, likeType);
    }

    @Override
    public void clickParentMessageReply() {
        getView().onClickParentMessage(mParentComment);
    }

    private void setupMainMessage() {
        if (mParentComment != null) {
            getView().setUpParentMessage((int) mParentComment.getUser_id(),
                    mParentComment.getImage_path(),
                    mParentComment.getName(),
                    mParentComment.getUser_type(),
                    mParentComment.getMessage(), mParentComment.getCreated_at(),
                    mParentComment.getUser_type_id(), mParentComment.isMy(),
                    mParentComment.getLikes(),
                    mParentComment.getContentImage());
        }
    }
}
