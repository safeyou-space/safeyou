package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.DeviceConfigBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ChooseCountryContract {

    interface View extends MvpView {
        void configRecViewCountries(List<CountriesLanguagesResponseBody> countriesResponseBodyList);

        void goChooseLanguageActivity();

    }

    interface Presenter extends MvpPresenter<ChooseCountryContract.View> {
        void initBundle(Bundle bundle);

        void saveCountryCode(String countryCode);
    }

    interface Model extends BaseModel {
        void getCountries(Context context, String countryCode, String locale,
                          NetworkCallback<Response<List<CountriesLanguagesResponseBody>>> countryResponse);

        void getDeviceConfig(Context context, String countryCode, String apiKey,
                             NetworkCallback<Response<List<DeviceConfigBody>>> configResponse);
    }
}
