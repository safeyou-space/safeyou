package fambox.pro.presenter;

import android.os.Bundle;
import android.util.Log;

import java.net.HttpURLConnection;
import java.util.List;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ChooseAppLanguageModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.applanguage.AppLanguage;
import fambox.pro.view.ChooseAppLanguageContract;
import fambox.pro.view.HelpActivity;
import fambox.pro.view.LoginPageActivity;
import fambox.pro.view.LoginWithBackActivity;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_CHANGE_LANGUAGE;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CHANGED;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE_BUNDLE;
import static fambox.pro.utils.applanguage.AppLanguage.LANGUAGE_PREFERENCES_KAY;

public class ChooseAppLanguagePresenter extends BasePresenter<ChooseAppLanguageContract.View>
        implements ChooseAppLanguageContract.Presenter {

    private ChooseAppLanguageModel chooseAppLanguageModel;
//    private List<String> mLanguageCodes = new ArrayList<>();
    private AppLanguage mAppLanguage;
    private boolean isChangeLanguage;
    private String countryCode;
    private String countryCodeBundle;

    @Override
    public void viewIsReady() {
        mAppLanguage = new AppLanguage(getView().getContext());
        chooseAppLanguageModel = new ChooseAppLanguageModel();
    }

    @Override
    public void initBundle(Bundle bundle) {
        if (bundle != null) {
            isChangeLanguage = bundle.getBoolean(KEY_CHANGE_LANGUAGE);
            countryCodeBundle = bundle.getString(KEY_COUNTRY_CODE_BUNDLE, "");
        }
        this.countryCode = Objects.equals(countryCodeBundle, "")
                ? SafeYouApp.getPreference(getView().getContext()).getStringValue(KEY_COUNTRY_CODE, "arm")
                : countryCodeBundle;
        if (Connectivity.isConnected(getView().getContext())) {
            getLanguages(this.countryCode);
        } else {
            getView().showErrorMessage(getView().getContext().getResources()
                    .getString(R.string.please_check_your_internet_connection));
        }
    }

    private void getLanguages(String countryCode) {
        chooseAppLanguageModel.getLanguages(getView().getContext(),
                countryCode,
                SafeYouApp.getPreference(getView().getContext()).getStringValue(LANGUAGE_PREFERENCES_KAY, "en"),
                new NetworkCallback<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            getView().configRecViewLanguages(response.body());
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void changeLanguage(String code, boolean isCountryChanged) {
        if (isChangeLanguage && Objects.equals(countryCodeBundle, "")) {
            mAppLanguage.changeLang(code);
            getView().back();
        } else if (!Objects.equals(countryCodeBundle, "")) {
            getView().openSaveCountryDialog();
        } else if (isCountryChanged){
            getView().changeActivity(LoginWithBackActivity.class,false);
        }else {
            mAppLanguage.changeLang(code);
            getView().changeActivity(HelpActivity.class,false);
        }
    }

    @Override
    public void saveChangedCountryAndLanguage(String languageCode) {
        // save country code and app language
        mAppLanguage.changeLang(languageCode);
        SafeYouApp.getPreference(getView().getContext()).setValue(KEY_COUNTRY_CODE, countryCode);
        SafeYouApp.getPreference(getView().getContext()).setValue(KEY_COUNTRY_CHANGED, true);
        //remove keys
        SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_ACCESS_TOKEN);
        SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_REFRESH_TOKEN);
        SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_PASSWORD);
        SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_USER_PHONE);
        SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
        SafeYouApp.getPreference(getView().getContext()).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);

        ((SafeYouApp) getView().getContext()).getSocket().disconnect();

        getView().changeActivity(LoginPageActivity.class, true);
    }

    @Override
    public void destroy() {
        super.destroy();
        if (chooseAppLanguageModel != null) {
            chooseAppLanguageModel.onDestroy();
        }
    }
}
