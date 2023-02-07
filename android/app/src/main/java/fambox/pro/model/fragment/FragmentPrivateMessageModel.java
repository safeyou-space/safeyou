package fambox.pro.model.fragment;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.chat.BasePrivateMessageModel;
import fambox.pro.network.model.chat.PrivateMessageUnreadListResponse;
import fambox.pro.network.model.chat.PrivateMessageUserListResponse;
import fambox.pro.view.fragment.FragmentPrivateMessageContract;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class FragmentPrivateMessageModel implements FragmentPrivateMessageContract.Model {

    @Override
    public void privateMessageUserList(Context context, NetworkCallback<Response<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>>> responseNetworkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().getPrivateMessageUserList().enqueue(
                    new Callback<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>>() {
                        @Override
                        public void onResponse(@NonNull Call<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>> call,
                                               @NonNull Response<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>> response) {
                            responseNetworkCallback.onSuccess(response);
                        }

                        @Override
                        public void onFailure(@NonNull Call<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>> call, @NonNull Throwable t) {
                            responseNetworkCallback.onError(t);
                        }
                    });

        }
    }

    @Override
    public void getUnreadMessages(String roomKey, NetworkCallback<Response<PrivateMessageUnreadListResponse>> responseNetworkCallback) {


        SafeYouApp.getChatApiService().getUnreadMessageList(roomKey).enqueue(
                new Callback<PrivateMessageUnreadListResponse>() {
                    @Override
                    public void onResponse(@NonNull Call<PrivateMessageUnreadListResponse> call,
                                           @NonNull Response<PrivateMessageUnreadListResponse> response) {
                        responseNetworkCallback.onSuccess(response);
                    }

                    @Override
                    public void onFailure(@NonNull Call<PrivateMessageUnreadListResponse> call, @NonNull Throwable t) {
                        responseNetworkCallback.onError(t);
                    }
                });


    }

    @Override
    public void onDestroy() {
    }
}
