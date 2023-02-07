package fambox.pro.view.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.R;
import fambox.pro.privatechat.network.model.BlockedUsers;
import fambox.pro.privatechat.network.model.User;
import fambox.pro.view.adapter.holder.BlockedUsersHolder;

public class AdapterBlockedUsers extends RecyclerView.Adapter<BlockedUsersHolder> {

    private final Context mContext;
    private final List<? extends BlockedUsers> mBlockedUsersResponses;
    private DeleteBlockedUserListener mOnClickBlockedUser;

    public AdapterBlockedUsers(Context mContext, List<? extends BlockedUsers> blockedUsersResponses) {
        this.mContext = mContext;
        this.mBlockedUsersResponses = blockedUsersResponses;
    }

    @NonNull
    @Override
    public BlockedUsersHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_blocked_users, parent, false);
        return new BlockedUsersHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull BlockedUsersHolder holder, int position) {
        BlockedUsers blockedUsersData = mBlockedUsersResponses.get(position);
        User user = blockedUsersData.getUser();
        if (user != null) {
            Glide.with(mContext).load(user.getUser_image())
                    .placeholder(R.drawable.avatar)
                    .error(R.drawable.avatar)
                    .into(holder.getBlockedUserImage());

            holder.getBlockedUserName().setText(user.getUser_username());
        }
        holder.getDeleteBlockedUser().setOnClickListener(v ->
                mOnClickBlockedUser.onDeleteBlockedUser(user.getUser_id()));
    }

    @Override
    public int getItemCount() {
        return mBlockedUsersResponses == null ? 0 : mBlockedUsersResponses.size();
    }

    public void setOnClickBlockedUser(DeleteBlockedUserListener onClickBlockedUser) {
        this.mOnClickBlockedUser = onClickBlockedUser;
    }

    public void removeItem(long userId) {
        for (BlockedUsers user : mBlockedUsersResponses) {
            if (user.getUser().getUser_id() == userId) {
                mBlockedUsersResponses.remove(user);
                notifyDataSetChanged();
                return;
            }
        }
    }

    public interface DeleteBlockedUserListener {
        void onDeleteBlockedUser(long userId);
    }
}
