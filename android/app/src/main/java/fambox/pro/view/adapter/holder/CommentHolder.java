package fambox.pro.view.adapter.holder;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.utils.Utils;

import static fambox.pro.Constants.BASE_URL;

public class CommentHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.imgCommentUser)
    ImageView imgCommentUser;
    @BindView(R.id.txtCommentUserName)
    TextView txtCommentUserName;
    @BindView(R.id.imgCommentUserBadge)
    ImageView imgCommentUserBadge;
    @BindView(R.id.txtCommentUserPosition)
    TextView txtCommentUserPosition;
    @BindView(R.id.txtCommentUserComment)
    TextView txtCommentUserComment;
    @BindView(R.id.txtCommentDate)
    TextView txtCommentDate;
    @BindView(R.id.txtReply)
    TextView txtReply;
    @BindView(R.id.containerMessages)
    ConstraintLayout containerMessages;

    @BindView(R.id.imgCommentUserOne)
    ImageView imgCommentUserOne;
    @BindView(R.id.txtCommentUserNameOne)
    TextView txtCommentUserNameOne;
    @BindView(R.id.imgCommentUserBadgeOne)
    ImageView imgCommentUserBadgeOne;
    @BindView(R.id.txtCommentUserPositionOne)
    TextView txtCommentUserPositionOne;
    @BindView(R.id.txtCommentUserCommentOne)
    TextView txtCommentUserCommentOne;
    @BindView(R.id.txtCommentDateOne)
    TextView txtCommentDateOne;
    @BindView(R.id.txtReplyOne)
    TextView txtReplyOne;
    @BindView(R.id.containerMessagesOne)
    ConstraintLayout containerMessagesOne;
    @BindView(R.id.containerOne)
    RelativeLayout containerOne;

    @BindView(R.id.imgCommentUserTwo)
    ImageView imgCommentUserTwo;
    @BindView(R.id.txtCommentUserNameTwo)
    TextView txtCommentUserNameTwo;
    @BindView(R.id.imgCommentUserBadgeTwo)
    ImageView imgCommentUserBadgeTwo;
    @BindView(R.id.txtCommentUserPositionTwo)
    TextView txtCommentUserPositionTwo;
    @BindView(R.id.txtCommentUserCommentTwo)
    TextView txtCommentUserCommentTwo;
    @BindView(R.id.txtCommentDateTwo)
    TextView txtCommentDateTwo;
    @BindView(R.id.txtReplyTwo)
    TextView txtReplyTwo;
    @BindView(R.id.txtViewMore)
    TextView txtViewMore;
    @BindView(R.id.containerMessagesTwo)
    ConstraintLayout containerMessagesTwo;
    @BindView(R.id.containerTwo)
    RelativeLayout containerTwo;


    public CommentHolder(@NonNull View itemView) {
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

    public TextView getTxtReplyOne() {
        return txtReplyOne;
    }

    public TextView getTxtReplyTwo() {
        return txtReplyTwo;
    }

    public TextView getTxtViewMore() {
        return txtViewMore;
    }

    public ConstraintLayout getContainerMessages() {
        return containerMessages;
    }

    public ConstraintLayout getContainerMessagesOne() {
        return containerMessagesOne;
    }

    public ConstraintLayout getContainerMessagesTwo() {
        return containerMessagesTwo;
    }

    public ImageView getImgCommentUserBadge() {
        return imgCommentUserBadge;
    }

    public void addReply(Context context, List<Comments> replies) {
        String locale = context.getResources().getConfiguration().locale.getLanguage();

        // reset
        containerOne.setVisibility(View.GONE);
        containerTwo.setVisibility(View.GONE);
        txtViewMore.setVisibility(View.GONE);

        if (replies != null) {
            if (replies.size() == 1) {
                Comments comment = replies.get(0);
                containerOne.setVisibility(View.VISIBLE);
                containerMessagesOne.setBackground(comment.isMy() ? ContextCompat.getDrawable(context, R.drawable.comment_frame)
                        : ContextCompat.getDrawable(context, R.drawable.comment_frame_white));
                txtCommentUserNameOne.setText(comment.getName());
                txtCommentUserCommentOne.setText(comment.getMessage());
                txtCommentDateOne.setText(Utils.timeUTC(comment.getCreated_at(), locale));
                txtCommentUserPositionOne.setText(comment.getUser_type());
                if (comment.getImage_path() != null) {
                    Glide.with(context).load(BASE_URL.concat(comment.getImage_path()))
                            .into(imgCommentUserOne);
                }

                switch (comment.getUser_type_id()) {
                    case 1:
                        imgCommentUserBadgeOne.setVisibility(View.GONE);
                        break;
                    case 2:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 3:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 4:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 5:
                        txtCommentUserPositionOne.setVisibility(View.GONE);
                        imgCommentUserBadgeOne.setVisibility(View.GONE);
                        break;
                    default:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                }

                txtReplyOne.setTag(comment);
                containerMessagesOne.setTag(comment);

            } else if (replies.size() == 2) {
                Comments comment = replies.get(0);
                containerOne.setVisibility(View.VISIBLE);
                containerMessagesOne.setBackground(comment.isMy() ? ContextCompat.getDrawable(context, R.drawable.comment_frame)
                        : ContextCompat.getDrawable(context, R.drawable.comment_frame_white));
                txtCommentUserNameOne.setText(comment.getName());
                txtCommentUserCommentOne.setText(comment.getMessage());
                txtCommentDateOne.setText(Utils.timeUTC(comment.getCreated_at(), locale));
                txtCommentUserPositionOne.setText(comment.getUser_type());
                if (comment.getImage_path() != null) {
                    Glide.with(context).load(BASE_URL.concat(comment.getImage_path()))
                            .into(imgCommentUserOne);
                }

                switch (comment.getUser_type_id()) {
                    case 1:
                        imgCommentUserBadgeOne.setVisibility(View.GONE);
                        break;
                    case 2:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 3:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 4:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 5:
                        txtCommentUserPositionOne.setVisibility(View.GONE);
                        imgCommentUserBadgeOne.setVisibility(View.GONE);
                        break;
                    default:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                }

                txtReplyOne.setTag(comment);
                containerMessagesOne.setTag(comment);

                Comments comment1 = replies.get(1);
                containerTwo.setVisibility(View.VISIBLE);
                containerMessagesTwo.setBackground(comment1.isMy() ? ContextCompat.getDrawable(context, R.drawable.comment_frame)
                        : ContextCompat.getDrawable(context, R.drawable.comment_frame_white));
                txtCommentUserNameTwo.setText(comment1.getName());
                txtCommentUserCommentTwo.setText(comment1.getMessage());
                txtCommentDateTwo.setText(Utils.timeUTC(comment1.getCreated_at(), locale));
                txtCommentUserPositionTwo.setText(comment1.getUser_type());
                if (comment1.getImage_path() != null) {
                    Glide.with(context).load(BASE_URL.concat(comment1.getImage_path()))
                            .into(imgCommentUserTwo);
                }

                switch (comment1.getUser_type_id()) {
                    case 1:
                        imgCommentUserBadgeTwo.setVisibility(View.GONE);
                        break;
                    case 2:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                        break;
                    case 3:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                        break;
                    case 4:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                        break;
                    case 5:
                        txtCommentUserPositionTwo.setVisibility(View.GONE);
                        imgCommentUserBadgeTwo.setVisibility(View.GONE);
                        break;
                    default:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                }

                txtReplyTwo.setTag(comment1);
                containerMessagesTwo.setTag(comment1);

            } else if (replies.size() > 2) {
                Comments comment = replies.get(0);
                containerOne.setVisibility(View.VISIBLE);
                containerMessagesOne.setBackground(comment.isMy() ? ContextCompat.getDrawable(context, R.drawable.comment_frame)
                        : ContextCompat.getDrawable(context, R.drawable.comment_frame_white));
                txtCommentUserNameOne.setText(comment.getName());
                txtCommentUserCommentOne.setText(comment.getMessage());
                txtCommentDateOne.setText(Utils.timeUTC(comment.getCreated_at(), locale));
                txtCommentUserPositionOne.setText(comment.getUser_type());
                if (comment.getImage_path() != null) {
                    Glide.with(context).load(BASE_URL.concat(comment.getImage_path()))
                            .into(imgCommentUserOne);
                }

                switch (comment.getUser_type_id()) {
                    case 1:
                        imgCommentUserBadgeOne.setVisibility(View.GONE);
                        break;
                    case 2:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 3:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 4:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                        break;
                    case 5:
                        txtCommentUserPositionOne.setVisibility(View.GONE);
                        imgCommentUserBadgeOne.setVisibility(View.GONE);
                        break;
                    default:
                        imgCommentUserBadgeOne.setVisibility(View.VISIBLE);
                }

                txtReplyOne.setTag(comment);
                containerMessagesOne.setTag(comment);

                Comments comment1 = replies.get(1);
                containerTwo.setVisibility(View.VISIBLE);
                containerMessagesTwo.setBackground(comment1.isMy() ? ContextCompat.getDrawable(context, R.drawable.comment_frame)
                        : ContextCompat.getDrawable(context, R.drawable.comment_frame_white));
                txtCommentUserNameTwo.setText(comment1.getName());
                txtCommentUserCommentTwo.setText(comment1.getMessage());
                txtCommentDateTwo.setText(Utils.timeUTC(comment1.getCreated_at(), locale));
                txtCommentUserPositionTwo.setText(comment1.getUser_type());
                if (comment1.getImage_path() != null) {
                    Glide.with(context).load(BASE_URL.concat(comment1.getImage_path()))
                            .into(imgCommentUserTwo);
                }

                switch (comment1.getUser_type_id()) {
                    case 1:
                        imgCommentUserBadgeTwo.setVisibility(View.GONE);
                        break;
                    case 2:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                        break;
                    case 3:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                        break;
                    case 4:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                        break;
                    case 5:
                        txtCommentUserPositionTwo.setVisibility(View.GONE);
                        imgCommentUserBadgeTwo.setVisibility(View.GONE);
                        break;
                    default:
                        imgCommentUserBadgeTwo.setVisibility(View.VISIBLE);
                }

                txtReplyTwo.setTag(comment1);
                containerMessagesTwo.setTag(comment1);

                txtViewMore.setVisibility(View.VISIBLE);
                txtViewMore.setText(context.getResources().getString(R.string.view_more, comment1.getReply_count()));
            }
        }
    }
}
