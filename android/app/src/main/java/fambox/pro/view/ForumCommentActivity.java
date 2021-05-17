package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.textfield.TextInputEditText;

import java.util.Collections;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.ForumCommentPresenter;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.AdapterForumComment;
import fambox.pro.view.fragment.FragmentForumDetail;
import fambox.pro.view.fragment.FragmentMoreComment;

public class ForumCommentActivity extends BaseActivity implements ForumCommentContract.View, View.OnClickListener,
        FragmentMoreComment.ClickReplyListener, FragmentMoreComment.OnCommentBackListener {

    private ForumCommentPresenter mForumCommentPresenter;
    private AdapterForumComment mAdapterForumComment;
    private FragmentForumDetail mFragmentForumDetail;
    private FragmentMoreComment mFragmentMoreComment;
    private boolean mIsOpenFromNotification;
    private String mTitle;

    @BindView(R.id.recViewComments)
    RecyclerView recViewComments;
    @BindView(R.id.edtComment)
    TextInputEditText edtComment;
    @BindView(R.id.viewMoreContainer)
    FrameLayout viewMoreContainer;
    @BindView(R.id.forumDetailContainer)
    FrameLayout forumDetailContainer;
    @BindView(R.id.containerForumComments)
    RelativeLayout containerForumComments;
    @BindView(R.id.progressForumComment)
    LinearLayout progressForumComment;
    @BindView(R.id.clearText)
    ImageView clearText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        addAppBar(getResources().getString(R.string.forum), false, true, false, null, true);
        ButterKnife.bind(this);
        mForumCommentPresenter = new ForumCommentPresenter();
        mForumCommentPresenter.attachView(this);
        mForumCommentPresenter.checkPin(getIntent().getExtras());
        mForumCommentPresenter.viewIsReady();
        mTitle = getResources().getString(R.string.forum);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_forum_comment;
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mForumCommentPresenter != null) {
            mForumCommentPresenter.initBundle(getIntent().getExtras(), getLocale());
        }
    }

    @Override
    public void setupForumDetail(boolean isOpenFromNotification) {
        this.mIsOpenFromNotification = isOpenFromNotification;
        if (isOpenFromNotification) {
            forumDetailContainer.setVisibility(View.GONE);
            containerForumComments.setVisibility(View.VISIBLE);
            setDefaultTitle(mTitle);
        } else {
            mFragmentForumDetail = FragmentForumDetail.start(this, R.id.forumDetailContainer);
        }
    }

    @Override
    public void initRecView(List<Comments> comments, List<Comments> replyComments, long replyIdFromNotification) {
        if (comments != null) {
            Collections.reverse(comments);
        }
        if (replyComments != null) {
            Collections.reverse(replyComments);
        }
        mAdapterForumComment = new AdapterForumComment(this, comments, replyComments);
        mAdapterForumComment.setClickMoreListener(comment -> {
            viewMoreContainer.setVisibility(View.VISIBLE);
            Bundle bundle = new Bundle();
            bundle.putParcelable("parent_message", comment);
            mFragmentMoreComment = FragmentMoreComment.start(ForumCommentActivity.this, bundle);
            mFragmentMoreComment.addReplies(replyComments);
        });

        if (replyIdFromNotification > -1) {
            recViewComments.post(() -> recViewComments.scrollToPosition(
                    mAdapterForumComment.scrollToReply(replyIdFromNotification)));
        }

        mAdapterForumComment.setClickCommentListener((comment, replyComment) -> {
            viewMoreContainer.setVisibility(View.VISIBLE);
            Bundle bundle = new Bundle();
            bundle.putParcelable("parent_message", comment);
            if (replyComment != null) {
                bundle.putParcelable("child_message", replyComment);
            }
            mFragmentMoreComment = FragmentMoreComment.start(ForumCommentActivity.this, bundle);
            mFragmentMoreComment.addReplies(replyComments);
        });

        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        recViewComments.setLayoutManager(verticalLayoutManager);
        recViewComments.setAdapter(mAdapterForumComment);
    }

    @OnClick(R.id.clearText)
    void onClickClearText() {
        if (edtComment.getText() != null) {
            edtComment.getText().clear();
        }
    }

    @Override
    public void addNewMessage(Comments comment) {
        mAdapterForumComment.addMessage(comment, recViewComments);
        if (mFragmentMoreComment != null) {
            mFragmentMoreComment.addNewReplies(comment);
        }
    }

    @Override
    public void goPinActivity(Bundle bundle) {
        nextActivity(this, PassKeypadActivity.class, bundle);
        finish();
    }

    @OnClick(R.id.btnCommentSender)
    void clickSendComment() {
        String edtMessage = Utils.getEditableToString(edtComment.getText()).trim();
        if (edtComment.getText() != null && edtMessage.length() > 0) {
            if (mAdapterForumComment != null) {
                if (mFragmentMoreComment == null) {
                    mAdapterForumComment.setTypedFromUserSide(true);
                }
            }
            mForumCommentPresenter.setCommentMassage(edtMessage, getLocale());
            edtComment.getText().clear();
        }
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mForumCommentPresenter != null) {
            mForumCommentPresenter.detachView();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (mForumCommentPresenter != null) {
            mForumCommentPresenter.destroy();
        }
    }

    @Override
    public void onBackPressed() {
        if (viewMoreContainer.getVisibility() == View.VISIBLE) {
            viewMoreContainer.setVisibility(View.GONE);
            mFragmentMoreComment = null;
        } else if (!mIsOpenFromNotification && forumDetailContainer.getVisibility() == View.GONE) {
            forumDetailContainer.setVisibility(View.VISIBLE);
            containerForumComments.setVisibility(View.GONE);
            setDefaultTitle(getResources().getString(R.string.forum));
        } else {
            super.onBackPressed();
        }
        mForumCommentPresenter.onReply(null);
        KeyboardUtils.hideKeyboard(ForumCommentActivity.this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    @Override
    public void showProgress() {
        progressForumComment.setVisibility(View.VISIBLE);
    }

    @Override
    public void dismissProgress() {
        progressForumComment.setVisibility(View.GONE);
    }

    @Override
    public void setData(String imagePath, String title, String shortDescription, String description, int commentCount) {
        this.mTitle = title;
        if (mFragmentForumDetail != null) {
            mFragmentForumDetail.setupContent(imagePath, title,
                    shortDescription, description, commentCount);
        }
    }

    @Override
    public void setCommentCount(int commentCount) {
        if (mFragmentForumDetail != null) {
            mFragmentForumDetail.setupCommentCount(commentCount);
        }
    }

    /*
     * Fragment buttons on click
     */
    @Override
    public void onClick(View v) {
        switch ((int) v.getTag()) {
            case 0:
                forumDetailContainer.setVisibility(View.GONE);
                containerForumComments.setVisibility(View.VISIBLE);
                setDefaultTitle(mTitle);
                edtComment.setFocusableInTouchMode(true);
                edtComment.requestFocus();
                KeyboardUtils.showKeyboard(ForumCommentActivity.this);
                if (recViewComments.getAdapter() != null) {
                    recViewComments.postDelayed(() ->
                            recViewComments.scrollToPosition(
                                    recViewComments.getAdapter().getItemCount() - 1), 800);
                }
                break;
            case 1:
                forumDetailContainer.setVisibility(View.GONE);
                containerForumComments.setVisibility(View.VISIBLE);
                setDefaultTitle(mTitle);
                KeyboardUtils.hideKeyboard(ForumCommentActivity.this);
                if (recViewComments.getAdapter() != null) {
                    recViewComments.scrollToPosition(0);
                }
                break;
        }
    }

    /*
     * Fragment comment back on click
     */
    @Override
    public void onClickBack() {
        viewMoreContainer.setVisibility(View.GONE);
        mFragmentMoreComment = null;
        mForumCommentPresenter.onReply(null);
        KeyboardUtils.hideKeyboard(ForumCommentActivity.this);
    }

    @Override
    public void onClickReply(Comments comment) {
        mForumCommentPresenter.onReply(comment);
    }
}
