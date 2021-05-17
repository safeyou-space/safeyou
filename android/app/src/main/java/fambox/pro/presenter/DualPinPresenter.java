package fambox.pro.presenter;

import android.text.Editable;

import java.net.HttpURLConnection;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.DualPinModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.SocketHandler;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.DualPinContract;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_ACCESS_TOKEN;
import static fambox.pro.Constants.Key.KEY_REFRESH_TOKEN;

public class DualPinPresenter extends BasePresenter<DualPinContract.View> implements DualPinContract.Presenter {

    private DualPinModel mDualPinModel;

    @Override
    public void viewIsReady() {
        mDualPinModel = new DualPinModel();
    }

    @Override
    public void checkRealFakePin(String countryCode,
                                 String locale,
                                 Editable realPin,
                                 Editable confirmRealPin,
                                 Editable fakePin,
                                 Editable confirmFakePin,
                                 boolean isSettings) {
        String realPinToString = Utils.getEditableToString(realPin);
        String confirmRealPinToString = Utils.getEditableToString(confirmRealPin);
        String fakePinToString = Utils.getEditableToString(fakePin);
        String confirmFakePinToString = Utils.getEditableToString(confirmFakePin);
        if (realPinToString.equals("")
                || confirmRealPinToString.equals("")
                || fakePinToString.equals("")
                || confirmFakePinToString.equals("")) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.please_fill_in_all_fields));
        }else if (Objects.equals(confirmRealPinToString, confirmFakePinToString)){
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.real_and_fake_dublicated));
        } else if (!Objects.equals(realPinToString, confirmRealPinToString)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.real_pin_and_conform_real_not_match));
        } else if (checkLength(realPinToString, confirmRealPinToString,
                fakePinToString, confirmFakePinToString)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.pin_min_length));
        } else if (!Objects.equals(fakePinToString, confirmFakePinToString)) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.fake_and_fake_confirm_not_match));
        } else {
            if (!Connectivity.isConnected(getView().getContext())) {
                getView().showErrorMessage(getView().getContext().getResources().getString(R.string.internet_connection));
                return;
            }

            SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_SHARED_REAL_PIN, realPinToString);
            SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_SHARED_FAKE_PIN, fakePinToString);
            SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_WITHOUT_PIN, true);

            if (isSettings){
                getView().goMainActivity();
            }else {
                login(countryCode, locale);
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mDualPinModel != null) {
            mDualPinModel.onDestroy();
        }
    }

    private void login(String countryCode, String locale) {
        LoginBody loginBody = new LoginBody();
        loginBody.setPhone(SafeYouApp.getPreference(getView().getContext())
                .getStringValue(Constants.Key.KEY_USER_PHONE, ""));
        loginBody.setPassword(SafeYouApp.getPreference(getView().getContext())
                .getStringValue(Constants.Key.KEY_PASSWORD, ""));
        mDualPinModel.loginRequest(getView().getContext(), countryCode, locale, loginBody,
                new NetworkCallback<Response<LoginResponse>>() {
                    @Override
                    public void onSuccess(Response<LoginResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    SafeYouApp.getPreference(getView().getContext())
                                            .setValue(KEY_ACCESS_TOKEN, response.body().getAccessToken());
                                    SafeYouApp.getPreference(getView().getContext())
                                            .setValue(KEY_REFRESH_TOKEN, response.body().getRefreshToken());
                                    getView().goMainActivity();
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            getView().goLoginPage();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    private boolean checkLength(String realPinToString,
                                String confirmRealPinToString,
                                String fakePinToString,
                                String confirmFakePinToString) {
        return realPinToString.length() < 4 || confirmRealPinToString.length() < 4
                || fakePinToString.length() < 4 || confirmFakePinToString.length() < 4;
    }
}
