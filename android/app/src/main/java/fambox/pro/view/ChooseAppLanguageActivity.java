package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_CHANGE_LANGUAGE;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.ChooseAppLanguagePresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.AdapterChooseLanguage;

public class ChooseAppLanguageActivity extends BaseActivity implements ChooseAppLanguageContract.View {

    private ChooseAppLanguagePresenter mChooseAppLanguagePresenter;
    private AdapterChooseLanguage adapterChooseLanguages;
    private String countryName;
    private boolean isChangeLanguage;

    @BindView(R.id.recViewLanguages)
    RecyclerView recViewLanguages;
    @BindView(R.id.progressView)
    LinearLayout progressView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        Bundle bundle = getIntent().getExtras();
        mChooseAppLanguagePresenter = new ChooseAppLanguagePresenter();
        mChooseAppLanguagePresenter.attachView(this);
        mChooseAppLanguagePresenter.viewIsReady();
        mChooseAppLanguagePresenter.initBundle(bundle);
        if (bundle != null) {
            countryName = bundle.getString("key_country_name", "");
        }
        if (isChangeLanguage) {
            addAppBar(null, false,
                    true, false, getResources().getString(R.string.language_title_key), true);
        } else {
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
            addAppBar(null, true,
                    true, true, countryName, false);
        }
    }

    @Override
    protected int getLayout() {
        if (getIntent().getExtras() != null) {
            isChangeLanguage = getIntent().getExtras().getBoolean(KEY_CHANGE_LANGUAGE, false);
            if (isChangeLanguage) {
                return R.layout.activity_choose_app_language_settings;
            }
        }
        return R.layout.activity_choose_app_language;
    }

    @Override
    public void configRecViewLanguages(List<CountriesLanguagesResponseBody> languagesResponseBodyList) {
        adapterChooseLanguages = new AdapterChooseLanguage(getContext(), languagesResponseBodyList,
                getLocale(), isChangeLanguage);
        LinearLayoutManager linearLayoutManager =
                new LinearLayoutManager(getContext(), RecyclerView.VERTICAL, false);
        if (!isChangeLanguage) {
            linearLayoutManager.setStackFromEnd(true);
        }
        recViewLanguages.setLayoutManager(linearLayoutManager);
        recViewLanguages.setAdapter(adapterChooseLanguages);
        recViewLanguages.smoothScrollToPosition(0);
    }

    @OnClick(R.id.containerNext)
    void onClickNext() {
        saveLanguage();
    }

    public void saveLanguage() {
        if (returnLanguageCode() != null) {
            mChooseAppLanguagePresenter.changeLanguage(returnLanguageCode(), isChangedCountry());
        } else {
            showSuccessMessage(getResources().getString(R.string.please_select_language));
        }
    }

    @Override
    public void openSaveCountryDialog() {
        AlertDialog.Builder ad = new AlertDialog.Builder(this);
        ad.setMessage(R.string.confirm_change_country);
        ad.setPositiveButton(R.string.yes, (dialogInterface, i) -> {
            mChooseAppLanguagePresenter.saveChangedCountryAndLanguage(returnLanguageCode());
        });
        ad.setNegativeButton(R.string.cancel, (dialogInterface, i) -> dialogInterface.dismiss());
        ad.create().show();
    }

    @Override
    public void back() {
        nextActivity(this, MainActivity.class);
        finishAffinity();
    }

    @Override
    public void changeActivity(Class<?> clazz, boolean isFinish) {
        if (adapterChooseLanguages != null) {
            Bundle bundle = new Bundle();
            bundle.putBoolean("is_opened_from_menu", false);
            nextActivity(this, clazz, bundle);
        }
        if (isFinish) {
            finishAffinity();
        }
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mChooseAppLanguagePresenter != null) {
            mChooseAppLanguagePresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mChooseAppLanguagePresenter != null) {
            mChooseAppLanguagePresenter.destroy();
        }
    }

    @Override
    public void showProgress() {
        runOnUiThread(() -> progressView.setVisibility(View.VISIBLE));
    }

    @Override
    public void dismissProgress() {
        runOnUiThread(() -> progressView.setVisibility(View.GONE));
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    private String returnLanguageCode() {
        return adapterChooseLanguages != null
                ? adapterChooseLanguages.getLanguageCode()
                : "en";
    }
}
