package fambox.pro.view.fragment;

import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import fambox.pro.privatechat.network.model.Like;

public interface FragmentMoreCommentContract {

    interface View extends MvpView {
        void setUpParentMessage(int userId, String userImage, String userName,
                                String userProfession, String userComment, String data,
                                int userType, boolean isMy, List<Like> likes, String image);

        void setupRecViewReply(List<Comments> replies);

        void onClickParentMessage(Comments comment);

        void onClickLike(Comments comment, int likeType);

        void onReplyChildMessage(Comments childComment);

        void clickMoreBtn(Comments comment, android.view.View view);

        void goPrivateMessage(Bundle bundle);

        void removeBlockedUser(Comments comments);

        void showProgress();

        void goBack();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<FragmentMoreCommentContract.View> {
        void initBundle(Bundle bundle);

        void clickPrivateMessage();

        void onClickBlockUser(Comments comments);

        void clickMoreBtn(android.view.View view);

        void onClickLike(int likeType);

        void setupReplyList(List<Comments> replies);

        void clickParentMessageReply();
    }

    interface Model extends BaseModel {

    }
}
