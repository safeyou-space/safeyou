package fambox.pro.view.fragment;

import static fambox.pro.Constants.ANDROID_PACKAGE_NAME;
import static fambox.pro.Constants.DOMAIN_URL;
import static fambox.pro.Constants.IOS_APP_STORE_ID;
import static fambox.pro.Constants.IOS_PACKAGE_NAME;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;
import static fambox.pro.Constants.SAFE_YOU_URL_STRING_FORMAT;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.LinearLayoutCompat;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.webkit.WebSettingsCompat;
import androidx.webkit.WebViewFeature;

import com.bumptech.glide.Glide;
import com.google.firebase.dynamiclinks.DynamicLink;
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks;

import java.util.Locale;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.utils.LollipopFixedWebView;
import fambox.pro.utils.Utils;

public class FragmentForumDetail extends BaseFragment {

    private FragmentActivity mContext;
    private View.OnClickListener mOnClickListener;

    @BindView(R.id.imgForumDetail)
    ImageView imgForumDetail;
    @BindView(R.id.txtForumTitle)
    TextView txtForumTitle;
    @BindView(R.id.txtForumShortDescription)
    TextView txtForumShortDescription;
    @BindView(R.id.webViewForumDescription)
    LollipopFixedWebView webViewForumDescription;
    @BindView(R.id.txtComments)
    TextView txtComments;
    @BindView(R.id.rate_bar_layout)
    LinearLayoutCompat rateBar;
    @BindView(R.id.rate_bar_layout_container)
    LinearLayoutCompat rateBarContainer;
    @BindView(R.id.rating)
    TextView rating;
    @BindView(R.id.rateCount)
    TextView rateCount;
    @BindView(R.id.rateIcon)
    ImageView rateIcon;
    @BindView(R.id.forumShare)
    ImageView forumShare;
    @BindView(R.id.progressView)
    LinearLayout progressView;
    private String countryCode = "arm";

    public static FragmentForumDetail start(FragmentActivity context, int containerId) {
        FragmentForumDetail fragmentForumDetail = new FragmentForumDetail();
        FragmentManager fragmentManager = context.getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.add(containerId, fragmentForumDetail).commit();
        return fragmentForumDetail;
    }

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
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

    public void setupContent(String imagePath, String title, String shortDescription, String description,
                             int commentCount, int rate, int ratesCount, long forumId) {
        new Handler(Looper.getMainLooper()).post(() -> {
            Glide.with(mContext).load(Constants.BASE_URL + imagePath).into(imgForumDetail);
            imgForumDetail.setContentDescription(String.format(getString(R.string.forum_image_description), title));
            txtForumTitle.setText(title);
            txtForumShortDescription.setText(Utils.convertStringToHtml(shortDescription));
            webViewForumDescription.getSettings().setJavaScriptEnabled(true);
            webViewForumDescription.setWebChromeClient(new WebChromeClient());
            webViewForumDescription.loadDataWithBaseURL(null, getHtmlData(description), "text/html", "utf-8", null);
            webViewForumDescription.setBackgroundColor(Color.TRANSPARENT);
            if (commentCount == 0) {
                txtComments.setText(String.valueOf(commentCount));
            }

            if (getActivity() != null) {
                countryCode = SafeYouApp.getPreference(getActivity())
                        .getStringValue(KEY_COUNTRY_CODE, "arm");
            }
            if (Objects.equals(countryCode, "irq")) {
                rateBar.setVisibility(View.GONE);
            } else {
                if (rate == 0) {
                    rating.setVisibility(View.GONE);
                    rateCount.setText("");
                    rateCount.setVisibility(View.INVISIBLE);
                    rateIcon.setImageResource(R.drawable.icon_like_coment_empty);
                    rateIcon.setContentDescription(getString(R.string.not_rated_icon_description));
                } else {
                    rateIcon.setContentDescription(getString(R.string.rated_count_icon_description));
                    rating.setVisibility(View.VISIBLE);
                    rateCount.setVisibility(View.INVISIBLE);
                    rateIcon.setImageResource(R.drawable.icon_licke_coment_full);
                    rating.setText(String.format(new Locale(LocaleHelper.getLanguage(getContext())), "%d/5", rate));
                    rateCount.setText("");
                }
                rateBar.setVisibility(View.VISIBLE);
                rateBarContainer.setBackground(ContextCompat.getDrawable(getContext(), R.drawable.rate_bar_background));
                rateCount.setTextColor(getResources().getColor(R.color.check_icon_color));
                rating.setTextColor(getResources().getColor(R.color.check_icon_color));
                rateBar.setOnClickListener(view -> {
                    onClick(view, 2);
                });
            }
            forumShare.setOnClickListener(view -> {
                try {
                    progressView.setVisibility(View.VISIBLE);

                    FirebaseDynamicLinks.getInstance().createDynamicLink()
                            .setLink(Uri.parse(String.format(Locale.getDefault(), SAFE_YOU_URL_STRING_FORMAT, forumId)))
                            .setDomainUriPrefix(DOMAIN_URL)
                            .setAndroidParameters(
                                    new DynamicLink.AndroidParameters.Builder(ANDROID_PACKAGE_NAME)
                                            .build())
                            .setIosParameters(
                                    new DynamicLink.IosParameters.Builder(IOS_PACKAGE_NAME)
                                            .setAppStoreId(IOS_APP_STORE_ID)
                                            .build())
                            .setSocialMetaTagParameters(
                                    new DynamicLink.SocialMetaTagParameters.Builder()
                                            .setTitle(mContext.getString(R.string.access_safe_you_forum))
                                            .build())
                            .buildShortDynamicLink().addOnCompleteListener(task -> {
                                progressView.setVisibility(View.GONE);
                                if (!task.isSuccessful() || task.getResult().getShortLink() == null) {
                                    return;
                                }
                                Intent shareIntent = new Intent(Intent.ACTION_SEND);
                                shareIntent.setType("text/plain");
                                String shareMessage= "";
                                shareMessage = task.getResult().getShortLink().toString();
                                shareIntent.putExtra(Intent.EXTRA_TEXT, shareMessage);
                                startActivity(Intent.createChooser(shareIntent, mContext.getString(R.string.share)));
                            });

                } catch(Exception e) {
                    e.printStackTrace();
                }
            });
            boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
            int nightModeFlags =
                    getContext().getResources().getConfiguration().uiMode &
                            Configuration.UI_MODE_NIGHT_MASK;
            if(WebViewFeature.isFeatureSupported(WebViewFeature.FORCE_DARK)) {
                WebSettingsCompat.setForceDark(webViewForumDescription.getSettings(),
                        (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES) ? WebSettingsCompat.FORCE_DARK_ON : WebSettingsCompat.FORCE_DARK_AUTO);
            }
        });
    }

    private String getHtmlData(String bodyHTML) {
        String data = "<div>" + bodyHTML + "</div>";
        String head = "<head><style>figure img{max-width: 100%; width: auto; height: auto;}</style></head>";
        return "<html>" + head + "<body>" + data + "</body></html>";
    }

    public void setupCommentCount(int commentCount) {
        new Handler(Looper.getMainLooper()).post(() -> {
            txtComments.setText(String.valueOf(commentCount));
        });
    }

    private void onClick(View view, int type) {
        if (mOnClickListener != null) {
            view.setTag(type);
            mOnClickListener.onClick(view);
        }
    }
}