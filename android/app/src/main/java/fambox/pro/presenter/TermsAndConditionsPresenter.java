package fambox.pro.presenter;

import android.os.Bundle;

import java.net.HttpURLConnection;

import fambox.pro.R;
import fambox.pro.model.TermsAndConditionsModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.TermsAndConditionsContract;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_IS_CONSULTANT_CONDITION;
import static fambox.pro.Constants.Key.KEY_IS_TERM;

public class TermsAndConditionsPresenter extends BasePresenter<TermsAndConditionsContract.View>
        implements TermsAndConditionsContract.Presenter {

    private TermsAndConditionsModel mTermsAndConditionsModel;
    private String title;

    @Override
    public void viewIsReady() {
        mTermsAndConditionsModel = new TermsAndConditionsModel();
    }

    @Override
    public void setBundle(Bundle bundle, String countryCode, String locale) {
        if (bundle != null) {
            boolean isTerm = bundle.getBoolean(KEY_IS_TERM);
            boolean isConsultantCondition = bundle.getBoolean(KEY_IS_CONSULTANT_CONDITION);
            getView().setIsTermsAndCondition(isTerm);
            if (isTerm) {
                title = "terms_conditions";
            } else {
                if (isConsultantCondition) {
                    title = "terms_conditions_consultant";
                } else {
                    title = "about_us";
                }
            }
            content(countryCode, locale);
        }
    }

    @Override
    public void content(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        mTermsAndConditionsModel.getContent(getView().getContext(), countryCode, locale, title,
                new NetworkCallback<Response<ContentResponse>>() {
                    @Override
                    public void onSuccess(Response<ContentResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    if (response.body().getContent() != null) {
                                        getView().configWebView(response.body().getContent());
                                    }
                                }
                            } else {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mTermsAndConditionsModel != null) {
            mTermsAndConditionsModel.onDestroy();
        }
    }
}
