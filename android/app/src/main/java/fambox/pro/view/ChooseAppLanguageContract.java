package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ChooseAppLanguageContract {

    interface View extends MvpView {

        void changeActivity(Class<?> clazz, boolean finish);

        void back();

        void configRecViewLanguages(List<CountriesLanguagesResponseBody> languagesResponseBodyList);

        void openSaveCountryDialog();

    }

    interface Presenter extends MvpPresenter<View> {

        void initBundle(Bundle bundle);

        void changeLanguage(String code, boolean isCountryChanged);

        void saveChangedCountryAndLanguage(String languageCode);

    }

    interface Model extends BaseModel {

        void getLanguages(Context context, String countryCode, String locale,
                          NetworkCallback<Response<List<CountriesLanguagesResponseBody>>> languageResponse);
    }
}
