package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_IS_CONSULTANT_CONDITION;
import static fambox.pro.Constants.Key.KEY_IS_PRIVACY_POLICY;
import static fambox.pro.Constants.Key.KEY_IS_TERM;

import android.os.Bundle;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;

public class LegalActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false,
                true, false,
                getResources().getString(R.string.title_legal), true);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_legal;
    }

    @OnClick(R.id.containerTermsCondition)
    void clickTermsConditions() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_TERM, true);
        nextActivity(this, WebViewActivity.class, bundle);
    }

    @OnClick(R.id.containerPrivacyProfile)
    void clickPrivacyProfile() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_PRIVACY_POLICY, true);
        nextActivity(this, WebViewActivity.class, bundle);
    }

    @OnClick(R.id.containerTermsForConsultant)
    void clickTermsForConsultant() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_CONSULTANT_CONDITION, true);
        nextActivity(this, WebViewActivity.class, bundle);
    }
}