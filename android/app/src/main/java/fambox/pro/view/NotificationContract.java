package fambox.pro.view;

import android.app.Application;
import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import fambox.pro.privatechat.network.model.Notification;

public interface NotificationContract {

    interface View extends MvpView {
        Application getApplication();

        void initRecView(List<Notification> notificationResponses);

        void startForumActivity(Bundle bundle);

        void setProgressVisibility(int visibility);
    }

    interface Presenter extends MvpPresenter<NotificationContract.View> {
        void onClickReply(Notification notificationData);
    }

    interface Model extends BaseModel {

    }
}
