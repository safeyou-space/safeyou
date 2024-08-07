package fambox.pro.presenter.fragment;

import java.net.HttpURLConnection;
import java.util.List;

import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.model.fragment.FragmentRecordModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentRecordsContract;
import retrofit2.Response;

public class FragmentRecordsPresenter extends BasePresenter<FragmentRecordsContract.View>
        implements FragmentRecordsContract.Presenter {

    private FragmentRecordModel mFragmentRecordModel;

    @Override
    public void viewIsReady() {
        mFragmentRecordModel = new FragmentRecordModel();
    }

    @Override
    public void getRecord(String countryCode, String locale) {
        mFragmentRecordModel.getRecords(getView().getContext(), countryCode, LocaleHelper.getLanguage(getView().getContext()),
                new NetworkCallback<Response<List<RecordResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<RecordResponse>> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    try {
                                        getView().initRecordRecyclerView(response.body());
                                    } catch (Exception ignore) {
                                    }
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void getRecordByType(String countryCode, String locale, int type) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        getView().showProgress();
        switch (type) {
            case 0:
                getRecordIsSnt(countryCode, locale, null, null);
                break;
            case 1:
                getRecordIsSnt(countryCode, locale, "false", null);
                break;
            case 2:
                getRecordIsSnt(countryCode, locale, "true", null);
                break;
        }
    }

    @Override
    public void startSearch(String countryCode, String locale, String text) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        search(countryCode, locale, text);
    }

    private void getRecordIsSnt(String countryCode, String locale, String isSent, String search) {
        mFragmentRecordModel.getRecordIsSend(getView().getContext(), countryCode, locale, isSent, search,
                new NetworkCallback<Response<List<RecordResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<RecordResponse>> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    getView().initRecordRecyclerView(response.body());
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null)
                            getView().dismissProgress();
                    }
                });
    }

    private void search(String countryCode, String locale, String text) {
        mFragmentRecordModel.searchRecord(getView().getContext(), countryCode, locale, text,
                new NetworkCallback<Response<List<RecordSearchResult>>>() {
                    @Override
                    public void onSuccess(Response<List<RecordSearchResult>> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    getView().setUpSuggestions(response.body());
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().dismissProgress();
                    }
                });
    }
}
