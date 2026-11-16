package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;
import static fambox.pro.Constants.Key.KEY_IS_PRIVACY_POLICY;
import static fambox.pro.Constants.Key.KEY_REGISTRATION_FORM;
import static fambox.pro.utils.applanguage.AppLanguage.LANGUAGE_PREFERENCES_KAY;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.DisplayMetrics;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

import androidx.appcompat.widget.LinearLayoutCompat;
import androidx.core.content.ContextCompat;
import androidx.webkit.WebSettingsCompat;
import androidx.webkit.WebViewFeature;

import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.enums.Types;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.WebViewPresenter;
import fambox.pro.utils.LollipopFixedWebView;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;

public class WebViewActivity extends BaseActivity implements WebViewContract.View {


    private WebViewPresenter mWebViewPresenter;

    @BindView(R.id.webView)
    LollipopFixedWebView webView;
    @BindView(R.id.btnSubmit)
    Button btnSubmit;
    @BindView(R.id.bottom_layout)
    LinearLayoutCompat bottomLayout;
    @BindView(R.id.terms_check_box)
    CheckBox checkBox;
    @BindView(R.id.agreeTextView)
    TextView agreeTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        ButterKnife.bind(this);
        changeLang(getSharedPreferences("locale", Activity.MODE_PRIVATE).getString(LANGUAGE_PREFERENCES_KAY, "en"));
        mWebViewPresenter = new WebViewPresenter();
        mWebViewPresenter.attachView(this);
        mWebViewPresenter.viewIsReady();
        RegistrationBody registrationBody = (RegistrationBody) getIntent().getSerializableExtra(KEY_REGISTRATION_FORM);
        mWebViewPresenter.setBundle(getIntent().getExtras(), getCountryCode(),
                LocaleHelper.getLanguage(getContext()), registrationBody);
        checkBox.setOnCheckedChangeListener((compoundButton, b) -> updateButtonStyles(b));
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                if (registrationBody != null && mWebViewPresenter.isTerms()) {
                    bottomLayout.setVisibility(View.VISIBLE);
                }
            }
        });
        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
        int nightModeFlags =
                getContext().getResources().getConfiguration().uiMode &
                        Configuration.UI_MODE_NIGHT_MASK;
        if (WebViewFeature.isFeatureSupported(WebViewFeature.FORCE_DARK)) {
            WebSettingsCompat.setForceDark(webView.getSettings(),
                    (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES) ? WebSettingsCompat.FORCE_DARK_ON : WebSettingsCompat.FORCE_DARK_AUTO);
        }
        webView.setBackgroundColor(Color.TRANSPARENT);
        btnSubmit.setOnClickListener(view -> mWebViewPresenter.registerUser());
        String termsAndConditions = getResources().getString(R.string.terms_and_conditions_agreement_text);
        String privacyPolicy = getResources().getString(R.string.privacy_policy_txt);
        SpannableString ss = new SpannableString(termsAndConditions);
        ClickableSpan clickableSpan = new ClickableSpan() {
            @Override
            public void onClick(View textView) {
                Intent intent = new Intent(WebViewActivity.this, WebViewActivity.class);
                intent.putExtra(KEY_IS_PRIVACY_POLICY, true);
                intent.putExtra(KEY_REGISTRATION_FORM, registrationBody);
                startActivity(intent);
            }

            @Override
            public void updateDrawState(TextPaint ds) {
                super.updateDrawState(ds);
                ds.setUnderlineText(true);
            }
        };
        int startIndex = termsAndConditions.indexOf(privacyPolicy);
        ss.setSpan(clickableSpan, startIndex, startIndex + privacyPolicy.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        agreeTextView.setText(ss);
        agreeTextView.setMovementMethod(LinkMovementMethod.getInstance());
        agreeTextView.setHighlightColor(Color.TRANSPARENT);

    }

    private void updateButtonStyles(boolean isTermsAgreed) {
        if (isTermsAgreed) {
            btnSubmit.setEnabled(true);
            btnSubmit.setBackground(ContextCompat.getDrawable(getContext(), R.drawable.button_border_fill));
            btnSubmit.setTextColor(getResources().getColor(R.color.button_text_color));
        } else {
            btnSubmit.setEnabled(false);
            btnSubmit.setBackground(ContextCompat.getDrawable(getContext(), R.drawable.button_border_fill_disabled));
            btnSubmit.setTextColor(getResources().getColor(R.color.chunkBackgroundColor));
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_terms_and_conditions;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mWebViewPresenter != null) {
            mWebViewPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mWebViewPresenter != null) {
            mWebViewPresenter.destroy();
        }
    }

    @Override
    public void configWebView(String htmlText) {
        webView.loadDataWithBaseURL(null, htmlText, "text/html", "utf-8", null);
    }

    @Override
    public void setIsTermsAndCondition(String title) {
        addAppBar(null, false, true, false,
                title, checkLogin());
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void goVerifyRegistration() {
        nextActivity(this, VerificationActivity.class);
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    public void changeLang(String lang) {
        Locale myLocale = new Locale(lang);
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        android.content.res.Configuration conf = res.getConfiguration();
        conf.setLocale(myLocale);
        res.updateConfiguration(conf, dm);
    }
}
