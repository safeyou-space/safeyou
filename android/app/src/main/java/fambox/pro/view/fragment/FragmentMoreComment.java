package fambox.pro.view.fragment;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.fragment.FragmentMoreCommentPresenter;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.AdapterForumCommentViewMore;

import static fambox.pro.Constants.BASE_URL;

public class FragmentMoreComment extends BaseFragment implements FragmentMoreCommentContract.View {

    private FragmentActivity mContext;
    private FragmentMoreCommentPresenter mFragmentMoreCommentPresenter;
    private AdapterForumCommentViewMore mAdapterForumCommentViewMore;
    private List<Comments> mReplies;
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
    protected View provideYourFragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
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

    @Override
    public void onClickParentMessage(Comments comment) {
        Log.i("tagik", "onClickParentMessage: " + comment);
        KeyboardUtils.showKeyboard(mContext);
        mClickReplyListener.onClickReply(comment);
    }

    @Override
    public void onReplyChildMessage(Comments childComment) {
        mClickReplyListener.onClickReply(childComment);
    }

    @Override
    public void setUpParentMessage(String userImage, String userName,
                                   String userProfession, String userComment, String data,
                                   int userType, boolean isMy) {
        containerMessages.setBackgroundResource(isMy ? R.drawable.comment_frame : R.drawable.comment_frame_white);
        if (userImage != null) {
            Glide.with(mContext).load(BASE_URL.concat(userImage))
                    .into(imgCommentUser);
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
        mAdapterForumCommentViewMore = new AdapterForumCommentViewMore(mContext, replies);

        mAdapterForumCommentViewMore.setClickCommentListener(comment -> {
            mClickReplyListener.onClickReply(comment);
            KeyboardUtils.showKeyboard(mContext);
        });

        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewChildComment.setLayoutManager(verticalLayoutManager);
        recViewChildComment.setAdapter(mAdapterForumCommentViewMore);
    }

    public void addReplies(List<Comments> replies) {
        if (mReplies != null) {
            mReplies.clear();
        }
        this.mReplies = replies;
        if (mFragmentMoreCommentPresenter != null) {
            mFragmentMoreCommentPresenter.setupReplyList(replies);
        }
    }

    public void addNewReplies(Comments reply) {
        if (mAdapterForumCommentViewMore != null) {
            mAdapterForumCommentViewMore.addMessage(reply, recViewChildComment);
        }
    }

    @Override
    public void showProgress() {

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

    public interface ClickReplyListener {
        void onClickReply(Comments comment);
    }

    public interface OnCommentBackListener {
        void onClickBack();
    }
}
