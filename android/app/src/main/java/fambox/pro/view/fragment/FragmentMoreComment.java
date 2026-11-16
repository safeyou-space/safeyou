package fambox.pro.view.fragment;

import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.PopupMenu;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.core.widget.NestedScrollView;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.makeramen.roundedimageview.RoundedImageView;

import java.lang.reflect.Field;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.fragment.FragmentMoreCommentPresenter;
import fambox.pro.privatechat.network.model.Like;
import fambox.pro.privatechat.view.ChatActivity;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.Utils;
import fambox.pro.view.ForumCommentActivity;
import fambox.pro.view.ReportActivity;
import fambox.pro.view.adapter.AdapterForumCommentViewMore;

public class FragmentMoreComment extends BaseFragment implements FragmentMoreCommentContract.View {

    private FragmentActivity mContext;
    private FragmentMoreCommentPresenter mFragmentMoreCommentPresenter;
    private AdapterForumCommentViewMore mAdapterForumCommentViewMore;
    private List<Comments> mReplies = new ArrayList<>();
    private ClickReplyListener mClickReplyListener;
    private OnCommentBackListener mOnCommentBackListener;


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
    @BindView(R.id.recViewChildComment)
    RecyclerView recViewChildComment;
    @BindView(R.id.containerMessages)
    ConstraintLayout containerMessages;
    @BindView(R.id.commentLike)
    TextView commentLike;
    @BindView(R.id.likeBtn)
    ImageView likeBtn;
    @BindView(R.id.moreBtn)
    ImageButton moreBtn;
    @BindView(R.id.prvtMessageBtn)
    ImageView prvtMessageBtn;
    @BindView(R.id.forumImage)
    RoundedImageView forumImage;
    @BindView(R.id.nestedScrollView)
    NestedScrollView nestedScrollView;

