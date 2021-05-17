package fambox.pro.view;

import android.content.Context;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.TermsAndConditionsPresenter;
import fambox.pro.utils.LollipopFixedWebView;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;

public class TermsAndConditionsActivity extends BaseActivity implements TermsAndConditionsContract.View {

    private TermsAndConditionsPresenter mTermsAndConditionsPresenter;

    @BindView(R.id.webView)
    LollipopFixedWebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        ButterKnife.bind(this);
        mTermsAndConditionsPresenter = new TermsAndConditionsPresenter();
        mTermsAndConditionsPresenter.attachView(this);
        mTermsAndConditionsPresenter.viewIsReady();
        mTermsAndConditionsPresenter.setBundle(getIntent().getExtras(), getCountryCode(), getLocale());
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_terms_and_conditions;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mTermsAndConditionsPresenter != null) {
            mTermsAndConditionsPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mTermsAndConditionsPresenter != null) {
            mTermsAndConditionsPresenter.destroy();
        }
    }

    @Override
    public void configWebView(String htmlText) {
//        webView.loadData(htmlText, "text/html", "UTF-8");
        webView.loadDataWithBaseURL(null, htmlText, "text/html", "utf-8", null);
    }

    @Override
    public void setIsTermsAndCondition(boolean isTermsAndCondition) {
        addAppBar(null, false, true, false,
                isTermsAndCondition ? null : getResources().getString(R.string.about_us), !isTermsAndCondition);
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
}
