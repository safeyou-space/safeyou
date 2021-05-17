package fambox.pro.view.fragment;

import android.content.Context;
import android.os.Bundle;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface FragmentOtherContract {

    interface View extends MvpView {

        Context getAppContext();

        void setCountry(String countryName, String imageUrl);

        void setLanguage(String text);

        void showProgress();

        void dismissProgress();

        void configSwitchButton(boolean checked);

        void configNotificationSwitch(boolean checked);

        void logout();

        void goTermAndCondition(Bundle bundle);
    }

    interface Presenter extends MvpPresenter<FragmentOtherContract.View> {
        void getProfile(String countryCode, String locale);

        void setUpLanguage(String countryCode, String locale);

        void logout(String countryCode, String locale);

        void clickTermAndCondition();

        void checkIsNotificationEnabled();

        void checkNotificationStatus(boolean checked, String countryCode, String locale);
    }

    interface Model extends BaseModel {
        void getProfile(Context context, String countryCode, String locale,
                        NetworkCallback<Response<ProfileResponse>> response);

        void editProfile(Context context, String countryCode, String locale,
                         String key,
                         Object value,
                         NetworkCallback<Response<Message>> response);

        void logout(Context context, String countryCode, String locale,
                    NetworkCallback<Response<Message>> response);
    }
}
