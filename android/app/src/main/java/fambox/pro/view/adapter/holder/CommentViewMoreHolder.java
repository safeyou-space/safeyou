package fambox.pro.view.adapter.holder;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import com.makeramen.roundedimageview.RoundedImageView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class CommentViewMoreHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.imgCommentUser)
    ImageView imgCommentUser;
    @BindView(R.id.imgCommentUserBadge)
    ImageView imgCommentUserBadge;
    @BindView(R.id.txtCommentUserName)
    TextView txtCommentUserName;
    @BindView(R.id.txtCommentUserPosition)
    TextView txtCommentUserPosition;
    @BindView(R.id.txtCommentUserComment)
    TextView txtCommentUserComment;
    @BindView(R.id.txtCommentDate)
    TextView txtCommentDate;
    @BindView(R.id.txtReply)
    TextView txtReply;
    @BindView(R.id.txtReplyTo)
    TextView txtReplyTo;
    @BindView(R.id.containerMessages)
    ConstraintLayout containerMessages;
    @BindView(R.id.commentLike)
    TextView commentLike;
    @BindView(R.id.likeBtn)
    ImageView likeBtn;
    @BindView(R.id.prvtMessageBtn)
    ImageView prvtMessageBtn;
    @BindView(R.id.moreBtn)
    ImageView moreBtn;
    @BindView(R.id.forumImage)
    RoundedImageView forumImage;

    public CommentViewMoreHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public ImageView getImgCommentUser() {
        return imgCommentUser;
    }

    public TextView getTxtCommentUserName() {
        return txtCommentUserName;
    }

    public TextView getTxtCommentUserPosition() {
        return txtCommentUserPosition;
    }

    public TextView getTxtCommentUserComment() {
        return txtCommentUserComment;
    }

    public TextView getTxtCommentDate() {
        return txtCommentDate;
    }

    public TextView getTxtReply() {
        return txtReply;
    }

    public TextView getTxtReplyTo() {
        return txtReplyTo;
    }

    public ConstraintLayout getContainerMessages() {
        return containerMessages;
    }

    public ImageView getImgCommentUserBadge() {
        return imgCommentUserBadge;
    }

    public TextView getCommentLike() {
        return commentLike;
    }

    public ImageView getLikeBtn() {
        return likeBtn;
    }

    public ImageView getPrvtMessageBtn() {
        return prvtMessageBtn;
    }

    public ImageView getMoreBtn() {
        return moreBtn;
    }

    public RoundedImageView getForumImage() {
        return forumImage;
    }


    public void changeStylesForDarkMode(Context context) {
        txtReply.setTextColor(context.getResources().getColor(R.color.white));

        txtCommentUserPosition.setTextColor(context.getResources().getColor(R.color.white));

        likeBtn.setColorFilter(context.getResources().getColor(R.color.white));

        prvtMessageBtn.setColorFilter(context.getResources().getColor(R.color.white));

        moreBtn.setColorFilter(context.getResources().getColor(R.color.white));

        imgCommentUserBadge.setColorFilter(context.getResources().getColor(R.color.white));

    }
}
