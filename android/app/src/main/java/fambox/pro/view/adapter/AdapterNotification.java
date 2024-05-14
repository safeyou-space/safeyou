package fambox.pro.view.adapter;


import android.content.Context;
import android.graphics.Typeface;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.StyleSpan;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.privatechat.network.model.Notification;
import fambox.pro.privatechat.network.model.User;
import fambox.pro.utils.TimeUtil;
import fambox.pro.view.adapter.holder.NotificationHolder;

public class AdapterNotification extends RecyclerView.Adapter<NotificationHolder> {

    private final Context mContext;
    private final List<Notification> mNotificationResponses;
    private NotificationClickListener mOnClickNotification;

    public AdapterNotification(Context mContext, List<Notification> notificationResponses) {
        this.mContext = mContext;
        this.mNotificationResponses = notificationResponses;
    }

    @NonNull
    @Override
    public NotificationHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new NotificationHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_notification, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull NotificationHolder holder, int position) {
        Notification notificationData = mNotificationResponses.get(position);
        if (notificationData.getNotify_type() == 1) {

            Spannable word = new SpannableString(notificationData.getNotify_body().getTitle()
                    + " " + mContext.getString(R.string.forum_was_created));
            word.setSpan(new StyleSpan(Typeface.BOLD), 0, notificationData.getNotify_body().getTitle().length(),
                    Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
            holder.getNotificationRepliedTime().setText(TimeUtil.dateDifference(mContext, notificationData.getNotify_created_at()));

            holder.getNotificationUserName().setText(word);
            if (notificationData.getNotify_body().getImage() != null) {
                String imagePath = notificationData.getNotify_body().getImage().getUrl();
                Glide.with(mContext).load(Constants.BASE_URL + imagePath)
                        .placeholder(R.drawable.avatar)
                        .error(R.drawable.avatar)
                        .into(holder.getNotificationUserImage());
            } else {
                Glide.with(mContext).load(R.drawable.avatar)
                        .placeholder(R.drawable.avatar)
                        .error(R.drawable.avatar)
                        .into(holder.getNotificationUserImage());
            }
            if (notificationData.getNotify_read() == 0) {
                holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.chip_background_color));
            } else {
                holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.otherContainerElementsColor));
            }

        } else {
            User user = notificationData.getNotify_body().getMessage_send_by();
            if (user != null) {
                Glide.with(mContext).load(user.getUser_image())
                        .placeholder(R.drawable.avatar)
                        .error(R.drawable.avatar)
                        .into(holder.getNotificationUserImage());

                Spannable word = new SpannableString(user.getUser_username()
                        + " " + mContext.getString(R.string.replied_to_your_comment));
                word.setSpan(new StyleSpan(Typeface.BOLD), 0, user.getUser_username().length(),
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

                holder.getNotificationUserName().setText(word);
                holder.getNotificationRepliedTime().setText(TimeUtil.dateDifference(mContext, notificationData.getNotify_created_at()));
                if (notificationData.getNotify_read() == 0) {
                    holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.chip_background_color));
                } else {
                    holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.otherContainerElementsColor));
                }
            }
        }

        holder.itemView.setOnClickListener(v -> {
            if (mOnClickNotification != null) {
                mOnClickNotification.onClickNotification(notificationData);
                holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.otherContainerElementsColor));
            }
        });
    }

    @Override
    public int getItemCount() {
        return mNotificationResponses == null ? 0 : mNotificationResponses.size();
    }

    public void setOnClickNotification(NotificationClickListener onClickNotification) {
        this.mOnClickNotification = onClickNotification;
    }

    public interface NotificationClickListener {
        void onClickNotification(Notification notification);
    }
}
