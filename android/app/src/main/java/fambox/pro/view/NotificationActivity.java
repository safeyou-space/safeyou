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
import fambox.pro.presenter.NotificationPresenter;
import fambox.pro.privatechat.network.model.Notification;
import fambox.pro.view.adapter.AdapterNotification;

public class NotificationActivity extends BaseActivity implements NotificationContract.View {

    private NotificationPresenter mNotificationPresenter;

    @BindView(R.id.recViewNotifications)
    RecyclerView recViewNotifications;
    @BindView(R.id.notificationProgress)
    LinearLayout notificationProgress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addAppBar(null, false, true, false,
                getResources().getString(R.string.notifications_title_key), false);
        ButterKnife.bind(this);
        mNotificationPresenter = new NotificationPresenter();
        mNotificationPresenter.attachView(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mNotificationPresenter != null)
            mNotificationPresenter.viewIsReady();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mNotificationPresenter != null) {
            mNotificationPresenter.destroy();
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_notification;
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void setProgressVisibility(int visibility) {
        notificationProgress.setVisibility(visibility);
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
        if (mNotificationPresenter != null) {
            mNotificationPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mNotificationPresenter != null) {
            mNotificationPresenter.destroy();
        }
    }

    @Override
    public void startForumActivity(Bundle bundle) {
        nextActivity(this, ForumCommentActivity.class, bundle);
    }

    @Override
    public void initRecView(List<Notification> notificationResponses) {
        AdapterNotification adapterNotification = new AdapterNotification(this, notificationResponses);
        adapterNotification.setOnClickNotification(notification -> {
            mNotificationPresenter.onClickReply(notification);
        });
        LinearLayoutManager horizontalLayoutManager =
                new LinearLayoutManager(getContext(), RecyclerView.VERTICAL, false);
        recViewNotifications.setLayoutManager(horizontalLayoutManager);
        recViewNotifications.setAdapter(adapterNotification);
    }
}
