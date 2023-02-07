package fambox.pro.presenter.fragment;

import android.content.Context;
import android.util.Log;

import java.util.Arrays;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;

import fambox.pro.SafeYouApp;
import fambox.pro.model.fragment.FragmentPrivateMessageModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.chat.BasePrivateMessageModel;
import fambox.pro.network.model.chat.PrivateMessageUnreadListResponse;
import fambox.pro.network.model.chat.PrivateMessageUserListResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.fragment.FragmentPrivateMessageContract;
import io.socket.client.Socket;
import retrofit2.Response;

public class FragmentPrivateMessagePresenter extends BasePresenter<FragmentPrivateMessageContract.View>
        implements FragmentPrivateMessageContract.Presenter {
    private FragmentPrivateMessageModel mFragmentPrivateMessageModel;
    private Socket mSocket;

    @Override
    public void viewIsReady() {
        mFragmentPrivateMessageModel = new FragmentPrivateMessageModel();
    }

    @Override
    public void onResume() {
        socketInit(getView().getAppContext());
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mSocket != null) {
            mSocket.off("signal");
            mSocket.off("connect");
            mSocket.off("connect_error");
        }
        if (mFragmentPrivateMessageModel != null) {
            mFragmentPrivateMessageModel.onDestroy();
            mFragmentPrivateMessageModel = null;
        }
    }

    public void socketInit(Context context) {
        mSocket = ((SafeYouApp) context).getChatSocket(
                "").getSocket();
        if (mSocket != null) {
            mSocket.on("connect_error", args -> Log.i("connect_error", "err: " + Arrays.toString(args)));

            mSocket.on("connect", args -> {
                String socketId = mSocket.id();
                SafeYouApp.initChatSocket(context, socketId);
                getUserList();
            });

            mSocket.on("signal", args -> {

            });

            if (!mSocket.isActive()) {
                mSocket.connect();
            } else {
                getUserList();
            }
        }
    }

    private void getUserList() {
        mFragmentPrivateMessageModel.privateMessageUserList(getView().getContext(),
                new NetworkCallback<Response<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>>>() {
                    @Override
                    public void onSuccess(Response<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpsURLConnection.HTTP_OK)) {
                            if (getView() != null) {
                                if (response.body() != null) {
                                    getView().setupPrivateMessageList(response.body().getData());
                                }
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        Log.i("onSuccess", "onError: " + error);
                    }
                });
    }

    public void getUnreadPrivateMessages(List<PrivateMessageUserListResponse> listResponses) {
        for (PrivateMessageUserListResponse res : listResponses) {
            mFragmentPrivateMessageModel.getUnreadMessages(res.getRoomKey(),
                    new NetworkCallback<Response<PrivateMessageUnreadListResponse>>() {
                        @Override
                        public void onSuccess(Response<PrivateMessageUnreadListResponse> response) {
                            if (RetrofitUtil.isResponseSuccess(response, HttpsURLConnection.HTTP_OK)) {
                                if (getView() != null) {
                                    if (response.body() != null && response.body().getDataLen() > 0) {
                                        res.setUnreadMessageCount(response.body().getDataLen());
                                        getView().setupUnreadMessageStyles();
                                    }
                                }
                            }
                        }

                        @Override
                        public void onError(Throwable error) {
                            Log.i("onError", "onError: " + error);
                        }
                    });
        }
    }
}
