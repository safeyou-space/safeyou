package fambox.pro.presenter;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import fambox.pro.SafeYouApp;
import fambox.pro.network.SocketHandler;
import fambox.pro.network.model.chat.BaseNotificationResponse;
import fambox.pro.network.model.chat.NotificationData;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.NotificationContract;
import io.socket.emitter.Emitter;

public class NotificationPresenter extends BasePresenter<NotificationContract.View>
        implements NotificationContract.Presenter {
    private SocketHandler mSocketHandler;
    private Set<BaseNotificationResponse> mNotificationResponseTemp = new HashSet<>();
    private Emitter.Listener onNotification = args -> {
        if (args[0] instanceof JSONObject) {
            String json = args[0].toString();
            BaseNotificationResponse baseNotificationResponse = new Gson().fromJson(json, BaseNotificationResponse.class);
            if (mNotificationResponseTemp.contains(baseNotificationResponse)) {
                if (mNotificationResponseTemp.remove(baseNotificationResponse)) {
                    mNotificationResponseTemp.add(baseNotificationResponse);
                }
            }
            mNotificationResponseTemp.add(baseNotificationResponse);
            new Handler(Looper.getMainLooper()).post(() -> {
                try {
                    getView().initRecView(new ArrayList<>(mNotificationResponseTemp));
                } catch (Exception ignore) {

                }
            });
        }
        new Handler(Looper.getMainLooper()).post(() -> {
            try {
                if (getView() != null) {
                    getView().setProgressVisibility(View.GONE);
                }
            } catch (Exception ignore) {

            }
        });
    };

    @Override
    public void viewIsReady() {
        SafeYouApp application = ((SafeYouApp) getView().getApplication());
        mSocketHandler = application.getSocket();
        getNotifications();
        new Handler(Looper.getMainLooper()).postDelayed(() -> {
            if (getView() != null) {
                getView().setProgressVisibility(View.GONE);
            }
        }, 5000);
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mSocketHandler != null) {
            mSocketHandler.off("SafeYOU_V4##NOTIFICATION#RESULT", onNotification);
        }
    }

    @Override
    public void onClickReply(NotificationData notificationData) {
        try {
            JSONObject keyObject = new JSONObject();
            keyObject.put("key", notificationData.getKey());
            mSocketHandler.emit("SafeYOU_V4##READ_NOTIFICATION", keyObject);
            Bundle bundle = new Bundle();
            bundle.putLong("comment_id", Long.parseLong(notificationData.getForum_id()));
            bundle.putLong("reply_id", Long.parseLong(notificationData.getReply_id()));
            getView().startForumActivity(bundle);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void getNotifications() {
        if (getView() != null) {
            getView().setProgressVisibility(View.VISIBLE);
        }
        mSocketHandler.on("SafeYOU_V4##NOTIFICATION#RESULT", onNotification);
        mSocketHandler.emit("SafeYOU_V4##NOTIFICATION");
    }
}
