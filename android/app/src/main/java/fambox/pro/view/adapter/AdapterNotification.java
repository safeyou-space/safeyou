package fambox.pro.view.adapter;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.fonts.FontStyle;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.network.model.chat.BaseNotificationResponse;
import fambox.pro.network.model.chat.NotificationData;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.NotificationHolder;

import static fambox.pro.Constants.BASE_URL;

public class AdapterNotification extends RecyclerView.Adapter<NotificationHolder> {

    private Context mContext;
    private List<BaseNotificationResponse> mNotificationResponses;
    private String mLocale;
    private View.OnClickListener mOnClickNotification;

    public AdapterNotification(Context mContext, List<BaseNotificationResponse> notificationResponses) {
        this.mContext = mContext;
        this.mNotificationResponses = notificationResponses;
        this.mLocale = mContext.getResources().getConfiguration().locale.getLanguage();
    }

    @NonNull
    @Override
    public NotificationHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_notification, parent, false);
        return new NotificationHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull NotificationHolder holder, int position) {
        NotificationData notificationData = mNotificationResponses.get(position).getData();
        Glide.with(mContext).load(BASE_URL.concat(notificationData.getImage_path() == null
                ? "" : notificationData.getImage_path()))
                .placeholder(R.drawable.avatar)
                .error(R.drawable.avatar)
                .into(holder.getNotificationUserImage());

        Spannable word = new SpannableString(notificationData.getName()
                + mContext.getResources().getString(R.string.replied_to_your_comment));
        word.setSpan( new StyleSpan(Typeface.BOLD),0, notificationData.getName().length(),
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        holder.getNotificationUserName().setText(word);
        holder.getNotificationRepliedTime().setText(Utils.timeUTC(notificationData.getCreated_at(), mLocale));
        if (Objects.equals(notificationData.getIsReaded(), "0")) {
            holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.statusBarColorPurpleLight));
        } else {
            holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.white));
        }

        holder.itemView.setOnClickListener(v -> {
            if (mOnClickNotification != null) {
                holder.itemView.setTag(notificationData);
                mOnClickNotification.onClick(holder.itemView);
                holder.itemView.setBackgroundColor(mContext.getResources().getColor(R.color.white));
            }
        });
    }

    @Override
    public int getItemCount() {
        return mNotificationResponses == null ? 0 : mNotificationResponses.size();
    }

    public void setOnClickNotification(View.OnClickListener onClickNotification) {
        this.mOnClickNotification = onClickNotification;
    }
}
