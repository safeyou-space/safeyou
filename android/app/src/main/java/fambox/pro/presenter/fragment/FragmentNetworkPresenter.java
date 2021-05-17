package fambox.pro.presenter.fragment;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.model.fragment.FragmentNetworkModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.network.model.UnityNetworkResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.fragment.FragmentNetworkContract;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class FragmentNetworkPresenter extends BasePresenter<FragmentNetworkContract.View>
        implements FragmentNetworkContract.Presenter {

    private FragmentNetworkModel mFragmentNetworkModel;
    private List<ServicesResponseBody> mServicesResponseBodyList;
    private Map<String, String> mCategoriesTypes = new HashMap<>();

    @Override
    public void viewIsReady() {
        mFragmentNetworkModel = new FragmentNetworkModel();
    }

    @Override
    public void getServiceCategoryTypes(String countryCode, String locale, boolean isSendSms) {
        getView().showProgress();
        mFragmentNetworkModel.getCategoryTypes(getView().getContext(), countryCode, locale, isSendSms,
                new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {
                                try {
                                    if (mCategoriesTypes != null && isSendSms) {
                                        mCategoriesTypes.clear();
                                    }
                                    JSONObject categoryType = new JSONObject(response.body().string());
                                    Iterator<String> iterator = categoryType.keys();
                                    while (iterator.hasNext()) {
                                        String key = iterator.next();
                                        if (categoryType.get(key) instanceof String) {
                                            mCategoriesTypes.put(key, categoryType.getString(key));
                                        }
                                    }
                                    getView().initRecViewCategoryButtons(mCategoriesTypes);
                                } catch (IOException | JSONException e) {
                                    e.printStackTrace();
                                    getView().showErrorMessage(e.getMessage());
                                }
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
//                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void getServiceByCategoryID(String countryCode, String locale, long id, boolean isSendSms) {
        getView().showProgress();
        mFragmentNetworkModel.getCategoryByTypesID(getView().getContext(), countryCode, locale, id, isSendSms,
                new NetworkCallback<Response<List<ServicesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<ServicesResponseBody>> response) {
                        if (response.body() != null) {
                            if (mServicesResponseBodyList != null) {
                                mServicesResponseBodyList.clear();
                            }
                            mServicesResponseBodyList = response.body();
                            getView().initRecyclerView(mServicesResponseBodyList);
                            getMarkersPositionInServer();
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
//                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void getServices(String countryCode, String locale, boolean isSendSms) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        getView().showProgress();
        mFragmentNetworkModel.getServicesServer(getView().getContext(), countryCode, locale, isSendSms,
                new NetworkCallback<Response<List<ServicesResponseBody>>>() {
                    @Override
                    public void onSuccess(Response<List<ServicesResponseBody>> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    Log.i("taguyi", "response.body(): " + response.body().size());
                                    if (mServicesResponseBodyList != null) {
                                        mServicesResponseBodyList.clear();
                                        Log.i("taguyi", "mServicesResponseBodyList size " + mServicesResponseBodyList.size());
                                    }
                                    mServicesResponseBodyList = response.body();
                                    getView().initRecyclerView(mServicesResponseBodyList);
                                    getMarkersPositionInServer();
                                    Log.i("taguyi", "mServicesResponseBodyList size verj" + mServicesResponseBodyList.size() + isSendSms);
                                }
                            }
                        } else {
//                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
//                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void search(String countryCode, String locale, String searchText) {
        mFragmentNetworkModel.searchServices(getView().getContext(), countryCode, locale, searchText,
                new NetworkCallback<Response<List<ServicesSearchResponse>>>() {
                    @Override
                    public void onSuccess(Response<List<ServicesSearchResponse>> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    getView().setSearchResult(response.body());
                                }
                            }
                        } else {
//                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
//                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void getMarkersPositionInServer() {
        getView().clearMarkersOnMap();
        if (mServicesResponseBodyList != null) {
            for (int i = 0; i < mServicesResponseBodyList.size(); i++) {
                double latitude = Utils.convertStringToDuple(mServicesResponseBodyList.get(i).getLatitude());
                double longitude = Utils.convertStringToDuple(mServicesResponseBodyList.get(i).getLongitude());
                String fullName = mServicesResponseBodyList.get(i).getUser_detail().getFirst_name();
                getView().addMarkersOnMap(fullName, mServicesResponseBodyList.get(i).getUser_detail().getLocation(),
                        latitude, longitude);
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mFragmentNetworkModel != null) {
            mFragmentNetworkModel.onDestroy();
        }
    }
}
