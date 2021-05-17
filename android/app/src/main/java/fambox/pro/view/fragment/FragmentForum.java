package fambox.pro.view.fragment;

import android.app.Application;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.fragment.app.FragmentActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.chat.ForumData;
import fambox.pro.presenter.fragment.FragmentForumPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.ForumCommentActivity;
import fambox.pro.view.MainActivity;
import fambox.pro.view.adapter.ForumAdapter;

public class FragmentForum extends BaseFragment implements FragmentForumContract.View {

    private FragmentForumPresenter mFragmentForumPresenter;
    private FragmentActivity mContext;

    @BindView(R.id.recViewForum)
    RecyclerView recViewForum;
    @BindView(R.id.errorMessage)
    TextView errorMessage;
    @BindView(R.id.forumLoading)
    LinearLayout forumLoading;

    @Override
    protected View provideYourFragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getActivity() != null) {
            mContext = getActivity();
        }
        return inflater.inflate(R.layout.fragment_forum, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        mFragmentForumPresenter = new FragmentForumPresenter();
        mFragmentForumPresenter.attachView(this);
    }

    @Override
    public void initForumRecyclerView(List<ForumData> forumDataList) {
        ForumAdapter forumAdapter = new ForumAdapter(forumDataList, mContext);
        forumAdapter.setForumItemClick(forumData -> {
            Bundle bundle = new Bundle();
            bundle.putLong("comment_id", forumData.getId());
            nextActivity(getActivity(), ForumCommentActivity.class, bundle);
        });
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(getActivity(), RecyclerView.VERTICAL, false);
        recViewForum.setLayoutManager(verticalLayoutManager);
        recViewForum.setAdapter(forumAdapter);

        boolean isNotificationEnabled = SafeYouApp.getPreference(getApplication())
                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, false);
        if (isNotificationEnabled) {
            for (ForumData forumData : forumDataList) {
                if (forumData.getNEW_MESSAGES_COUNT() > 0) {
                    ((MainActivity) mContext).getBottomNotificationIcon().setVisibility(View.VISIBLE);
                    return;
                } else {
                    ((MainActivity) mContext).getBottomNotificationIcon().setVisibility(View.INVISIBLE);
                }
            }
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.viewIsReady();
            mFragmentForumPresenter.setUpForums(((BaseActivity) mContext).getLocale());
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.onPause();
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.detachView();
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.destroy();
        }
    }

    @Override
    public Application getApplication() {
        return mContext.getApplication();
    }

    @Override
    public void showServerError(int visibility, String message) {
        try {
            mContext.runOnUiThread(() -> {
                errorMessage.setVisibility(visibility);
                errorMessage.setText(message);
            });
        } catch (Exception ignore) {
        }
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    @Override
    public void showProgress() {
        forumLoading.setVisibility(View.VISIBLE);
    }

    @Override
    public void dismissProgress() {
        forumLoading.setVisibility(View.GONE);
    }
}
