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
public class PrivateMessageHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.prUserImage)
    CircleImageView prUserImage;
    @BindView(R.id.prUserName)
    TextView prUserName;
    @BindView(R.id.prProfession)
    TextView prProfession;
    @BindView(R.id.prLastCommunicationDate)
    TextView prLastCommunicationDate;
    @BindView(R.id.unreadMessageCount)
    TextView unreadMessageCount;

    public PrivateMessageHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }
}
