package fambox.pro.view.fragment;

import android.content.Context;
import android.widget.ProgressBar;

import androidx.fragment.app.FragmentActivity;

import fambox.pro.enums.Types;
import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import okhttp3.ResponseBody;
import retrofit2.Response;

public interface FragmentHelpContract {

    interface View extends MvpView {

        FragmentActivity getActivityContext();

        void changePushButtonBackground(Types.RecordButtonType recordButtonType, int time);

        void onLocationSuccessEnable();

        void setProgressVisibility(int visibility);

        void setOnClickPushButton();

        void setRecordTimeCounterVisibility(int visibility);

        void setContainerMoreInfoRecListVisibility(int visibility);

        void setContainerCancelSend(int visibility);

        void startRecord();

        void stopRecord();

        void onSmsSend();

        void setUpPushButton();

        void setInfoDialogData(String text);

        void setUpEmergencyButtons(boolean emergencyContacts, boolean emergencyServices,
                                   boolean police, boolean records);
    }

    interface Presenter extends MvpPresenter<FragmentHelpContract.View> {

        void setUpDialogPopup(String countryCode, String locale);

        void setupGPS();

        void startTimerCountDown(ProgressBar recordProgress);

        void stopTimerCountDown();

        void stopRecording();

        void sendHelpMessage(Context context, String countryCode, String locale);

        void getAllServices(String countryCode, String locale);

        void getProfile(String countryCode, String locale);
    }

    interface Model extends BaseModel {

        void sendSms(Context context, String countryCode, String locale, String longitude, String latitude, String location,
                     NetworkCallback<Response<Message>> response);

        void getAllServicesName(Context context, String countryCode, String locale,
                                NetworkCallback<Response<ResponseBody>> response);

        void getProfile(Context context, String countryCode, String locale,
                       NetworkCallback<Response<ProfileResponse>> response);
    }
}
