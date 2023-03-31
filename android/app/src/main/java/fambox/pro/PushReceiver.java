package fambox.pro;

import fambox.pro.utils.SharedPreferenceUtils;
import fambox.pro.view.ForumCommentActivity;
import fambox.pro.view.MainActivity;

import android.app.Notification;
import android.app.NotificationChannel;
import android.content.Intent;
import android.content.Context;
import android.app.PendingIntent;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import java.util.Objects;

public class PushReceiver extends BroadcastReceiver {
    private NotificationManager mManager;
    private static final String[] NOTIFICATION_TYPES = {"2", "1"};
    public static final int MESSAGE_NOTIFICATION_ID = 0x227EE;
    public static final String MAIN_MESSAGE_CHANNEL_ID = "com.supportop.notification.OTHER_CHANNEL_ID";
    public static final String MAIN_MESSAGE = "Main Message";

    @Override
    public void onReceive(Context context, Intent newIntent) {
        createNotificationChanel(context);
        System.out.println("intent = " + newIntent.getExtras());
        boolean isNotificationEnabled = SafeYouApp.getPreference(context)
                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, false);
        if (!isNotificationEnabled) {
            try {
                if (newIntent.getExtras() != null) {
                    Log.i("PushReceiver", "SocketHandler: " + newIntent.getExtras());
                    Bundle data = newIntent.getExtras();
                    String notificationType = data.getString("notify_type");
                    String notificationTitle = data.getString("notify_title");
                    String notificationBody = data.getString("notify_body");

                    Intent intent = new Intent(context, MainActivity.class);
                    Bundle bundle = new Bundle();
                    bundle.putBoolean("is_opened_from_notification", true);

                    if (NOTIFICATION_TYPES[0].equals(notificationType)) {
                        intent = new Intent(context, ForumCommentActivity.class);

                        bundle.putLong("reply_id", 0);
                        bundle.putLong("message_parent_id", Long.parseLong(Objects.requireNonNull(data.getString("message_parent_id"))));
                        bundle.putString("room_key", data.getString("message_room_key"));
                        bundle.putLong("message_id", Long.parseLong(Objects.requireNonNull(data.getString("message_id"))));
                        bundle.putLong("forum_id", Long.parseLong(Objects.requireNonNull(data.getString("message_forum_id"))));
                        intent.putExtras(bundle);

                    } else if (NOTIFICATION_TYPES[1].equals(notificationType)) {
                        intent = new Intent(context, MainActivity.class);
                        bundle.putBoolean("is_forum_notification", true);
                        intent.putExtras(bundle);
                    } else {
                        intent = new Intent(context, MainActivity.class);
                    }

                    Notification notification = createNotification(context, notificationTitle, notificationBody, intent);
                    getManager(context).notify(MESSAGE_NOTIFICATION_ID, notification);
                }
            } catch (Exception e) {
                Notification notification = createNotification(context, "New message",
                        "Content hidden", new Intent(context, MainActivity.class));
                getManager(context).notify(MESSAGE_NOTIFICATION_ID, notification);
            }
        }
    }

    public Notification createNotification(Context context, String title, String body, Intent intent) {
        SharedPreferenceUtils preferenceUtils = SafeYouApp.getPreference(context);
        boolean mDefaultAppState = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_CAMOUFLAGE_ICON_ENABLED, false);
        boolean mIsArtGalleryEnabled = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_ART_GALLERY_ENABLED, false);
        boolean mIsGalleryEditEnabled = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_GALLERY_EDIT_ENABLED, false);
        boolean mIsPhotoEditorEnabled = preferenceUtils.getBooleanValue(Constants.Key.KEY_IS_PHOTO_EDITOR_ENABLED, false);
        int requestID = (int) System.currentTimeMillis();

        PendingIntent mMessagePendingIntent = PendingIntent.getActivity(context, requestID,
                intent, PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.Builder mMessageBuilder = new NotificationCompat.Builder(context, MAIN_MESSAGE_CHANNEL_ID)
                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentTitle(title)
                .setContentText(body)
                .setContentIntent(mMessagePendingIntent)
                .setColor(context.getResources().getColor(R.color.colorAccent))
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

    public NotificationManager getManager(Context context) {
        if (mManager == null) {
            mManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return mManager;
    }


    private void createNotificationChanel(Context context) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel mainMessage = new NotificationChannel(MAIN_MESSAGE_CHANNEL_ID,
                    MAIN_MESSAGE, NotificationManager.IMPORTANCE_HIGH);

            mainMessage.enableVibration(false);
            // Sets whether notifications posted to this channel appear on the lock screen or not
            mainMessage.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);

            mainMessage.setShowBadge(false);

            getManager(context).createNotificationChannel(mainMessage);
        }
    }


}