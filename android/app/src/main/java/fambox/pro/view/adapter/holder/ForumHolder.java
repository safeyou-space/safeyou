package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.LinearLayoutCompat;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
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
    @BindView(R.id.txtCommentCount)
    TextView txtCommentCount;
    @BindView(R.id.containerHigLightFrame)
    LinearLayout containerHigLightFrame;
    @BindView(R.id.rate_bar_layout)
    LinearLayoutCompat rateBar;
    @BindView(R.id.txtRecentlyCount)
    TextView txtRecentlyCount;
    @BindView(R.id.txtViewsCount)
    TextView txtViewsCount;
    @BindView(R.id.rating)
    TextView rating;
    @BindView(R.id.rateCount)
    TextView rateCount;


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

    public TextView getTxtCommentCount() {
        return txtCommentCount;
    }

    public TextView getTxtViewsCount() {
        return txtViewsCount;
    }

    public TextView getRating() {
        return rating;
    }

    public TextView getRateCount() {
        return rateCount;
    }

    public LinearLayoutCompat getRateBar() {
        return rateBar;
    }
}
