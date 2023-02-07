package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class NotificationHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.notificationUserImage)
    CircleImageView notificationUserImage;
    @BindView(R.id.notificationUserName)
    TextView notificationUserName;
    @BindView(R.id.notificationRepliedText)
    TextView notificationRepliedText;
    @BindView(R.id.notificationRepliedTime)
    TextView notificationRepliedTime;

    public NotificationHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }
}
