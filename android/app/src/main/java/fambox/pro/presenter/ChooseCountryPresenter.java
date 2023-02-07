package fambox.pro.presenter;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

import android.os.Bundle;

import java.net.HttpURLConnection;
import java.util.List;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ChooseCountryModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.ChooseCountryContract;
import retrofit2.Response;

public class ChooseCountryPresenter extends BasePresenter<ChooseCountryContract.View>
        implements ChooseCountryContract.Presenter {
    private ChooseCountryModel mChooseCountryModel;
    private boolean changeCountry;
    private static final String ARM = "arm";
    private static final String EN = "en";

    @Override
    public void viewIsReady() {
        mChooseCountryModel = new ChooseCountryModel();
        if (Connectivity.isConnected(getView().getContext())) {
            getCountries();
        } else {
            getView().showErrorMessage(getView().getContext().getResources()
                    .getString(R.string.check_internet_connection_text_key));
        }
    }

    @Override
    public void initBundle(Bundle bundle) {
        if (bundle != null) {
            changeCountry = bundle.getBoolean(Constants.Key.KEY_CHANGE_COUNTRY);
        }
    }

    @Override
    public void saveCountryCode(String countryCode) {
        if (!changeCountry) {
            SafeYouApp.getPreference(getView().getContext()).setValue(KEY_COUNTRY_CODE, countryCode);
        }
        getView().goChooseLanguageActivity();
    }

    private void getCountries() {
        mChooseCountryModel.getCountries(getView().getContext(), ARM, EN,
                new NetworkCallback<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            getView().configRecViewCountries(response.body());
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mChooseCountryModel != null) {
            mChooseCountryModel.onDestroy();
        }
    }
}
