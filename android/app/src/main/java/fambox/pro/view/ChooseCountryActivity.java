package fambox.pro.view;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.widget.TextView;

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
import fambox.pro.presenter.ChooseCountryPresenter;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.AdapterChooseCountries;
import fambox.pro.view.dialog.InfoDialog;

import static fambox.pro.Constants.Key.KEY_CHANGE_COUNTRY;
import static fambox.pro.Constants.Key.KEY_CHANGE_LANGUAGE;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE_BUNDLE;

public class ChooseCountryActivity extends BaseActivity implements ChooseCountryContract.View {

    private ChooseCountryPresenter mChooseCountryPresenter;
    private AdapterChooseCountries adapterChooseCountries;
    private boolean isChangeCountry;
    @BindView(R.id.recViewCountries)
    RecyclerView recViewCountries;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        mChooseCountryPresenter = new ChooseCountryPresenter();
        mChooseCountryPresenter.attachView(this);
        mChooseCountryPresenter.viewIsReady();
        mChooseCountryPresenter.initBundle(getIntent().getExtras());
        if (isChangeCountry) {
            addAppBar(null, false,
                    true, false, getResources().getString(R.string.country), true);
        } else {
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
            addAppBar(null, true,
                    false, true, null, false);
        }
    }

    @Override
    protected int getLayout() {
        if (getIntent().getExtras() != null) {
            isChangeCountry = getIntent().getExtras().getBoolean(KEY_CHANGE_COUNTRY, false);
            if (isChangeCountry) {
                return R.layout.activity_choose_country_settings;
            }
        }
        return R.layout.activity_choose_country;
    }

    @Override
    public void configRecViewCountries(List<CountriesLanguagesResponseBody> countriesResponseBodyList) {
        adapterChooseCountries = new AdapterChooseCountries(getContext(), countriesResponseBodyList, isChangeCountry);
        LinearLayoutManager linearLayoutManager =
                new LinearLayoutManager(getContext(), RecyclerView.VERTICAL, false);
        recViewCountries.setLayoutManager(linearLayoutManager);
        recViewCountries.setAdapter(adapterChooseCountries);
    }

    @OnClick(R.id.containerNext)
    void onClickNext() {
        saveCountryCode();
    }

    public void saveCountryCode() {
        mChooseCountryPresenter.saveCountryCode(returnCountryCode());
    }

    @Override
    public void goChooseLanguageActivity() {
        Bundle bundle = new Bundle();
        bundle.putString("key_country_name", adapterChooseCountries != null
                ? adapterChooseCountries.getCountryName()
                : "");
        if (isChangeCountry) {
            bundle.putString(KEY_COUNTRY_CODE_BUNDLE, returnCountryCode());
            bundle.putBoolean(KEY_CHANGE_LANGUAGE, true);
        }
        if (adapterChooseCountries != null) {
            nextActivity(this, ChooseAppLanguageActivity.class, bundle);
        }
    }

    private String returnCountryCode() {
        return adapterChooseCountries != null
                ? adapterChooseCountries.getCountryCode()
                : "";
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mChooseCountryPresenter != null) {
            mChooseCountryPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mChooseCountryPresenter != null) {
            mChooseCountryPresenter.destroy();
        }
    }
}
