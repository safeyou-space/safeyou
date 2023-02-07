package fambox.pro.view.adapter.holder;

import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;

import android.content.Context;
import android.content.res.Configuration;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.privatechat.network.model.Like;
import fambox.pro.utils.Utils;
import lombok.Data;

@Data
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
    @BindView(R.id.likeBtn)
    ImageView likeBtn;
    @BindView(R.id.commentLikeOne)
    TextView commentLikeOne;
    @BindView(R.id.prvtMessageBtn)
    ImageView prvtMessageBtn;
    @BindView(R.id.moreBtn)
    ImageView moreBtn;
    @BindView(R.id.forumImage)
    RoundedImageView forumImage;

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
    @BindView(R.id.likeBtnOne)
    ImageView likeBtnOne;
    @BindView(R.id.commentLikeTwo)
    TextView commentLikeTwo;
    @BindView(R.id.prvtMessageBtnOne)
    ImageView prvtMessageBtnOne;
    @BindView(R.id.moreBtnOne)
    ImageView moreBtnOne;
    @BindView(R.id.forumImageOne)
    RoundedImageView forumImageOne;

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
    @BindView(R.id.commentLikeThree)
    TextView commentLikeThree;
    @BindView(R.id.likeBtnTwo)
    ImageView likeBtnTwo;
    @BindView(R.id.prvtMessageBtnTwo)
    ImageView prvtMessageBtnTwo;
    @BindView(R.id.moreBtnTwo)
    ImageView moreBtnTwo;
    @BindView(R.id.forumImageTwo)
    RoundedImageView forumImageTwo;


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

    public ImageView getLikeBtn() {
        return likeBtn;
    }

    public TextView getCommentLikeOne() {
        return commentLikeOne;
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
        // reset
        containerOne.setVisibility(View.GONE);
        containerTwo.setVisibility(View.GONE);
        txtViewMore.setVisibility(View.GONE);

        if (replies != null) {
            if (replies.size() == 1) {
                setupReply(context, replies.get(0), containerOne,
                        containerMessagesOne,
                        txtCommentUserNameOne,
                        txtCommentUserCommentOne,
                        txtCommentDateOne,
                        txtCommentUserPositionOne,
                        prvtMessageBtnOne,
                        imgCommentUserOne,
                        forumImageOne,
                        likeBtnOne,
                        commentLikeTwo,
                        imgCommentUserBadgeOne);
            } else if (replies.size() >= 2) {
                setupReply(context, replies.get(0), containerOne,
                        containerMessagesOne,
                        txtCommentUserNameOne,
                        txtCommentUserCommentOne,
                        txtCommentDateOne,
                        txtCommentUserPositionOne,
                        prvtMessageBtnOne,
                        imgCommentUserOne,
                        forumImageOne,
                        likeBtnOne,
                        commentLikeTwo,
                        imgCommentUserBadgeOne);
                setupReply(context, replies.get(1), containerTwo,
                        containerMessagesTwo,
                        txtCommentUserNameTwo,
                        txtCommentUserCommentTwo,
                        txtCommentDateTwo,
                        txtCommentUserPositionTwo,
                        prvtMessageBtnTwo,
                        imgCommentUserTwo,
                        forumImageTwo,
                        likeBtnTwo,
                        commentLikeThree,
                        imgCommentUserBadgeTwo);

                if (replies.size() > 2) {
                    txtViewMore.setVisibility(View.VISIBLE);
                    String replyText = context.getResources().getString(R.string.count_replies, replies.size() - 2) + " | " +
                            context.getResources().getString(R.string.view_more_replies);
                    txtViewMore.setText(replyText);
                }
            }
        }
    }

    private void setupReply(Context context,
                            Comments comment,
                            RelativeLayout container,
                            ConstraintLayout containerMessages,
                            TextView commentUserName,
                            TextView commentUserComment,
                            TextView commentDate,
                            TextView commentUserPosition,
                            ImageView prvtMessageBtn,
                            ImageView imgCommentUser,
                            RoundedImageView forumImage,
                            ImageView likeBtn,
                            TextView commentLike,
                            ImageView imgCommentUserBadge

    ) {
        String locale = LocaleHelper.getLanguage(context);
        long currentUserID = SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0);

        container.setVisibility(View.VISIBLE);
        containerMessages.setBackground(comment.isMy() ? ContextCompat.getDrawable(context, R.drawable.comment_frame)
                : ContextCompat.getDrawable(context, R.drawable.comment_frame_white));
        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
        int nightModeFlags =
                context.getResources().getConfiguration().uiMode &
                        Configuration.UI_MODE_NIGHT_MASK;
        if ((isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES)) {
            if (comment.isMy()) {
                changeMyStylesForDarkMode(context);
            } else {
                changeStylesForDarkMode(context);
            }
        }
        commentUserName.setText(comment.getName());
        commentUserComment.setText(comment.getMessage());

        commentDate.setText(Utils.timeUTC(comment.getCreated_at(), locale));
        commentUserPosition.setText(comment.getUser_type());
        prvtMessageBtn.setVisibility(comment.getUser_id() == currentUserID
                || comment.getUser_type_id() == 5 || (SafeYouApp.isMinorUser() && comment.getUser_id() != 10 && comment.getUser_id() != 8) ? View.GONE : View.VISIBLE);
        if (comment.getImage_path() != null) {
            Glide.with(context).load(comment.getImage_path())
                    .into(imgCommentUser);
        }

        if (comment.getContentImage() != null && !comment.getContentImage().equals("")) {
            forumImage.setVisibility(View.VISIBLE);
            Glide.with(context).load(comment.getContentImage()).into(forumImage);
        } else {
            forumImage.setVisibility(View.GONE);
        }

        List<Like> likes = comment.getLikes();
        if (likes != null) {
            int likeCount = 0;
            for (Like likeForCount : likes) {
                if (likeForCount.getLike_user_id() == currentUserID) {
                    if (likeForCount.getLike_type() == 1) {
                        likeBtn.setImageDrawable(ContextCompat.getDrawable(context, R.drawable.icon_licke_coment_full));
                        likeBtn.setTag(0);
                    } else {
                        likeBtn.setImageDrawable(ContextCompat.getDrawable(context, R.drawable.icon_like_coment_empty));
                        likeBtn.setTag(1);
                    }
                } else {
                    likeBtn.setImageDrawable(ContextCompat.getDrawable(context, R.drawable.icon_like_coment_empty));
                    likeBtn.setTag(1);
                }
                if (likeForCount.getLike_type() > 0) {
                    likeCount++;
                }
            }

            if (likeCount > 0) {
                commentLike.setVisibility(View.VISIBLE);
                commentLike.setText("" + likeCount);
                commentLike.setContentDescription(context.getString(R.string.like_icon_description) + likeCount);

            } else {
                commentLike.setVisibility(View.GONE);
            }
        } else {
            commentLike.setVisibility(View.GONE);
        }

        switch (comment.getUser_type_id()) {
            case 1:
                imgCommentUserBadge.setVisibility(View.GONE);
                break;
            case 2:
                imgCommentUserBadge.setVisibility(View.VISIBLE);
                break;
            case 3:
                imgCommentUserBadge.setVisibility(View.VISIBLE);
                break;
            case 4:
                imgCommentUserBadge.setVisibility(View.VISIBLE);
                break;
            case 5:
                commentUserPosition.setVisibility(View.GONE);
                imgCommentUserBadge.setVisibility(View.GONE);
                break;
            default:
                imgCommentUserBadge.setVisibility(View.VISIBLE);
        }

        prvtMessageBtn.setTag(comment);
        containerMessages.setTag(comment);
    }

    public void changeStylesForDarkMode(Context context) {
        txtReply.setTextColor(context.getResources().getColor(R.color.new_main_color));
        txtReplyOne.setTextColor(context.getResources().getColor(R.color.new_main_color));
        txtReplyTwo.setTextColor(context.getResources().getColor(R.color.new_main_color));

        txtCommentUserPosition.setTextColor(context.getResources().getColor(R.color.new_main_color));
        txtCommentUserPositionOne.setTextColor(context.getResources().getColor(R.color.new_main_color));
        txtCommentUserPositionTwo.setTextColor(context.getResources().getColor(R.color.new_main_color));

        likeBtn.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        likeBtnOne.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        likeBtnTwo.setColorFilter(context.getResources().getColor(R.color.new_main_color));

        prvtMessageBtn.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        prvtMessageBtnOne.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        prvtMessageBtnTwo.setColorFilter(context.getResources().getColor(R.color.new_main_color));

        moreBtn.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        moreBtnOne.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        moreBtnTwo.setColorFilter(context.getResources().getColor(R.color.new_main_color));

        imgCommentUserBadge.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        imgCommentUserBadgeOne.setColorFilter(context.getResources().getColor(R.color.new_main_color));
        imgCommentUserBadgeTwo.setColorFilter(context.getResources().getColor(R.color.new_main_color));

    }

    public void changeMyStylesForDarkMode(Context context) {
        txtReply.setTextColor(context.getResources().getColor(R.color.white));
        txtReplyOne.setTextColor(context.getResources().getColor(R.color.white));
        txtReplyTwo.setTextColor(context.getResources().getColor(R.color.white));

        txtCommentUserPosition.setTextColor(context.getResources().getColor(R.color.white));
        txtCommentUserPositionOne.setTextColor(context.getResources().getColor(R.color.white));
        txtCommentUserPositionTwo.setTextColor(context.getResources().getColor(R.color.white));

        likeBtn.setColorFilter(context.getResources().getColor(R.color.white));
        likeBtnOne.setColorFilter(context.getResources().getColor(R.color.white));
        likeBtnTwo.setColorFilter(context.getResources().getColor(R.color.white));

        prvtMessageBtn.setColorFilter(context.getResources().getColor(R.color.white));
        prvtMessageBtnOne.setColorFilter(context.getResources().getColor(R.color.white));
        prvtMessageBtnTwo.setColorFilter(context.getResources().getColor(R.color.white));

        moreBtn.setColorFilter(context.getResources().getColor(R.color.white));
        moreBtnOne.setColorFilter(context.getResources().getColor(R.color.white));
        moreBtnTwo.setColorFilter(context.getResources().getColor(R.color.white));

        imgCommentUserBadge.setColorFilter(context.getResources().getColor(R.color.white));
        imgCommentUserBadgeOne.setColorFilter(context.getResources().getColor(R.color.white));
        imgCommentUserBadgeTwo.setColorFilter(context.getResources().getColor(R.color.white));

    }
}
