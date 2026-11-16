package fambox.pro.presenter;

import java.net.HttpURLConnection;
import java.util.List;

import fambox.pro.R;
import fambox.pro.model.MaritalStatusModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.network.model.Message;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.view.MaritalStatusContract;
import retrofit2.Response;

public class MaritalStatusPresenter extends BasePresenter<MaritalStatusContract.View>
        implements MaritalStatusContract.Presenter {

    private MaritalStatusModel mMaritalStatusModel;

    @Override
    public void viewIsReady() {
        mMaritalStatusModel = new MaritalStatusModel();
    }


    @Override
    public void setMaritalStatus(String countryCode, String locale, Object value) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        mMaritalStatusModel.editProfile(getView().getContext(), countryCode, locale, "marital_status", value,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                if (response.body() != null) {
                                    getView().onBack();
                                }
                            }
                        }
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    @Override
    public void getMaritalList(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        mMaritalStatusModel.getMarriedList(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<List<MarriedListResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<MarriedListResponse>> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                getView().initRecyclerView(response.body());
                            }
                        }
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }
}
