package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.R;

public class ForumHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.imgForumTitle)
    ImageView imgForumTitle;
    @BindView(R.id.txtTitleForum)
    TextView txtTitleForum;
    @BindView(R.id.txtUnderTitle)
    TextView txtUnderTitle;
    @BindView(R.id.txtShortDescription)
    TextView txtShortDescription;
    CircleImageView imgActiveUserThree;
    @BindView(R.id.txtCommentCount)
    TextView txtCommentCount;
    @BindView(R.id.containerHigLightFrame)
    LinearLayout containerHigLightFrame;
    @BindView(R.id.txtRecentlyCount)
    TextView txtRecentlyCount;


    public ForumHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public ImageView getImgForumTitle() {
        return imgForumTitle;
    }

    public TextView getTxtTitleForum() {
        return txtTitleForum;
    }

    public TextView getTxtUnderTitle() {
        return txtUnderTitle;
    }

    public TextView getTxtShortDescription() {
        return txtShortDescription;
    }

    public CircleImageView getImgActiveUserThree() {
        return imgActiveUserThree;
    }

    public TextView getTxtCommentCount() {
        return txtCommentCount;
    }

    public LinearLayout getContainerHigLightFrame() {
        return containerHigLightFrame;
    }

    public TextView getTxtRecentlyCount() {
        return txtRecentlyCount;
    }
}
