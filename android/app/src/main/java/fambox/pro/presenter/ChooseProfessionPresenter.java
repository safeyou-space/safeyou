package fambox.pro.presenter;

import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fambox.pro.SafeYouApp;
import fambox.pro.model.ChooseProfessionModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.ChooseProfessionContract;
import retrofit2.Response;

public class ChooseProfessionPresenter extends BasePresenter<ChooseProfessionContract.View> implements ChooseProfessionContract.Presenter {

    private ChooseProfessionModel mChooseProfessionModel;

    @Override
    public void viewIsReady() {
        mChooseProfessionModel = new ChooseProfessionModel();
        getCategoriesFromServer();
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mChooseProfessionModel != null) {
            mChooseProfessionModel.onDestroy();
        }
    }

    private void getCategoriesFromServer() {
        mChooseProfessionModel.getConsultantCategories(getView().getContext(), SafeYouApp.getCountryCode(),
                SafeYouApp.getLocale(), new NetworkCallback<Response<HashMap<Integer, String>>>() {
                    @Override
                    public void onSuccess(Response<HashMap<Integer, String>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {
                                List<Integer> ides = new ArrayList<>();
                                List<String> names = new ArrayList<>();
                                for (Map.Entry<Integer, String> consultant : response.body().entrySet()) {
                                    ides.add(consultant.getKey());
                                    names.add(consultant.getValue());
                                }
                                getView().configRecViewProfessions(ides, names);
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }
}
