package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.SocialMediaBody;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.forum.UserRateResponseBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface NgoMapDetailContract {

    interface View extends MvpView {
        void configUserData(String name, String location, List<SocialMediaBody> socialMediaBodyList, String imagePath,
                            UserRateResponseBody userRate, int ratesCount, long serviceId);

        void configMapPosition(String name, String description, double latitude, double longitude);

        void configHelplineButton(String buttonText, int textColor);

        void configAddToHelplineButtonVisibility(int visibility);

        void goToProfile();

        void goToPrivateChat(Bundle bundle);
    }

    interface Presenter extends MvpPresenter<NgoMapDetailContract.View> {

        void initBundle(Bundle bundle, String countryCode, String locale);

        void getServiceByServiceId(long serviceId);

        void onMapReady(ServicesResponseBody servicesResponseBody);

        void addToHelpline(String countryCode, String locale);

        void editHelpline(String countryCode, String locale, long oldId);

        void deleteFromHelpline(String countryCode, String locale);

        void navigateAddOrDeleteService(String countryCode, String locale);

        void configAddToHelplineButton(boolean added);

        void configDetailActivity(ServicesResponseBody servicesResponseBody);

        void goToPrivateMessage();
    }

    interface Model extends BaseModel {
        void addEmergencyService(Context context, String countryCode, String locale,
                                 Long value,
                                 NetworkCallback<Response<Message>> response);

        void editEmergencyService(Context context, String countryCode, String locale,
                                  long oldId,
                                  long newId,
                                  NetworkCallback<Response<Message>> response);

        void deleteEmergencyService(Context context, String countryCode, String locale,
                                    long userServiceId,
                                    NetworkCallback<Response<Message>> response);

        void getServiceByServiceId(Context context, String countryCode, String locale,
                                   long userServiceId, NetworkCallback<Response<ServicesResponseBody>> response);
    }
}
