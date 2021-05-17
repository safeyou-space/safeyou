package fambox.pro.view.fragment;

import android.content.Context;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface FragmentRecordsContract {

    interface View extends MvpView {
        void initBundle();

        void initRecordRecyclerView(List<RecordResponse> mRecordModels);

        void showProgress();

        void dismissProgress();

        void setUpSuggestions(List<RecordSearchResult> recordSearchResults);
    }

    interface Presenter extends MvpPresenter<FragmentRecordsContract.View> {

        void getRecord(String countryCode, String locale);

        void getRecordByType(String countryCode, String locale, int type);

        void startSearch(String countryCode, String locale, String text);
    }

    interface Model extends BaseModel {
        void getRecords(Context context, String countryCode, String locale, NetworkCallback<Response<List<RecordResponse>>> response);

        void getRecordIsSend(Context context, String countryCode, String locale,
                             String isSent,
                             String search,
                             NetworkCallback<Response<List<RecordResponse>>> response);
    }
}
