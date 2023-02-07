package fambox.pro.view.fragment;

import android.content.Context;
import android.widget.ToggleButton;

import java.util.List;
import java.util.Map;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import okhttp3.ResponseBody;
import retrofit2.Response;

public interface FragmentNetworkContract {

    interface View extends MvpView {
        void initRecyclerView(List<ServicesResponseBody> ngoResponse);

        void initRecViewCategoryButtons(Map<String, String> categoryTypes);

        ToggleButton button(int viewId);

        void setUpEmailAddress(String emailAddress);

        void setUpCall(String phoneNumber);

        void addMarkersOnMap(String title, String description, double latitude, double longitude);

        void clearMarkersOnMap();

        void setSearchResult(List<ServicesSearchResponse> responses);

        void showProgress();

        void dismissProgress();
    }

    interface Presenter extends MvpPresenter<FragmentNetworkContract.View> {

        void getServiceCategoryTypes(String countryCode, String locale, boolean isSendSms);

        void getServiceByCategoryID(String countryCode, String locale, long id, boolean isSendSms);

        void getServices(String countryCode, String locale, boolean isSendSms);

        void getMarkersPositionInServer();

        void search(String countryCode, String locale, String searchText);
    }

    interface Model extends BaseModel {

        void getServicesServer(Context context, String countryCode, String locale, boolean isSendSms,
                               NetworkCallback<Response<List<ServicesResponseBody>>> response);

        void searchServices(Context context, String countryCode, String locale, String searchText,
                            NetworkCallback<Response<List<ServicesSearchResponse>>> response);

        void getCategoryTypes(Context context, String countryCode, String locale, boolean isSendSms,
                              NetworkCallback<Response<ResponseBody>> response);

        void getCategoryByTypesID(Context context, String countryCode, String locale,
                                  long categoryId, boolean isSendSms,
                                  NetworkCallback<Response<List<ServicesResponseBody>>> response);
    }
}
