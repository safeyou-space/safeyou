package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class BlockedUsersHolder extends RecyclerView.ViewHolder {


    @BindView(R.id.blockedUserImage)
    CircleImageView blockedUserImage;
    @BindView(R.id.blockedUserName)
    TextView blockedUserName;
    @BindView(R.id.blockedRepliedTime)
    TextView blockedRepliedTime;
    @BindView(R.id.deleteBlockedUser)
    ImageView deleteBlockedUser;

    public BlockedUsersHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public CircleImageView getBlockedUserImage() {
        return blockedUserImage;
    }

    public TextView getBlockedUserName() {
        return blockedUserName;
    }

    public ImageView getDeleteBlockedUser() {
        return deleteBlockedUser;
    }
}
