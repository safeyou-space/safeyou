package fambox.pro.view;

import android.app.Application;
import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface ForumCommentContract {

    interface View extends MvpView {
        Application getApplication();

        void setupForumDetail(boolean isOpenFromNotification);

        void initRecView(List<Comments> comments, List<Comments> replyComments, long replyIdFromNotification);

        void setData(String imagePath, String title, String shortDescription, String description, int commentCount);

        void setCommentCount(int commentCount);

        void addNewMessage(Comments comment);

        void goPinActivity(Bundle bundle);

        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<ForumCommentContract.View> {
        void initBundle(Bundle bundle, String languageCode);

        void setCommentMassage(String message, String locale);

        void onReply(Comments comment);

        void checkPin(Bundle bundle);
    }

    interface Model extends BaseModel {

    }
}
