package fambox.pro.view;

import android.app.Application;
import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.model.chat.BaseNotificationResponse;
import fambox.pro.network.model.chat.NotificationData;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface NotificationContract {

    interface View extends MvpView {
        Application getApplication();

        void initRecView(List<BaseNotificationResponse> notificationResponses);

        void startForumActivity(Bundle bundle);

        void setProgressVisibility(int visibility);
    }

    interface Presenter extends MvpPresenter<NotificationContract.View> {
        void onClickReply(NotificationData notificationData);
    }

    interface Model extends BaseModel {

    }
}
