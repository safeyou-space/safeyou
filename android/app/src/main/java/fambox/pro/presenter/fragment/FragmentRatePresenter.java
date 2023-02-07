package fambox.pro.presenter.fragment;

import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.Map;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.SafeYouApp;
import fambox.pro.model.fragment.FragmentRateModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.RateForumBody;
import fambox.pro.network.model.RateServiceBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentRateContract;
import retrofit2.Response;

public class FragmentRatePresenter extends BasePresenter<FragmentRateContract.View>
        implements FragmentRateContract.Presenter {

    private FragmentRateModel mFragmentRateModel;

    @Override
    public void viewIsReady() {
        mFragmentRateModel = new FragmentRateModel();
    }

    @Override
    public void rateForum(int rate, String comment, long forumID, boolean isNGO) {
        if (isNGO) {
            RateServiceBody rateBody = new RateServiceBody();
            rateBody.setEmergencyServiceId(forumID);
            rateBody.setRate(rate);
            rateBody.setComment(comment);
            mFragmentRateModel.rateNGO(getView().getContext(),
                    SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                    LocaleHelper.getLanguage(getView().getContext()), rateBody,
                    new NetworkCallback<Response<HashMap<String, String>>>() {
                        @Override
                        public void onSuccess(Response<HashMap<String, String>> response) {
                            if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                                if (getView() != null) {
                                    if (response.body() != null) {
                                        for (Map.Entry<String, String> value : response.body().entrySet()) {
                                            getView().showSuccessMessage(value.getValue());
                                        }
                                    }
                                }
                            }
                        }

                        @Override
                        public void onError(Throwable error) {

                        }
                    });
        } else {
            RateForumBody rateBody = new RateForumBody();
            rateBody.setForumID(forumID);
            rateBody.setRate(rate);
            rateBody.setComment(comment);
            mFragmentRateModel.rateForum(getView().getContext(),
                    SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                    LocaleHelper.getLanguage(getView().getContext()), rateBody,
                    new NetworkCallback<Response<HashMap<String, String>>>() {
                        @Override
                        public void onSuccess(Response<HashMap<String, String>> response) {
                            if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                                if (getView() != null) {
                                    if (response.body() != null) {
                                        for (Map.Entry<String, String> value : response.body().entrySet()) {
                                            getView().showSuccessMessage(value.getValue());
                                        }
                                    }
                                }
                            }
                        }

                        @Override
                        public void onError(Throwable error) {

                        }
                    });
        }
    }
}
