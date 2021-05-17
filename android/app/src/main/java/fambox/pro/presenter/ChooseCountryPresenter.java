package fambox.pro.presenter;

import android.os.Bundle;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ChooseCountryModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.DeviceConfigBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.ChooseCountryContract;
import okhttp3.ResponseBody;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

public class ChooseCountryPresenter extends BasePresenter<ChooseCountryContract.View>
        implements ChooseCountryContract.Presenter {
    private ChooseCountryModel mChooseCountryModel;
    private boolean changeCountry;
    private static final String ARM = "arm";
    private static final String EN = "en";
    private Map<String, String> mDeviceConfig = new HashMap<>();

    @Override
    public void viewIsReady() {
        mChooseCountryModel = new ChooseCountryModel();
        if (Connectivity.isConnected(getView().getContext())) {
            getCountries();
//            getDeviceConfig();
        } else {
            getView().showErrorMessage(getView().getContext().getResources()
                    .getString(R.string.please_check_your_internet_connection));
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
        if (changeCountry) {
            getView().goChooseLanguageActivity();
        } else {
            SafeYouApp.getPreference(getView().getContext()).setValue(KEY_COUNTRY_CODE, countryCode);
            getView().goChooseLanguageActivity();
        }
    }

    private void getCountries() {
        mChooseCountryModel.getCountries(getView().getContext(), ARM, EN,
                new NetworkCallback<Response<List<CountriesLanguagesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<CountriesLanguagesResponseBody>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            getView().configRecViewCountries(response.body());
//                            if (changeCountry) {
//                                getView().openInfoDialog();
//                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    private void getDeviceConfig() {
        mChooseCountryModel.getDeviceConfig(getView().getContext(), ARM, Constants.API_KEY_ANDROID, new NetworkCallback<Response<List<DeviceConfigBody>>>() {
            @Override
            public void onSuccess(Response<List<DeviceConfigBody>> response) {
                try {
                    if (mDeviceConfig != null) {
                        mDeviceConfig.clear();
                    }
                    JSONObject categoryType = new JSONObject(response.body().get(0).getDeviceConfig());
                    Iterator<String> iterator = categoryType.keys();
                    while (iterator.hasNext()) {
                        String key = iterator.next();
                        if (categoryType.get(key) instanceof String) {
                            mDeviceConfig.put(key, categoryType.getString(key));
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    getView().showErrorMessage(e.getMessage());
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
