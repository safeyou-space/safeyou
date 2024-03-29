package fambox.pro.view.fragment;

import android.content.Context;
import android.content.Intent;
import android.widget.CompoundButton;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CheckPoliceResponseBody;
import fambox.pro.network.model.EmergencyContactBody;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface FragmentProfileContract {

    interface View extends MvpView {

        void setEmergencyMessage(String message);

        void setPoliceCheck(boolean isCheck);

        void setUpEmergencyRecView(List<EmergencyContactsResponse> list);

        void setUpServiceRecView(List<ServicesResponseBody> list);

        void showProgress();

        void dismissProgress();

        void pickContact(Intent data, int requestCode);

        void configCheckPoliceSwitch(CompoundButton buttonView, boolean checked, boolean checkedFromUser,
                                     String title, String description);
    }

    interface Presenter extends MvpPresenter<FragmentProfileContract.View> {
        void getProfile(String countryCode, String locale);

        void editProfile(String countryCode, String locale, String key, int value);

        void onPickContact(EmergencyContactsResponse emergencyContactsResponse);

        void getContactInPhone(String countryCode, String locale, int requestCode, int resultCode, Intent data);

        void addEmergency(String countryCode, String locale, String name, String number);

        void editEmergency(String countryCode, String locale, long id, String name, String number);

        void deleteEmergency(String countryCode, String locale, long id);

        void deleteEmergencyService(String countryCode, String locale, ServicesResponseBody servicesResponseBody);

        void getPolice(CompoundButton buttonView, boolean checked, boolean checkedFromUser);
    }

    interface Model extends BaseModel {
        void getProfile(Context context, String countryCode, String locale,
                        NetworkCallback<Response<ProfileResponse>> response);

        void editProfileServer(Context context, String countryCode, String locale, String key,
                               Object value, NetworkCallback<Response<Message>> response);

        void addEmergencyContact(Context context, String countryCode, String locale,
                                 EmergencyContactBody body,
                                 NetworkCallback<Response<Message>> response);

        void editEmergencyContact(Context context, String countryCode, String locale,
                                  long id,
                                  EmergencyContactBody body,
                                  NetworkCallback<Response<Message>> response);

        void deleteEmergencyContact(Context context, String countryCode, String locale,
                                    long id,
                                    NetworkCallback<Response<Message>> response);

        void getCheckPolice(Context context, String countryCode, String locale,
                            NetworkCallback<Response<CheckPoliceResponseBody>> response);
    }
}
