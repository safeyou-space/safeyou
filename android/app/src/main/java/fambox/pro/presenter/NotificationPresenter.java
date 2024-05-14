package fambox.pro.presenter;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.HttpURLConnection;
import java.util.List;

import fambox.pro.Constants;
import fambox.pro.SafeYouApp;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.privatechat.network.model.BaseModel;
import fambox.pro.privatechat.network.model.ChatMessage;
import fambox.pro.privatechat.network.model.Notification;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.NotificationContract;
import io.socket.client.Socket;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class NotificationPresenter extends BasePresenter<NotificationContract.View>
        implements NotificationContract.Presenter {
    private Socket mSocket;

    @Override
    public void viewIsReady() {
        mSocket = ((SafeYouApp) getView().getApplication()).getChatSocket("").getSocket();
        getNotifications();
    }

    @Override
    public void onClickReply(Notification notificationData) {
        try {
            JSONObject keyObject = new JSONObject();
            keyObject.put("notify_id", notificationData.getNotify_id());
            if (mSocket != null) {
                mSocket.emit("signal", 18, keyObject);
                mSocket.emit("signal", 19, new JSONObject());
            }

            if (notificationData.getNotify_type() == 10) {
                return;
            }

            ChatMessage message = notificationData.getNotify_body();
            Bundle bundle = new Bundle();
            bundle.putLong("reply_id", notificationData.getNotify_id());
            bundle.putBoolean("is_opened_from_notification", true);
            bundle.putLong("message_parent_id", message.getMessage_parent_id());
            bundle.putString("room_key", message.getMessage_room_key());
            bundle.putLong("message_id", message.getMessage_id());
            bundle.putLong("forum_id", notificationData.getNotify_type() == 2 ? message.getMessage_forum_id() : message.getId());
            bundle.putLong("notification_type", notificationData.getNotify_type());
            getView().startForumActivity(bundle);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void getNotifications() {
        if (SafeYouApp.getChatApiService() != null) {
            getView().setProgressVisibility(View.VISIBLE);
            SafeYouApp.getChatApiService().getNotifications().enqueue(new Callback<BaseModel<List<Notification>>>() {
                @Override
                public void onResponse(@NonNull Call<BaseModel<List<Notification>>> call,
                                       @NonNull Response<BaseModel<List<Notification>>> response) {
                    if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                        if (response.body() != null) {
                            List<Notification> notificationResponses = response.body().getData();
                            if (notificationResponses != null) {
                                getView().initRecView(notificationResponses);
                            }
                        }
                    }
                    if (getView() != null) {
                        getView().setProgressVisibility(View.GONE);
                    }
                }

                @Override
                public void onFailure(@NonNull Call<BaseModel<List<Notification>>> call, @NonNull Throwable t) {
                    if (getView() != null) {
                        getView().setProgressVisibility(View.GONE);
                    }
                }
            });
        }
    }
}
