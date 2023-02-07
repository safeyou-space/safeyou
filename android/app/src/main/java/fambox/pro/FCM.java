package fambox.pro;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;
import java.util.Objects;

import fambox.pro.model.EditProfileModel;
import fambox.pro.network.NetworkCallback;
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
    private static final String[] NOTIFICATION_TYPES = {"2", "1"};
    private EditProfileModel mEditProfileModel;
    private NotificationManager mManager;
    private boolean mDefaultAppState;
    private boolean mIsArtGalleryEnabled;
    private boolean mIsGalleryEditEnabled;
    private boolean mIsPhotoEditorEnabled;

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChanel();
        mEditProfileModel = new EditProfileModel();

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
            mEditProfileModel.editProfile(this, SafeYouApp.getCountryCode(), LocaleHelper.getLanguage(getBaseContext()),
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
                    String notificationType = data.get("notify_type");
                    String notificationTitle = data.get("notify_title");
                    String notificationBody = data.get("notify_body");

                    Intent intent = new Intent(this, MainActivity.class);
                    Bundle bundle = new Bundle();
                    bundle.putBoolean("is_opened_from_notification", true);

                    if (NOTIFICATION_TYPES[0].equals(notificationType)) {
                            intent = new Intent(this, ForumCommentActivity.class);

                            bundle.putLong("reply_id", 0);
                            bundle.putLong("message_parent_id", Long.parseLong(Objects.requireNonNull(data.get("message_parent_id"))));
                            bundle.putString("room_key", data.get("message_room_key"));
                            bundle.putLong("message_id", Long.parseLong(Objects.requireNonNull(data.get("message_id"))));
                            bundle.putLong("forum_id", Long.parseLong(Objects.requireNonNull(data.get("message_forum_id"))));
                            intent.putExtras(bundle);

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
