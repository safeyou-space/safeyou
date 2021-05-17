package fambox.pro.view.fragment;

import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface FragmentMoreCommentContract {

    interface View extends MvpView {
        void setUpParentMessage(String userImage, String userName,
                                String userProfession, String userComment, String data,
                                int userType, boolean isMy);

        void setupRecViewReply(List<Comments> replies);

        void onClickParentMessage(Comments comment);

        void onReplyChildMessage(Comments childComment);

        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<FragmentMoreCommentContract.View> {
        void initBundle(Bundle bundle);

        void setupReplyList(List<Comments> replies);

        void clickParentMessageReply();
    }

    interface Model extends BaseModel {

    }
}
