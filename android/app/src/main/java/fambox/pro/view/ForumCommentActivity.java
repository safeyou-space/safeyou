package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.fambox.chatkit.messages.MessageInput;
import com.fambox.chatkit.messages.RecyclerScrollMoreListener;
import com.fambox.mention.tokenization.impl.WordTokenizer;
import com.fambox.mention.tokenization.impl.WordTokenizerConfig;
import com.fxn.pix.Options;
import com.fxn.pix.Pix;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.network.model.forum.UserRateResponseBody;
import fambox.pro.presenter.ForumCommentPresenter;
import fambox.pro.privatechat.view.ChatActivity;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.AdapterForumComment;
import fambox.pro.view.fragment.FragmentForumDetail;
import fambox.pro.view.fragment.FragmentMoreComment;
import fambox.pro.view.fragment.FragmentRatingBar;

public class ForumCommentActivity extends BaseActivity implements ForumCommentContract.View, View.OnClickListener,
        FragmentMoreComment.ClickReplyListener, FragmentMoreComment.OnCommentBackListener {

    private ForumCommentPresenter mForumCommentPresenter;
    private AdapterForumComment mAdapterForumComment;
    private FragmentForumDetail mFragmentForumDetail;
    private FragmentRatingBar mFragmentRatingBar;
    private FragmentMoreComment mFragmentMoreComment;
    private final List<File> files = new ArrayList<>();
    private String mTitle;
    private ArrayList<String> returnValue = new ArrayList<>();
    private FragmentMoreComment.CommentUpdateListener commentUpdateListener;
    private boolean isEdit;
    private long editedCommentId;

    @BindView(R.id.recViewComments)
    RecyclerView recViewComments;
    @BindView(R.id.edtComment)
    MessageInput edtComment;
    @BindView(R.id.viewMoreContainer)
    FrameLayout viewMoreContainer;
    @BindView(R.id.forumDetailContainer)
    FrameLayout forumDetailContainer;
    @BindView(R.id.ratingContainer)
    FrameLayout ratingContainer;
    @BindView(R.id.containerForumComments)
    RelativeLayout containerForumComments;
    @BindView(R.id.progressForumComment)
    LinearLayout progressForumComment;
    @BindView(R.id.seeNewComment)
    TextView seeNewComment;
    private boolean isRated;
    private boolean isFromBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        addAppBar(getString(R.string.forums_title_key), false, true, false, null, true);
        ButterKnife.bind(this);
        mForumCommentPresenter = new ForumCommentPresenter();
        mForumCommentPresenter.attachView(this);
        mForumCommentPresenter.checkPin(getIntent().getExtras());
        mForumCommentPresenter.viewIsReady();
        mTitle = getString(R.string.forums_title_key);
        edtComment.getInputEditText().setHint(getString(R.string.type_a_comment));
        edtComment.getInputEditText().setTokenizer(new WordTokenizer(new WordTokenizerConfig.Builder().build()));
        edtComment.setRecordAudioButtonVisibility(false);
        edtComment.setInputListener(input -> {
            if (mAdapterForumComment != null) {
                if (mFragmentMoreComment == null) {
                    mAdapterForumComment.setTypedFromUserSide(true);
                }
            }
            mForumCommentPresenter.setCommentMassage(input != null ? input.toString() : null,
                    getLocale(), files, isEdit, editedCommentId);
            files.clear();
            returnValue.clear();
            isEdit = false;
            editedCommentId = 0;
            return true;
        });
        edtComment.setAttachmentsListener(new MessageInput.AttachmentsListener() {
            @Override
            public void onAddAttachments() {
                Intent intent = new Intent();
                intent.setType("image/*");
                intent.setAction(Intent.ACTION_GET_CONTENT);
                startActivityForResult(Intent.createChooser(intent, "Select Picture"), 151);
                files.clear();
                returnValue.clear();
            }

            @Override
            public void onAddRecordAudio() {

            }

            @Override
            public void onCancelRecordAudio() {

            }

            @Override
            public void onAddTakePhoto() {
                Options options = Options.init()
                        .setRequestCode(101) //Request code for activity results
                        .setCount(1) //Number of images to restict selection count
                        .setFrontfacing(false) //Front Facing camera on start
                        .setPreSelectedUrls(returnValue) //Pre selected Image Urls
                        .setSpanCount(4) //Span count for gallery min 1 & max 5
                        .setMode(Options.Mode.Picture) //Option to select only pictures or videos or both
                        .setVideoDurationLimitinSeconds(0) //Duration for video recording
                        .setScreenOrientation(Options.SCREEN_ORIENTATION_PORTRAIT) //Orientaion
                        .setPath("/FamboxChat/images"); //Custom Path For media Storage

                Pix.start(ForumCommentActivity.this, options);
                files.clear();
                returnValue.clear();
            }

            @Override
            public void onClickClose() {

            }

            @Override
            public void onRemoveImage() {
                returnValue.clear();
                files.clear();
            }
        });
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_forum_comment;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK && requestCode == 101) {
            if (data != null) {
                returnValue = data.getStringArrayListExtra(Pix.IMAGE_RESULTS);
                for (String s : returnValue) {
                    files.add(new File(s));
                    edtComment.setSelectedImage(new MessageInput.SelectImageContent(new File(s)));
                }
            }
        }
        if (requestCode == 151 && resultCode == RESULT_OK && data != null) {
            try {
                InputStream inputStream = getContentResolver().openInputStream(data.getData());
                File file = new File(getCacheDir(), "image_to_upload.jpg");
                ChatActivity.Companion.copyInputStreamToFile(inputStream, file);
                files.add(file);
                edtComment.setSelectedImage(new MessageInput.SelectImageContent(file));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mForumCommentPresenter != null) {
            mForumCommentPresenter.initBundle(getIntent().getExtras(), getLocale());
        }
    }

    @Override
    public void setupForumDetail() {
        mFragmentForumDetail = FragmentForumDetail.start(this, R.id.forumDetailContainer);
        mFragmentRatingBar = FragmentRatingBar.start(this, R.id.ratingContainer);
        ratingContainer.setVisibility(View.GONE);
    }

    @Override
    public void initRecView(List<Comments> comments, List<Comments> replyComments) {
        mAdapterForumComment = new AdapterForumComment(this, new ArrayList<>(), replyComments);
        mAdapterForumComment.setClickMoreListener(new AdapterForumComment.ClickCommentListener() {
            @Override
            public void onClickComment(Comments comment) {
                recViewComments.setVisibility(View.GONE);
                viewMoreContainer.setVisibility(View.VISIBLE);
                Bundle bundle = new Bundle();
                bundle.putParcelable("parent_message", comment);
                mFragmentMoreComment = FragmentMoreComment.start(ForumCommentActivity.this, bundle);
                mFragmentMoreComment.addReplies(comment.getMessageReplies());
            }

            @Override
            public void onDeleteComment(Comments comment) {
                if (mForumCommentPresenter != null) {
                    mForumCommentPresenter.deleteMessage(comment);
                }
            }

            @Override
            public void onEditComment(Comments comment) {
                edtComment.getInputEditText().setText(comment.getMessage());
                editedCommentId = comment.getId();
                isEdit = true;
            }
        });

        mAdapterForumComment.setClickCommentListener(new AdapterForumComment.ClickReplyListener() {
            @Override
            public void onClickReply(Comments comment, Comments replyComment) {
                setReplyContent(false, comment, replyComment);
            }

            @Override
            public void onClickPrivateMessage(Comments comments) {
                if (Connectivity.isConnected(ForumCommentActivity.this)) {
                    mForumCommentPresenter.leaveRoom();
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
                    nextActivity(ForumCommentActivity.this, ChatActivity.class, bundle);
                }
            }

            @Override
            public void onClickBlockUser(Comments comments) {
                AlertDialog.Builder ad = new AlertDialog.Builder(getContext());
                ad.setMessage(getString(R.string.want_block_user_text_key));
                ad.setPositiveButton(getString(R.string.confirm), (dialogInterface, i)
                        -> mForumCommentPresenter.onClickBlockUser(comments));
                ad.setNegativeButton(getString(R.string.cancel), (dialogInterface, i) -> dialogInterface.dismiss());
                ad.create().show();
            }

            @Override
            public void onClickLike(Comments comments, int likeType) {
                mForumCommentPresenter.onClickLike(comments, likeType);
            }

            @Override
            public void onNewComment(int count) {
                seeNewComment.setVisibility(View.VISIBLE);
            }
        });

        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, true);
        recViewComments.setLayoutManager(verticalLayoutManager);
        recViewComments.setAdapter(mAdapterForumComment);

        recViewComments.addOnScrollListener(new RecyclerScrollMoreListener(verticalLayoutManager,
                new RecyclerScrollMoreListener.OnLoadMoreListener() {
                    @Override
                    public void onLoadMore(int page, int total) {
                        if (mForumCommentPresenter != null) {
                            mForumCommentPresenter.onNextPage(page, total);
                        }
                    }

                    @Override
                    public int getMessagesCount() {
                        return mAdapterForumComment.getItemCount();
                    }
                }));
    }

    @Override
    public void addNewMessages(List<Comments> comments, long replyIdFromNotification) {
        mAdapterForumComment.addMessages(comments);
    }

    @Override
    public void deleteComment(long messageId) {
        if (mAdapterForumComment != null) {
            mAdapterForumComment.deleteComment(messageId);
        }
    }

    @Override
    public void editComment(Comments comment) {
        if (mAdapterForumComment != null) {
            mAdapterForumComment.editComment(comment);
        }

        if (commentUpdateListener != null) {
            commentUpdateListener.onUpdate(comment);
        }
    }

    @OnClick(R.id.seeNewComment)
    void onClickSeeNewComment() {
        recViewComments.scrollToPosition(0);
        seeNewComment.setVisibility(View.GONE);
    }

    @Override
    public void addNewMessage(Comments comment) {
        mAdapterForumComment.addMessage(comment, recViewComments);
        if (mFragmentMoreComment != null) {
            if (comment.getReply_id() > 0) {
                mFragmentMoreComment.addNewReplies(comment);
            }
        }
    }

    @Override
    public void goPinActivity(Bundle bundle) {
        nextActivity(this, PassKeypadActivity.class, bundle);
        finish();
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
            mForumCommentPresenter.onStop();
            mForumCommentPresenter.destroy();
        }
    }

    @Override
    public void onBackPressed() {
        if (viewMoreContainer.getVisibility() == View.VISIBLE) {
            recViewComments.setVisibility(View.VISIBLE);
            viewMoreContainer.setVisibility(View.GONE);
            mFragmentMoreComment = null;
            forumDetailContainer.setVisibility(View.VISIBLE);
            containerForumComments.setVisibility(View.GONE);
            setDefaultTitle(getString(R.string.forums_title_key));
        } else if (ratingContainer.getVisibility() == View.VISIBLE) {
            if (mForumCommentPresenter != null && isRated) {
                mForumCommentPresenter.initBundle(getIntent().getExtras(), getLocale());
            }
            forumDetailContainer.setVisibility(View.VISIBLE);
            containerForumComments.setVisibility(View.GONE);
            ratingContainer.setVisibility(View.GONE);
            setDefaultTitle(getString(R.string.forums_title_key));
        } else if (forumDetailContainer.getVisibility() == View.GONE) {
            forumDetailContainer.setVisibility(View.VISIBLE);
            containerForumComments.setVisibility(View.GONE);
            setDefaultTitle(getString(R.string.forums_title_key));
        } else {
            isFromBack = true;
            mForumCommentPresenter.leaveRoom();
            showProgress();
        }
        mForumCommentPresenter.onReply(null);
        KeyboardUtils.hideKeyboard(ForumCommentActivity.this);
    }

    @Override
    public void onLeaveRoomSuccess() {
        if (isFromBack) {
            Intent intent = new Intent();
            intent.putExtra("isRated", isRated);
            setResult(RESULT_OK, intent);
            dismissProgress();
            finish();
        }
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
        runOnUiThread(() -> progressForumComment.setVisibility(View.VISIBLE));
    }

    @Override
    public void removeBlockedUser(Comments comments) {
        Toast.makeText(getContext(), String.format(getString(R.string.successfully_blocked), comments.getName()), Toast.LENGTH_LONG).show();
        mAdapterForumComment.removeBlockedUser(comments.getUser_id());
    }

    @Override
    public void dismissProgress() {
        runOnUiThread(() -> progressForumComment.setVisibility(View.GONE));
    }

    @Override
    public void setData(String imagePath, String title, String shortDescription, String description,
                        int commentCount, String author, Date createdAt, Double rate, int ratesCount,
                        UserRateResponseBody userRate, long forumId) {
        this.mTitle = title;
        if (mFragmentForumDetail != null) {
            mFragmentForumDetail.setupContent(imagePath, title,
                    shortDescription, description, commentCount, userRate == null ? 0 : userRate.getRate(), ratesCount, forumId);

            mFragmentRatingBar.setupContent(imagePath, title, author, createdAt, userRate, forumId, false);
        }
    }

    @Override
    public void setCommentCount(int commentCount) {
        if (mFragmentForumDetail != null) {
            mFragmentForumDetail.setupCommentCount(commentCount);
        }
    }

    @Override
    public void setReplyContent(boolean fromNotification, Comments comment, Comments replyComment) {
        if (fromNotification) {
            goneForumDetail();
        }
        recViewComments.setVisibility(View.GONE);
        viewMoreContainer.setVisibility(View.VISIBLE);
        Bundle bundle = new Bundle();
        bundle.putParcelable("parent_message", comment);
        if (replyComment != null) {
            bundle.putParcelable("child_message", replyComment);
        }
        mFragmentMoreComment = FragmentMoreComment.start(ForumCommentActivity.this, bundle);
        mFragmentMoreComment.addReplies(comment.getMessageReplies());
    }

    @Override
    public void setPageTitle(String title) {
        setDefaultTitle(title);
    }

    @Override
    public void goneForumDetail() {
        forumDetailContainer.setVisibility(View.GONE);
        containerForumComments.setVisibility(View.VISIBLE);
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
                ratingContainer.setVisibility(View.GONE);
                setDefaultTitle(mTitle);
                edtComment.setFocusableInTouchMode(true);
                edtComment.requestFocus();
                KeyboardUtils.showKeyboard(ForumCommentActivity.this);
                break;
            case 1:
                forumDetailContainer.setVisibility(View.GONE);
                containerForumComments.setVisibility(View.VISIBLE);
                ratingContainer.setVisibility(View.GONE);
                setDefaultTitle(mTitle);
                KeyboardUtils.hideKeyboard(ForumCommentActivity.this);
                break;
            case 2:
                setDefaultTitle(getString(R.string.my_review));
                forumDetailContainer.setVisibility(View.GONE);
                containerForumComments.setVisibility(View.GONE);
                ratingContainer.setVisibility(View.VISIBLE);
                mFragmentRatingBar.clearData();
                break;
            case 3:
                forumDetailContainer.setVisibility(View.VISIBLE);
                containerForumComments.setVisibility(View.GONE);
                ratingContainer.setVisibility(View.GONE);
                setDefaultTitle(getString(R.string.forums_title_key));
                break;
        }
    }

    /*
     * Fragment comment back on click
     */
    @Override
    public void onClickBack() {
        recViewComments.setVisibility(View.VISIBLE);
        viewMoreContainer.setVisibility(View.GONE);
        mFragmentMoreComment = null;
    }

    @Override
    public void onClickReply(Comments comment) {
        mForumCommentPresenter.onReply(comment);
    }

    @Override
    public void onClickLike(Comments comments, int likeType) {
        mForumCommentPresenter.onClickLike(comments, likeType);
    }

    @Override
    public void onClickDelete(Comments comment) {
        if (mForumCommentPresenter != null) {
            mForumCommentPresenter.deleteMessage(comment);
        }
    }

    @Override
    public void onEditComment(Comments comment,
                              FragmentMoreComment.CommentUpdateListener commentUpdateListener) {
        this.commentUpdateListener = commentUpdateListener;
        edtComment.getInputEditText().setText(comment.getMessage());
        editedCommentId = comment.getId();
        isEdit = true;
    }

    public void setIsRated(boolean b) {
        isRated = b;
    }
}
