package fambox.pro.presenter.fragment;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.SafeYouApp;
import fambox.pro.model.fragment.FragmentForumModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.forum.ForumBase;
import fambox.pro.network.model.forum.ForumFilter;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentForumContract;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import retrofit2.Response;

public class FragmentForumPresenter extends BasePresenter<FragmentForumContract.View> implements FragmentForumContract.Presenter {

    private Socket mSocket;
    private String languageFilterKey = null;
    private JSONObject jsonObjectCategory = null;
    private JSONObject jsonObjectSortCategory = null;
    private int page = 1;
    private boolean isForumByFilterEnabled = false;
    private boolean isAllChipsRemoved = false;
    private List<ForumResponseBody> forums;
    private int emmitCounter = 0;

    private FragmentForumModel mFragmentForumModel;
    private final Emitter.Listener signal = args -> {
        if (args.length >= 2 && (int) args[0] == 17) {
            try {
                if (forums != null) {
                    emmitCounter++;
                    JSONObject commentData = new JSONObject(args[1].toString()).getJSONObject("data");
                    int forumId = commentData.getInt("forum_id");
                    int messagesCount = commentData.getInt("messages_count");
                    if (forums.size() == emmitCounter) {
                        emmitCounter = 0;
                    }
                    if (getView() != null) {
                        getView().notifyDataChange(forumId, messagesCount);
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };

    @Override
    public void viewIsReady() {
        mFragmentForumModel = new FragmentForumModel();
        getAllForums(null, null, jsonObjectSortCategory == null ? "" : jsonObjectSortCategory.toString(), isForumByFilterEnabled, isAllChipsRemoved);
        getView().initForumRecyclerView(new ArrayList<>());
        getView().initForumFilterChipsRecyclerView(new ArrayList<>());

        mSocket = ((SafeYouApp) getView().getApplication()).getChatSocket("").getSocket();
    }

    @Override
    public void getAllForumsByFilter(String languageFilter, String categoryFilter, String categorySort, boolean forumByFilterEnabled, boolean allChipsRemoved) {
        this.isForumByFilterEnabled = forumByFilterEnabled;
        this.isAllChipsRemoved = allChipsRemoved;
        getView().showProgress();
        mFragmentForumModel.getAllForums(getView().getApplication(),
                SafeYouApp.getPreference(getView().getContext()).getStringValue(KEY_COUNTRY_CODE, ""),
                LocaleHelper.getLanguage(getView().getContext()), page,
                languageFilter, categoryFilter, jsonObjectSortCategory == null ? "" : jsonObjectSortCategory.toString(),
                new NetworkCallback<Response<ForumBase>>() {
                    @Override
                    public void onSuccess(Response<ForumBase> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK))
                            if (response.body() != null) {
                                forums = response.body().getData();
                                getView().addForums(response.body().getData(), true, isAllChipsRemoved);
                                if (isAllChipsRemoved) {
                                    languageFilterKey = null;
                                    jsonObjectCategory = null;
                                    isAllChipsRemoved = false;
                                }

                                for (ForumResponseBody forumResponseBody : response.body().getData()) {
                                    JSONObject emmitCont = new JSONObject();
                                    try {
                                        emmitCont.put("forum_id", forumResponseBody.getId());
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                    if (mSocket != null) {
                                        mSocket.on("signal", signal);
                                        if (!mSocket.isActive()) {
                                            mSocket.connect();
                                        }
                                        mSocket.emit("signal", 17, emmitCont);
                                    }
                                }
                            }

                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        Log.i("onError", "onError: " + error);
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });

    }

    @Override
    public void getAllForums(String languageFilter, String categoryFilter, String categorySort, boolean forumByFilterEnabled, boolean allChipsRemoved) {
        this.isForumByFilterEnabled = forumByFilterEnabled;
        this.isAllChipsRemoved = allChipsRemoved;
        if (allChipsRemoved) {
            page = 1;
        }
        getView().showProgress();
        mFragmentForumModel.getAllForums(getView().getApplication(),
                SafeYouApp.getPreference(getView().getContext()).getStringValue(KEY_COUNTRY_CODE, ""),
                LocaleHelper.getLanguage(getView().getContext()), page,
                languageFilter, categoryFilter, jsonObjectSortCategory == null ? "" : jsonObjectSortCategory.toString(),
                new NetworkCallback<Response<ForumBase>>() {
                    @Override
                    public void onSuccess(Response<ForumBase> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK))
                            if (response.body() != null) {
                                forums = response.body().getData();
                                getView().addForums(response.body().getData(), false, isAllChipsRemoved);
                                if (isAllChipsRemoved) {
                                    languageFilterKey = null;
                                    jsonObjectCategory = null;
                                    isAllChipsRemoved = false;
                                }

                                for (ForumResponseBody forumResponseBody : response.body().getData()) {
                                    JSONObject emmitCont = new JSONObject();
                                    try {
                                        emmitCont.put("forum_id", forumResponseBody.getId());
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                    if (mSocket != null) {
                                        mSocket.on("signal", signal);
                                        if (!mSocket.isActive()) {
                                            mSocket.connect();
                                        }
                                        mSocket.emit("signal", 17, emmitCont);
                                    }
                                }
                            }

                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        Log.i("onError", "onError: " + error);
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });

    }

    @Override
    public void onNextPage(int page, int total) {
        this.page++;
        getAllForums(languageFilterKey, jsonObjectCategory == null ? "" : jsonObjectCategory.toString(),
                jsonObjectSortCategory == null ? "" : jsonObjectSortCategory.toString(), false, isAllChipsRemoved);
    }

    @Override
    public void setPage(int page) {
        this.page = page;
    }

    @Override
    public void setForumSortCategory(Map<String, String> mapSortingCategory) {
        for (Map.Entry<String, String> category : mapSortingCategory.entrySet()) {
            try {
                jsonObjectSortCategory = new JSONObject();
                jsonObjectSortCategory.put(category.getKey(), category.getValue());
                getAllForumsByFilter(languageFilterKey, jsonObjectCategory == null ? "" : jsonObjectCategory.toString(), jsonObjectSortCategory.toString(), true, isAllChipsRemoved);

            } catch (JSONException e) {
                e.printStackTrace();
            }

        }
    }

    @Override
    public void setForumFilterResult(HashMap<String, String> mapCategory, HashMap<String, String> mapLanguage) {
        try {
            jsonObjectCategory = new JSONObject();

            List<ForumFilter> forumFilters = new ArrayList<>();
            for (Map.Entry<String, String> category : mapCategory.entrySet()) {
                forumFilters.add(new ForumFilter(Integer.parseInt(category.getKey()), category.getValue(), 0));
                jsonObjectCategory.put(category.getKey(), category.getKey());
            }
            for (Map.Entry<String, String> language : mapLanguage.entrySet()) {
                forumFilters.add(new ForumFilter(1, language.getValue(), 1));
                languageFilterKey = language.getKey();
            }

            this.page = 1;
            isForumByFilterEnabled = true;
            getView().initForumFilterChipsRecyclerView(forumFilters);
            getAllForumsByFilter(languageFilterKey, jsonObjectCategory.toString(),
                    jsonObjectSortCategory == null ? "" : jsonObjectSortCategory.toString(), true, isAllChipsRemoved);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onPause() {
        if (mSocket != null) {
            mSocket.off("signal", signal);
        }
        getView().dismissProgress();
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mFragmentForumModel != null) {
            mFragmentForumModel.onDestroy();
        }
    }
}
