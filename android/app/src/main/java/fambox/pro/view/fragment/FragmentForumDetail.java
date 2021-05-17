package fambox.pro.view.fragment;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.bumptech.glide.Glide;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.utils.LollipopFixedWebView;

public class FragmentForumDetail extends BaseFragment {

    private FragmentActivity mContext;
    private View.OnClickListener mOnClickListener;

    @BindView(R.id.imgForumDetail)
    ImageView imgForumDetail;
    @BindView(R.id.txtForumTitle)
    TextView txtForumTitle;
    @BindView(R.id.txtForumShortDescription)
    TextView txtForumShortDescription;
    //    @BindView(R.id.txtForumDescription)
//    TextView txtForumDescription;
    @BindView(R.id.webViewForumDescription)
    LollipopFixedWebView webViewForumDescription;
    @BindView(R.id.txtComments)
    TextView txtComments;

    public static FragmentForumDetail start(FragmentActivity context, int containerId) {
        FragmentForumDetail fragmentForumDetail = new FragmentForumDetail();
        FragmentManager fragmentManager = context.getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.add(containerId, fragmentForumDetail).commit();
        return fragmentForumDetail;
    }

    @Override
    protected View provideYourFragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getActivity() != null) {
            mContext = getActivity();
        }
        return inflater.inflate(R.layout.fragment_forum_detail, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof View.OnClickListener) {
            mOnClickListener = (View.OnClickListener) context;
        }
    }

    @OnClick(R.id.btnComment)
    void onClickBtnComment(View view) {
        onClick(view, 0);
    }

    @OnClick(R.id.txtComments)
    void onClickTxtComments(View view) {
        onClick(view, 1);
    }

    public void setupContent(String imagePath, String title, String shortDescription, String description, int commentCount) {
        new Handler(Looper.getMainLooper()).post(() -> {
            Glide.with(mContext).load(Constants.BASE_URL + imagePath).into(imgForumDetail);
            txtForumTitle.setText(title);
            txtForumShortDescription.setText(shortDescription);
            webViewForumDescription.loadDataWithBaseURL(null, description, "text/html", "utf-8", null);
//            txtForumDescription.setText(description);
            txtComments.setText(mContext.getResources().getString(R.string.count_comments, commentCount));
        });
    }

    public void setupCommentCount(int commentCount) {
        new Handler(Looper.getMainLooper()).post(() -> {
            txtComments.setText(mContext.getResources().getString(R.string.count_comments, commentCount));
        });
    }

    private void onClick(View view, int type) {
        if (mOnClickListener != null) {
            view.setTag(type);
            mOnClickListener.onClick(view);
        }
    }
}