    public static FragmentMoreComment start(FragmentActivity context, Bundle bundle) {
        FragmentMoreComment fragmentMoreComment = new FragmentMoreComment();
        fragmentMoreComment.setArguments(bundle);
        FragmentManager fragmentManager = context.getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        if (fragmentManager.findFragmentByTag(FragmentMoreComment.class.getName()) == null) {
            fragmentTransaction.add(R.id.viewMoreContainer, fragmentMoreComment, FragmentMoreComment.class.getName());
        } else {
            fragmentTransaction.replace(R.id.viewMoreContainer, fragmentMoreComment, FragmentMoreComment.class.getName());
        }
        fragmentTransaction.commit();
        return fragmentMoreComment;
    }

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getActivity() != null) {
            mContext = getActivity();
        }
        return inflater.inflate(R.layout.fragment_more_comment, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        mFragmentMoreCommentPresenter = new FragmentMoreCommentPresenter();
        mFragmentMoreCommentPresenter.attachView(this);
        mFragmentMoreCommentPresenter.initBundle(getArguments());
        mFragmentMoreCommentPresenter.viewIsReady();
        mFragmentMoreCommentPresenter.setupReplyList(mReplies);
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof ClickReplyListener) {
            mClickReplyListener = (ClickReplyListener) context;
        }
        if (context instanceof OnCommentBackListener) {
            mOnCommentBackListener = (OnCommentBackListener) context;
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mFragmentMoreCommentPresenter != null) {
            mFragmentMoreCommentPresenter.destroy();
        }
    }

    @OnClick(R.id.txtReply)
    void onClickReply() {
        mFragmentMoreCommentPresenter.clickParentMessageReply();
    }

    @OnClick(R.id.btnBackComments)
    void onClickBackToComment() {
        mOnCommentBackListener.onClickBack();
    }

    @OnClick(R.id.moreBtn)
    void onClickMoreBtn(View view) {
        mFragmentMoreCommentPresenter.clickMoreBtn(view);
    }

    @OnClick(R.id.likeBtn)
    void onClickLike(View view) {
        ImageView imageButton = (ImageView) view;
        if (view.getTag() != null && view.getTag()
                instanceof Integer && (Integer) view.getTag() == 0) {
            imageButton.setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_like_coment_empty));
            mFragmentMoreCommentPresenter.onClickLike(0);
            view.setTag(1);
        } else {
            imageButton.setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_licke_coment_full));
            mFragmentMoreCommentPresenter.onClickLike(1);
            view.setTag(0);
        }
    }

    @OnClick(R.id.prvtMessageBtn)
    void onClickPrivateMessage() {
        mFragmentMoreCommentPresenter.clickPrivateMessage();
    }

    void onClickBlockUser(Comments comments) {
        AlertDialog.Builder ad = new AlertDialog.Builder(getView().getContext());
        ad.setMessage(getResources().getString(R.string.want_block_user_text_key));
        ad.setPositiveButton(getResources().getString(R.string.confirm), (dialogInterface, i) -> {
            mFragmentMoreCommentPresenter.onClickBlockUser(comments);
        });
        ad.setNegativeButton(getResources().getString(R.string.cancel), (dialogInterface, i) -> dialogInterface.dismiss());
        ad.create().show();
    }

    @Override
    public void onClickParentMessage(Comments comment) {
        KeyboardUtils.showKeyboard(mContext);
        mClickReplyListener.onClickReply(comment);
    }

    @Override
    public void onReplyChildMessage(Comments childComment) {
        mClickReplyListener.onClickReply(childComment);
    }

    @Override
    public void clickMoreBtn(Comments comment, View view) {
        showPopup(view, comment);
    }

    @Override
    public void goPrivateMessage(Bundle bundle) {
        nextActivity(mContext, ChatActivity.class, bundle);
    }

    @Override
    public void removeBlockedUser(Comments comments) {
        Iterator<Comments> commentsIterator = mReplies.iterator();
        while (commentsIterator.hasNext()) {
            Comments comment = commentsIterator.next();
            if (comment.getUser_id() == comments.getUser_id()) {
                commentsIterator.remove();
            }
            if (comment.getMessageReplies() != null) {
                Iterator<Comments> commentsReplyIterator = comment.getMessageReplies().iterator();
                while (commentsReplyIterator.hasNext()) {
                    if (commentsReplyIterator.next().getUser_id() == comments.getUser_id()) {
                        commentsReplyIterator.remove();
                    }
                }
            }
        }
        if (getActivity() != null && getActivity() instanceof ForumCommentActivity) {
            ((ForumCommentActivity) getActivity()).removeBlockedUser(comments);
        }
        setupRecViewReply(mReplies);
    }

    @Override
    public void onClickLike(Comments comment, int likeType) {
        if (mClickReplyListener != null) {
            mClickReplyListener.onClickLike(comment, likeType);
        }
    }

    @Override
    public void setUpParentMessage(int userId, String userImage, String userName,
                                   String userProfession, String userComment, String data,
                                   int userType, boolean isMy, List<Like> likes, String image) {
        containerMessages.setBackgroundResource(isMy ? R.drawable.comment_frame : R.drawable.comment_frame_white);
        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
        int nightModeFlags =
                mContext.getResources().getConfiguration().uiMode &
                        Configuration.UI_MODE_NIGHT_MASK;
        if (isMy && (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES)) {
            changeStylesForDarkMode(mContext);
        }
        prvtMessageBtn.setVisibility(userId == SafeYouApp.getPreference()
                .getLongValue(Constants.Key.KEY_USER_ID, 0) || userType == 5
                ? View.GONE : View.VISIBLE);
        if (userImage != null) {
            Glide.with(mContext).load(userImage)
                    .into(imgCommentUser);
        }

        if (image != null && !image.equals("")) {
            forumImage.setVisibility(View.VISIBLE);
            Glide.with(mContext).load(image).into(forumImage);
        } else {
            forumImage.setVisibility(View.GONE);
        }

        if (likes != null) {
            int likeCount = 0;
            for (Like likeForCount : likes) {
                if (likeForCount.getLike_user_id() == SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0)) {
                    if (likeForCount.getLike_type() == 1) {
                        likeBtn.setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_licke_coment_full));
                        likeBtn.setTag(0);
                    } else {
                        likeBtn.setImageDrawable(ContextCompat.getDrawable(mContext, R.drawable.icon_like_coment_empty));
                        likeBtn.setTag(1);
                    }
                }
                if (likeForCount.getLike_type() > 0) {
                    likeCount++;
                }
            }
            if (likeCount > 0) {
                commentLike.setVisibility(View.VISIBLE);
                commentLike.setText("" + likeCount);
                commentLike.setContentDescription(mContext.getString(R.string.like_icon_description) + likeCount);

            } else {
                commentLike.setVisibility(View.GONE);
            }
        } else {
            commentLike.setVisibility(View.GONE);
        }

        switch (userType) {
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
                txtCommentUserPosition.setVisibility(View.GONE);
                imgCommentUserBadge.setVisibility(View.GONE);
                break;
            default:
                imgCommentUserBadge.setVisibility(View.VISIBLE);
        }
        txtCommentUserName.setText(userName);
        txtCommentUserPosition.setText(userProfession);
        txtCommentUserComment.setText(userComment);
        if (data != null) {
            txtCommentDate.setText(Utils.timeUTC(data, ((BaseActivity) mContext).getLocale()));
        }
    }

    @Override
    public void setupRecViewReply(List<Comments> replies) {
        mAdapterForumCommentViewMore = new AdapterForumCommentViewMore(mContext);
        mAdapterForumCommentViewMore.setClickCommentListener(
                new AdapterForumCommentViewMore.ClickCommentListener() {
                    @Override
                    public void onClickComment(Comments comment) {
                        if (mClickReplyListener != null)
                            mClickReplyListener.onClickReply(comment);
                        KeyboardUtils.showKeyboard(mContext);
                    }

                    @Override
                    public void onClickPrivateMessage(Comments comments) {
                        Bundle bundle = new Bundle();
                        bundle.putBoolean("opened_from_network", true);
                        bundle.putString("user_id", String.valueOf(comments.getUser_id()));
                        bundle.putString("user_name", comments.getName());
                        try {
                            bundle.putString("user_image", new URL(comments.getImage_path()).getPath());
                        } catch (MalformedURLException e) {
                            e.printStackTrace();
                        }
                        bundle.putString("user_profession", comments.getUser_type());
                        nextActivity(mContext, ChatActivity.class, bundle);
                    }

                    @Override
                    public void onClickBlockUser(Comments comments) {
                        AlertDialog.Builder ad = new AlertDialog.Builder(mContext);
                        ad.setMessage(getResources().getString(R.string.want_block_user_text_key));
                        ad.setPositiveButton(getResources().getString(R.string.confirm), (dialogInterface, i) ->
                                mFragmentMoreCommentPresenter.onClickBlockUser(comments));
                        ad.setNegativeButton(getResources().getString(R.string.cancel), (dialogInterface, i) -> dialogInterface.dismiss());
                        ad.create().show();
                    }

                    @Override
                    public void onClickLike(Comments comments, int likeType) {
                        if (mClickReplyListener != null)
                            mClickReplyListener.onClickLike(comments, likeType);
                    }

                    @Override
                    public void onDeleteComment(Comments comments) {
                        if (mClickReplyListener != null)
                            mClickReplyListener.onClickDelete(comments);
                    }

                    @Override
                    public void onEditComment(Comments comment, CommentUpdateListener commentUpdateListener) {
                        if (mClickReplyListener != null) {
                            mClickReplyListener.onEditComment(comment, commentUpdateListener);
                        }
                    }
                });

        mAdapterForumCommentViewMore.addReplays(replies);

        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewChildComment.setLayoutManager(verticalLayoutManager);
        recViewChildComment.setAdapter(mAdapterForumCommentViewMore);
    }

    public void addReplies(List<Comments> replies) {
        if (mReplies != null) {
            mReplies.clear();
        }

        if (replies != null) {
            for (Comments comment : replies) {
                if (!comment.isHidden()) {
                    this.mReplies.add(comment);
                }
            }
        }
        this.mReplies = replies;
        if (mFragmentMoreCommentPresenter != null) {
            mFragmentMoreCommentPresenter.setupReplyList(this.mReplies);
        }
    }

    public void addNewReplies(Comments reply) {
        if (mAdapterForumCommentViewMore != null) {
            if (!reply.isHidden()) {
                mAdapterForumCommentViewMore.addMessage(reply, recViewChildComment, nestedScrollView);
            }
        }
    }

    @Override
    public void showProgress() {

    }

    @Override
    public void goBack() {
        getActivity().onBackPressed();
    }

    @Override
    public void dismissProgress() {

    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }

    private void showPopup(View v, Comments comment) {
        PopupMenu popup = new PopupMenu(mContext, v);
        popup.setOnMenuItemClickListener(item -> {
            switch (item.getItemId()) {
                case R.id.menuReport:
                    Bundle bundle = new Bundle();
                    bundle.putParcelable("comment", comment);
                    Intent intent = new Intent(mContext, ReportActivity.class);
                    intent.putExtras(bundle);
                    mContext.startActivity(intent);
                    return true;
                case R.id.menuEdit:
                    if (mClickReplyListener != null) {
                        mClickReplyListener.onEditComment(comment, mParentComment -> {
                            if (comment != null) {
                                setUpParentMessage((int) mParentComment.getUser_id(),
                                        mParentComment.getImage_path(),
                                        mParentComment.getName(),
                                        mParentComment.getUser_type(),
                                        mParentComment.getMessage(), mParentComment.getCreated_at(),
                                        mParentComment.getUser_type_id(), mParentComment.isMy(),
                                        mParentComment.getLikes(),
                                        mParentComment.getContentImage());
                            }
                        });
                    }
                    return true;
                case R.id.menuDelete:
                    if (mClickReplyListener != null && mOnCommentBackListener != null) {
                        mClickReplyListener.onClickDelete(comment);
                        mOnCommentBackListener.onClickBack();
                    }
                    return true;
                case R.id.menuCopy:
                    ClipboardManager clipboard = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
                    ClipData clip = ClipData.newPlainText(comment.getName(), comment.getMessage());
                    clipboard.setPrimaryClip(clip);
                    Toast.makeText(mContext, "Copied", Toast.LENGTH_SHORT).show();
                    return true;
                case R.id.menuBlockUser:
                    onClickBlockUser(comment);
                    return true;
                default:
                    return false;
            }
        });
        popup.inflate(R.menu.menu_comment_action);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            popup.setForceShowIcon(true);
        } else {
            try {
                Field fMenuHelper = PopupMenu.class.getDeclaredField("mPopup");
                fMenuHelper.setAccessible(true);
                Object menuHelper = fMenuHelper.get(popup);
                Class[] argTypes = new Class[]{boolean.class};
                if (menuHelper != null) {
                    menuHelper.getClass()
                            .getDeclaredMethod("setForceShowIcon", argTypes)
                            .invoke(menuHelper, true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (comment.getUser_id() != SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0)) {
            popup.getMenu().getItem(1).setVisible(false);
            popup.getMenu().getItem(2).setVisible(false);
        } else {
            popup.getMenu().getItem(0).setVisible(false);
            popup.getMenu().getItem(4).setVisible(false);
        }
        popup.show();
    }

    public interface ClickReplyListener {
        void onClickReply(Comments comment);

        void onClickLike(Comments comments, int likeType);

        void onClickDelete(Comments comment);

        void onEditComment(Comments comment, CommentUpdateListener commentUpdateListener);
    }

    public interface CommentUpdateListener {
        void onUpdate(Comments comment);
    }

    public interface OnCommentBackListener {
        void onClickBack();
    }

    private void changeStylesForDarkMode(Context context) {
        txtReply.setTextColor(context.getResources().getColor(R.color.white));

        txtCommentUserPosition.setTextColor(context.getResources().getColor(R.color.white));

        likeBtn.setColorFilter(context.getResources().getColor(R.color.white));

        prvtMessageBtn.setColorFilter(context.getResources().getColor(R.color.white));

        moreBtn.setColorFilter(context.getResources().getColor(R.color.white));

        imgCommentUserBadge.setColorFilter(context.getResources().getColor(R.color.white));

    }
}
