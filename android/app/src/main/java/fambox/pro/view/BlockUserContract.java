package fambox.pro.view;

import android.app.Application;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import fambox.pro.privatechat.network.model.BlockedUsers;

public interface BlockUserContract {

    interface View extends MvpView {
        Application getApplication();

        void initRecView(List<? extends BlockedUsers> notificationResponses);

        void deleteUnblockedUser(long userId);

        void setProgressVisibility(int visibility);
    }

    interface Presenter extends MvpPresenter<BlockUserContract.View> {
        void onDeleteBlockedUser(long userId);
    }

    interface Model extends BaseModel {

    }
}
