package fambox.pro.presenter;

import android.os.Bundle;
import android.widget.Toast;

import com.skydoves.powerspinner.IconSpinnerItem;

import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ReportModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ReportPostBody;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.ReportContract;
import retrofit2.Response;

public class ReportPresenter extends BasePresenter<ReportContract.View> implements ReportContract.Presenter {

    private ReportModel mReportModel;
    private final List<IconSpinnerItem> iconSpinnerItems = new ArrayList<>();
    private Map<String, String> map = new HashMap<>();
    private final ReportPostBody reportPostBody = new ReportPostBody();

    @Override
    public void viewIsReady() {
        mReportModel = new ReportModel();
        setUpReportCategories();
    }

    @Override
    public void setUpReportCategories() {
        mReportModel.getReportCategories(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                LocaleHelper.getLanguage(getView().getContext()),
                new NetworkCallback<Response<HashMap<String, String>>>() {
                    @Override
                    public void onSuccess(Response<HashMap<String, String>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (getView() != null) {
                                if (response.body() != null) {
                                    map.clear();
                                    map = response.body();
                                    for (Map.Entry<String, String> value : response.body().entrySet()) {
                                        iconSpinnerItems.add(new IconSpinnerItem(value.getValue()));
                                    }
                                    getView().configSpinnerView(iconSpinnerItems);
                                }
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void initBundle(Bundle bundle) {
        if (bundle != null) {
            Comments comment = bundle.getParcelable("comment");
            reportPostBody.setComment(comment.getMessage());
            reportPostBody.setCommentID(comment.getId());
            reportPostBody.setUserID(comment.getUser_id());
            reportPostBody.setRoomKey(comment.getRoomKey());
            getView().configViews(comment.getImage_path(), comment.getName(), comment.getUser_type(), comment.getMessage(),
                    Utils.timeUTC(comment.getCreated_at(), LocaleHelper.getLanguage(getView().getContext())));
        }
    }

    @Override
    public void selectCategory(String value) {
        reportPostBody.setCategoryID(Long.parseLong(Objects.requireNonNull(getKey(map, value))));
    }

    @Override
    public void inputText(String inputText) {
        reportPostBody.setMessage(inputText);
    }

    private <K, V> K getKey(Map<K, V> map, V value) {
        for (Map.Entry<K, V> entry : map.entrySet()) {
            if (entry.getValue().equals(value)) {
                return entry.getKey();
            }
        }
        return null;
    }

    @Override
    public void postReport() {
        if (reportPostBody.getCategoryID() == 0) {
            Toast.makeText(getView().getContext(),
                    getView().getContext().getResources().getString(R.string.please_select_category),
                    Toast.LENGTH_SHORT).show();
            return;
        }
        mReportModel.postReport(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                LocaleHelper.getLanguage(getView().getContext()), reportPostBody,
                new NetworkCallback<Response<HashMap<String, String>>>() {
                    @Override
                    public void onSuccess(Response<HashMap<String, String>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (getView() != null) {
                                if (response.body() != null) {
                                    for (Map.Entry<String, String> value : response.body().entrySet()) {
                                        Toast.makeText(getView().getContext(), value.getValue(), Toast.LENGTH_SHORT).show();
                                    }
                                }
                                getView().finishActivity();
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mReportModel != null) {
            mReportModel.onDestroy();
        }
    }
}
