package fambox.pro.view.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.chat.PrivateMessageUserListResponse;
import fambox.pro.privatechat.network.model.User;
import fambox.pro.privatechat.view.ChatActivity;
import fambox.pro.utils.TimeUtil;
import fambox.pro.view.adapter.holder.PrivateMessageHolder;

public class AdapterPrivateMessage extends RecyclerView.Adapter<PrivateMessageHolder> {
    private final Context mContext;
    private final List<PrivateMessageUserListResponse> mPrivateMessageUserListResponses;

    public AdapterPrivateMessage(Context context, List<PrivateMessageUserListResponse> privateMessageUserListResponses) {
        this.mContext = context;
        this.mPrivateMessageUserListResponses = privateMessageUserListResponses;
    }

    @NonNull
    @Override
    public PrivateMessageHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new PrivateMessageHolder(LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_private_message_list, parent, false));
    }


    @Override
    public void onBindViewHolder(@NonNull PrivateMessageHolder holder, int position) {
        PrivateMessageUserListResponse response = mPrivateMessageUserListResponses.get(position);
        if (response != null) {
            Glide.with(mContext)
                    .load(response.getRoomImage())
                    .error(R.drawable.siruk)
                    .into(holder.getPrUserImage());
            holder.getPrUserName().setText(response.getRoomName());
            if (response.getRoom_members() != null) {
                for (User user : response.getRoom_members()) {
                    if (user.getUser_id() != SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0)) {
                        if (user.getUser_profession() != null) {
                            holder.getPrProfession().setText(user.getUser_profession().get(SafeYouApp.getLocale()));
                        }
                    }
                }
            }
            if (response.getUnreadMessageCount() > 0) {
                holder.getUnreadMessageCount().setText(String.valueOf(response.getUnreadMessageCount()));
                holder.getUnreadMessageCount().setVisibility(View.VISIBLE);
                Typeface typeface = ResourcesCompat.getFont(mContext, R.font.hay_roboto_bold);
                holder.getPrUserName().setTypeface(typeface);
            } else {
                holder.getUnreadMessageCount().setVisibility(View.GONE);
                Typeface typeface = ResourcesCompat.getFont(mContext, R.font.hay_roboto_regular);
                holder.getPrUserName().setTypeface(typeface);
            }
            holder.getPrLastCommunicationDate().setText(
                    TimeUtil.convertPrivatChatListDate(SafeYouApp.getLocale(), response.getRoomUpdatedAt()));

            holder.itemView.setOnClickListener(v -> {
                Bundle bundle = new Bundle();
                bundle.putString("room_key", response.getRoomKey());
                bundle.putString("room_id", response.getRoomId());
                bundle.putString("room_name", response.getRoomName());
                bundle.putString("room_image_path", response.getRoomImage());
                Intent intent = new Intent(mContext, ChatActivity.class);
                intent.putExtras(bundle);
                mContext.startActivity(intent);
            });
        }
    }

    @Override
    public int getItemCount() {
        return mPrivateMessageUserListResponses == null ? 0 : mPrivateMessageUserListResponses.size();
    }
}
