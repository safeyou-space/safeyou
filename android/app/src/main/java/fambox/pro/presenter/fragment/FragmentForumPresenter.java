package fambox.pro.presenter.fragment;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.concurrent.TimeUnit;

import fambox.pro.SafeYouApp;
import fambox.pro.network.SocketHandler;
import fambox.pro.network.model.chat.BaseForumResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.view.fragment.FragmentForumContract;
import io.socket.emitter.Emitter;

public class FragmentForumPresenter extends BasePresenter<FragmentForumContract.View> implements FragmentForumContract.Presenter {
    // Socket IO listening events.
    private static final String LISTENING_FORUMS = "SafeYOU_V4##GET_ALL_FORUMS#RESULT";

    // Socket IO listening emiting.
    private static final String EMITING_ALL_FORUMS = "SafeYOU_V4##GET_ALL_FORUMS";

    private SocketHandler mSocket;

    private boolean mIsFragmentInBackground = false;

    private Emitter.Listener onAllForums = args -> {
        Log.i("tagik", "onAllForums: " + Arrays.toString(args));
        if (!mIsFragmentInBackground) {
            if (args != null) {
                String json = args[0].toString();
                try {
                    BaseForumResponse baseForumResponse = new Gson().fromJson(json, BaseForumResponse.class);
                    new Handler(Looper.getMainLooper()).post(() -> {
                        try {
                            getView().initForumRecyclerView(baseForumResponse.getData());
                            getView().dismissProgress();
                        } catch (Exception ignore) {
                        }
                    });
                } catch (Exception ignore) {

                }
            }
        }
    };

    @Override
    public void viewIsReady() {
        mIsFragmentInBackground = false;
        mSocket = ((SafeYouApp) getView().getApplication()).getSocket();
        mSocket.on(LISTENING_FORUMS, onAllForums);
    }

    @Override
    public void setUpForums(String languageCode) {
        if (!Connectivity.isConnected(getView().getContext())) {
            return;
        }
        getView().showProgress();
        try {
            JSONObject objectMessage = new JSONObject();
            objectMessage.put("language_code", languageCode);
            objectMessage.put("datetime", (TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()) + 4 * 60 * 60));
            objectMessage.put("forums_rows", 300);
            objectMessage.put("forums_page", 0);
            mSocket.emit(EMITING_ALL_FORUMS, objectMessage);
        } catch (JSONException e) {
            e.printStackTrace();
            getView().dismissProgress();
        }
    }

    @Override
    public void onPause() {
        mIsFragmentInBackground = true;
        if (mSocket != null) {
            mSocket.off(LISTENING_FORUMS, onAllForums);
        }
        getView().dismissProgress();
    }

    @Override
    public void destroy() {
        super.destroy();
        getView().dismissProgress();
    }
}
