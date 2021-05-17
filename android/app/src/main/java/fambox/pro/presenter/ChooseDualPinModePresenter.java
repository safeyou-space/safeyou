package fambox.pro.presenter;

import android.os.Bundle;

import java.net.HttpURLConnection;

import fambox.pro.Constants;
import fambox.pro.SafeYouApp;
import fambox.pro.model.DualPinModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.ChooseDualPinModeContract;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_ACCESS_TOKEN;
import static fambox.pro.Constants.Key.KEY_REFRESH_TOKEN;

public class ChooseDualPinModePresenter extends BasePresenter<ChooseDualPinModeContract.View>
        implements ChooseDualPinModeContract.Presenter {

    private DualPinModel mDualPinModel;


    @Override
    public void viewIsReady() {
        mDualPinModel = new DualPinModel();
    }

    @Override
    public void login(Bundle bundle, String countryCode, String locale) {
        if (bundle != null) {
            if (!bundle.getBoolean("is_registration_page")) {
                getView().goMainActivity();
            }
        } else {
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
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mDualPinModel != null) {
            mDualPinModel.onDestroy();
        }
    }
}
