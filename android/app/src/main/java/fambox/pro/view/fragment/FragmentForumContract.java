package fambox.pro.view.fragment;

import android.app.Application;
import android.content.Context;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.forum.ForumBase;
import fambox.pro.network.model.forum.ForumFilter;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface FragmentForumContract {

    interface View extends MvpView {
        Application getApplication();

        void initForumRecyclerView(List<ForumResponseBody> forumDataList);

        void initForumFilterChipsRecyclerView(List<ForumFilter> filters);

        void addForums(List<ForumResponseBody> forums, boolean forumByFilterEnabled, boolean allChipsRemoved);

        void notifyDataChange(int forumId, int messagesCount);

        void showProgress();

        void dismissProgress();

    }

    interface Presenter extends MvpPresenter<FragmentForumContract.View> {

        void onPause();

        void getAllForumsByFilter(String languageFilter, String categoryFilter, String categorySort, boolean forumByFilterEnabled, boolean allChipsRemoved);

        void getAllForums(String languageFilter, String categoryFilter, String categorySort, boolean forumByFilterEnabled, boolean allChipsRemoved);

        void onNextPage(int page, int total);

        void setPage(int page);

        void setForumFilterResult(HashMap<String, String> mapCategory, HashMap<String, String> mapLanguage);

        void setForumSortCategory(Map<String, String> mapSortingCategory);
    }

    interface Model extends BaseModel {

        void getAllForums(Context context, String countryCode, String locale, int page,
                          String languageFilter, String categoryFilter, String categorySort,
                          NetworkCallback<Response<ForumBase>> response);

    }
}
