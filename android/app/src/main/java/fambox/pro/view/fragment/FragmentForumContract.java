package fambox.pro.view.fragment;

import android.app.Application;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.model.chat.ForumData;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface FragmentForumContract {

    interface View extends MvpView {
        Application getApplication();

        void initForumRecyclerView(List<ForumData> forumDataList);

        void showServerError(int visibility, String message);

        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<FragmentForumContract.View> {

        void onPause();

        void setUpForums(String languageCode);
    }

    interface Model extends BaseModel {

    }
}
