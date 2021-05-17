package fambox.pro;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;
import java.util.Objects;

import fambox.pro.model.EditProfileModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.SocketHandler;
import fambox.pro.network.model.Message;
import fambox.pro.utils.SharedPreferenceUtils;
import fambox.pro.view.ForumCommentActivity;
import fambox.pro.view.MainActivity;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;

public class FCM extends FirebaseMessagingService {
    public static final String MAIN_MESSAGE_CHANNEL_ID = "com.supportop.notification.OTHER_CHANNEL_ID";
    public static final String MAIN_MESSAGE = "Main Message";
    public static final int MESSAGE_NOTIFICATION_ID = 0x227EE;
    private static final String[] NOTIFICATION_TYPES = {"message", "forum"};
    private EditProfileModel mEditProfileModel;
    private NotificationManager mManager;
    private SocketHandler mSocketHandler;
    private boolean mDefaultAppState;
    private boolean mIsArtGalleryEnabled;
    private boolean mIsGalleryEditEnabled;
    private boolean mIsPhotoEditorEnabled;

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChanel();
        mEditProfileModel = new EditProfileModel();
        SafeYouApp application = ((SafeYouApp) getApplication());
        String username = SafeYouApp.getPreference().getStringValue(KEY_USER_PHONE, "");
        String password = SafeYouApp.getPreference().getStringValue(KEY_PASSWORD, "");
        if (!(Objects.equals(username, "") && Objects.equals(password, ""))) {
            mSocketHandler = application.getSocket();
        }

        SharedPreferenceUtils preferenceUtils = SafeYouApp.getPreference(this);
        mDefaultAppState = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_CAMOUFLAGE_ICON_ENABLED, false);
        mIsArtGalleryEnabled = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_ART_GALLERY_ENABLED, false);
        mIsGalleryEditEnabled = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_GALLERY_EDIT_ENABLED, false);
        mIsPhotoEditorEnabled = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_PHOTO_EDITOR_ENABLED, false);

    }

    @Override
    public void onNewToken(@NonNull String s) {
        super.onNewToken(s);
        String username = SafeYouApp.getPreference().getStringValue(KEY_USER_PHONE, "");
        String password = SafeYouApp.getPreference().getStringValue(KEY_PASSWORD, "");
        if (!(Objects.equals(username, "") && Objects.equals(password, ""))) {
            mEditProfileModel.editProfile(this, SafeYouApp.getCountryCode(), SafeYouApp.getLocale(),
                    "device_token", s, new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {

                        }

                        @Override
                        public void onError(Throwable error) {

                        }
                    });
        }
    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        boolean isNotificationEnabled = SafeYouApp.getPreference(this)
                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, false);

        if (isNotificationEnabled) {
            try {
                if (remoteMessage != null && remoteMessage.getData() != null) {
                    Log.i("tagFCM", "SocketHandler: " + remoteMessage.getData());
                    Map<String, String> data = remoteMessage.getData();
                    String notificationType = data.get("notification_type");
                    String appLanguage = SafeYouApp.getLocale();
                    String notificationTitle = data.get("title_en");
                    String notificationBody = data.get("text_en");
                    switch (appLanguage) {
                        case "en":
                            notificationTitle = data.get("title_en");
                            notificationBody = data.get("text_en");
                            break;
                        case "hy":
                            notificationTitle = data.get("title_arm");
                            notificationBody = data.get("text_arm");
                            break;
                        case "ka":
                            notificationTitle = data.get("title_geo");
                            notificationBody = data.get("text_geo");
                            break;
                    }

                    Intent intent = new Intent(this, MainActivity.class);
                    Bundle bundle = new Bundle();
                    bundle.putBoolean("is_opened_from_notification", true);

                    if (NOTIFICATION_TYPES[0].equals(notificationType)) {
                        try {
                            JSONObject keyObject = new JSONObject();
                            keyObject.put("key", data.get("key"));
                            if (mSocketHandler != null) {
                                new Handler(Looper.getMainLooper()).post(() ->
                                        mSocketHandler.emit("SafeYOU_V4##READ_NOTIFICATION", keyObject));
                            }
                            intent = new Intent(this, ForumCommentActivity.class);
                            bundle.putLong("comment_id", Long.parseLong(data.get("forum_id")));
                            bundle.putLong("reply_id", Long.parseLong(data.get("reply_id")));
                            intent.putExtras(bundle);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    } else if (NOTIFICATION_TYPES[1].equals(notificationType)) {
                        intent = new Intent(this, MainActivity.class);
                        bundle.putBoolean("is_forum_notification", true);
                        intent.putExtras(bundle);
                    } else {
                        intent = new Intent(this, MainActivity.class);
                    }

                    Notification notification = createNotification(notificationTitle, notificationBody, intent);
                    getManager().notify(MESSAGE_NOTIFICATION_ID, notification);
                }
            } catch (Exception e) {
                Notification notification = createNotification("New message",
                        "Content hidden", new Intent(this, MainActivity.class));
                getManager().notify(MESSAGE_NOTIFICATION_ID, notification);
            }
        }
    }

    private void createNotificationChanel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel mainMessage = new NotificationChannel(MAIN_MESSAGE_CHANNEL_ID,
                    MAIN_MESSAGE, NotificationManager.IMPORTANCE_HIGH);

            mainMessage.enableVibration(false);
            // Sets whether notifications posted to this channel appear on the lock screen or not
            mainMessage.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);

            mainMessage.setShowBadge(false);

            getManager().createNotificationChannel(mainMessage);
        }
    }

    public Notification createNotification(String title, String body, Intent intent) {
        int requestID = (int) System.currentTimeMillis();

        PendingIntent mMessagePendingIntent = PendingIntent.getActivity(this, requestID,
                intent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.Builder mMessageBuilder = new NotificationCompat.Builder(getApplicationContext(), MAIN_MESSAGE_CHANNEL_ID)
                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentTitle(title)
                .setContentText(body)
                .setContentIntent(mMessagePendingIntent)
                .setColor(getResources().getColor(R.color.colorAccent))
                .setOnlyAlertOnce(true)
                .setAutoCancel(true);
        if (!mDefaultAppState) {
            mMessageBuilder.setSmallIcon(R.mipmap.ic_launcher);
        } else {
            if (mIsArtGalleryEnabled) {
                mMessageBuilder.setSmallIcon(R.drawable.art_gallery_icon);
            } else if (mIsGalleryEditEnabled) {
                mMessageBuilder.setSmallIcon(R.drawable.galler_editor_icon);
            } else if (mIsPhotoEditorEnabled) {
                mMessageBuilder.setSmallIcon(R.drawable.photo_editor_icon);
            } else {
                mMessageBuilder.setSmallIcon(R.mipmap.ic_launcher);
            }
        }
        return mMessageBuilder.build();
    }

    public NotificationManager getManager() {
        if (mManager == null) {
            mManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return mManager;
    }
}
