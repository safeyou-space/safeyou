package fambox.pro.presenter;

import android.text.TextUtils;
import android.util.Patterns;

import java.net.HttpURLConnection;

import fambox.pro.SafeYouApp;
import fambox.pro.model.BecomeConsultantModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ConsultantRequest;
import fambox.pro.network.model.OtherConsultantRequest;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.BecomeConsultantContract;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class BecomeConsultantPresenter extends BasePresenter<BecomeConsultantContract.View> implements BecomeConsultantContract.Presenter {
    public static final int CATEGORY_NOT_SELECTED = -1;
    private static final int SELECTED_OTHER_CATEGORY = -2;
    private BecomeConsultantModel mBecomeConsultantModel;

    @Override
    public void viewIsReady() {
        mBecomeConsultantModel = new BecomeConsultantModel();
    }

    @Override
    public void sendRequest(String email, String message,
                            String newCategoryName, int categoryId) {
        boolean isEmailEmpty = TextUtils.isEmpty(email);
        boolean isMessageEmpty = TextUtils.isEmpty(message);
        boolean isValidEmail = Patterns.EMAIL_ADDRESS.matcher(email).matches();
        if (categoryId == CATEGORY_NOT_SELECTED) {
            getView().showErrorMessage("Pleas select profession category");
        } else if (isMessageEmpty) {
            getView().showErrorMessage("Pleas enter message");
        } else if (isEmailEmpty) {
            getView().showErrorMessage("Pleas enter email");
        } else {
            if (isValidEmail) {
                sendRequestToServer(email, message, newCategoryName, categoryId);
            } else {
                getView().showErrorMessage("Enter valid email");
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        mBecomeConsultantModel.onDestroy();
    }

    private void sendRequestToServer(String email, String message,
                                     String newCategoryName, int categoryId) {
        getView().showProgress();
        OtherConsultantRequest otherConsultantRequest = new OtherConsultantRequest();
        ConsultantRequest consultantRequest = new ConsultantRequest();
        if (categoryId == SELECTED_OTHER_CATEGORY) {
            otherConsultantRequest.setSuggested_category(newCategoryName);
            otherConsultantRequest.setEmail(email);
            otherConsultantRequest.setMessage(message);
        } else {
            consultantRequest.setCategoryId(categoryId);
            consultantRequest.setEmail(email);
            consultantRequest.setMessage(message);
        }
        mBecomeConsultantModel.consultantRequest(getView().getContext(), SafeYouApp.getCountryCode(),
                SafeYouApp.getLocale(), categoryId == SELECTED_OTHER_CATEGORY ? otherConsultantRequest
                        : consultantRequest, new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_CREATED)) {
                            if (getView() != null) {
                                if (response.body() != null) {
                                    getView().showSuccessMessage(response.body().toString());
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
}
