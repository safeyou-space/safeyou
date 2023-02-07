package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import com.skydoves.powerspinner.IconSpinnerItem;

import java.util.HashMap;
import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ReportPostBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface ReportContract {

    interface View extends MvpView {
        void configSpinnerView(List<IconSpinnerItem> iconSpinnerItems);

        void configViews(String imagePath, String reportableUserName, String reportableUserProfession,
                         String reportableComment, String reportableDate);

        void finishActivity();
    }

    interface Presenter extends MvpPresenter<ReportContract.View> {

        void initBundle(Bundle bundle);

        void setUpReportCategories();

        void postReport();

        void selectCategory(String value);

        void inputText(String inputText);
    }

    interface Model extends BaseModel {
        void getReportCategories(Context context, String countryCode, String langugeCode,
                                 NetworkCallback<Response<HashMap<String, String>>> response);

        void postReport(Context context, String countryCode, String langugeCode, ReportPostBody reportPostBody,
                        NetworkCallback<Response<HashMap<String, String>>> response);
    }
}
