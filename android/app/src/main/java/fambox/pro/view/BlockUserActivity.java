package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.widget.LinearLayout;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.presenter.BlockUserPresenter;
import fambox.pro.privatechat.network.model.BlockedUsers;
import fambox.pro.view.adapter.AdapterBlockedUsers;

public class BlockUserActivity extends BaseActivity implements BlockUserContract.View {

    private BlockUserPresenter blockUserPresenter;

    @BindView(R.id.recViewBlockedUsers)
    RecyclerView recViewBlockedUsers;
    @BindView(R.id.blockUserProgress)
    LinearLayout blockUserProgress;
    private AdapterBlockedUsers adapterBlockedUsers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addAppBar(null, false, true, false,
                getResources().getString(R.string.title_black_list), false);
        ButterKnife.bind(this);
        blockUserPresenter = new BlockUserPresenter();
        blockUserPresenter.attachView(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (blockUserPresenter != null)
            blockUserPresenter.viewIsReady();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (blockUserPresenter != null) {
            blockUserPresenter.destroy();
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_block_user;
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void setProgressVisibility(int visibility) {
        blockUserProgress.setVisibility(visibility);
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (blockUserPresenter != null) {
            blockUserPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (blockUserPresenter != null) {
            blockUserPresenter.destroy();
        }
    }

    @Override
    public void deleteUnblockedUser(long userId) {
        adapterBlockedUsers.removeItem(userId);
    }

    @Override
    public void initRecView(List<? extends BlockedUsers> blockedUsersResponse) {
        adapterBlockedUsers = new AdapterBlockedUsers(this, blockedUsersResponse);
        adapterBlockedUsers.setOnClickBlockedUser(user -> {
            blockUserPresenter.onDeleteBlockedUser(user);
        });
        LinearLayoutManager horizontalLayoutManager =
                new LinearLayoutManager(getContext(), RecyclerView.VERTICAL, false);
        recViewBlockedUsers.setLayoutManager(horizontalLayoutManager);
        recViewBlockedUsers.setAdapter(adapterBlockedUsers);
    }
}
