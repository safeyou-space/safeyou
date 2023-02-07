package fambox.pro.model;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.List;
import java.util.Map;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.BlockUserPostBody;
import fambox.pro.network.model.chat.BlockUserResponse;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.privatechat.network.model.BaseModel;
import fambox.pro.privatechat.network.model.ChatMessage;
import fambox.pro.privatechat.network.model.Room;
import fambox.pro.view.ForumCommentContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ForumCommentModel implements ForumCommentContract.Model {
    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getForumById(Context appContext, String countryCode, String languageCode, long forumId,
                             NetworkCallback<Response<ForumResponseBody>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(appContext).getForumById(countryCode, languageCode, forumId, "android")
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ForumResponseBody>>() {
                    @Override
                    public void onSuccess(@NonNull Response<ForumResponseBody> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(@NonNull Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void joinRoom(Context appContext, String roomId, NetworkCallback<Response<BaseModel<Room>>> responseNetworkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().joinRoom(roomId).
                    enqueue(new Callback<BaseModel<Room>>() {
                        @Override
                        public void onResponse(@NonNull Call<BaseModel<Room>> call,
                                               @NonNull Response<BaseModel<Room>> response) {
                            responseNetworkCallback.onSuccess(response);
                        }

                        @Override
                        public void onFailure(@NonNull Call<BaseModel<Room>> call, @NonNull Throwable t) {
                            responseNetworkCallback.onError(t);
                        }
                    });
        }
    }

    @Override
    public void blockUser(Context appContext, BlockUserPostBody blockUserPostBody, NetworkCallback<BlockUserResponse> responseNetworkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().postBlockUser(blockUserPostBody)
                    .enqueue(new Callback<BlockUserResponse>() {
                        @Override
                        public void onResponse(@NonNull Call<BlockUserResponse> call, @NonNull Response<BlockUserResponse> response) {
                            responseNetworkCallback.onSuccess(response.body());
                        }

                        @Override
                        public void onFailure(@NonNull Call<BlockUserResponse> call, @NonNull Throwable t) {
                            responseNetworkCallback.onError(t);
                        }
                    });
        }
    }

    @Override
    public void leaveRoom(String roomId, NetworkCallback<Response<BaseModel<Room>>> responseNetworkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().leaveRoom(roomId).
                    enqueue(new Callback<BaseModel<Room>>() {
                        @Override
                        public void onResponse(@NonNull Call<BaseModel<Room>> call,
                                               @NonNull Response<BaseModel<Room>> response) {
                            responseNetworkCallback.onSuccess(response);
                        }

                        @Override
                        public void onFailure(@NonNull Call<BaseModel<Room>> call, @NonNull Throwable t) {
                            responseNetworkCallback.onError(t);
                        }
                    });
        } else {
            responseNetworkCallback.onError(null);
        }
    }

    @Override
    public void getForumComments(Context appContext, String roomKey, int limit, int skip,
                                 NetworkCallback<Response<BaseModel<List<ChatMessage>>>> networkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().getForumComments(roomKey, limit, skip).enqueue(new Callback<BaseModel<List<ChatMessage>>>() {
                @Override
                public void onResponse(@NonNull Call<BaseModel<List<ChatMessage>>> call,
                                       @NonNull Response<BaseModel<List<ChatMessage>>> response) {
                    networkCallback.onSuccess(response);
                }

                @Override
                public void onFailure(@NonNull Call<BaseModel<List<ChatMessage>>> call, @NonNull Throwable t) {
                    networkCallback.onError(t);
                }
            });
        }
    }

    @Override
    public void sendMessageToServer(String roomId, List<MultipartBody.Part> files,
                                    Map<String, RequestBody> body, NetworkCallback<Response<BaseModel<ChatMessage>>> networkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().sendMessage(roomId, files, body)
                    .enqueue(new Callback<BaseModel<ChatMessage>>() {
                        @Override
                        public void onResponse(@NonNull Call<BaseModel<ChatMessage>> call,
                                               @NonNull Response<BaseModel<ChatMessage>> response) {
                            networkCallback.onSuccess(response);
                        }

                        @Override
                        public void onFailure(@NonNull Call<BaseModel<ChatMessage>> call, @NonNull Throwable t) {
                            networkCallback.onError(t);
                        }
                    });
        }
    }

    @Override
    public void editMessageToServer(String roomId, List<MultipartBody.Part> files,
                                    Map<String, RequestBody> body, long messageId, NetworkCallback<Response<BaseModel<ChatMessage>>> networkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().editMessage(roomId, messageId, files, body)
                    .enqueue(new Callback<BaseModel<ChatMessage>>() {
                        @Override
                        public void onResponse(@NonNull Call<BaseModel<ChatMessage>> call,
                                               @NonNull Response<BaseModel<ChatMessage>> response) {
                            networkCallback.onSuccess(response);
                        }

                        @Override
                        public void onFailure(@NonNull Call<BaseModel<ChatMessage>> call, @NonNull Throwable t) {
                            networkCallback.onError(t);
                        }
                    });
        }
    }

    @Override
    public void getReplyFromNotification(String roomId, long messageId,
                                         NetworkCallback<Response<BaseModel<List<ChatMessage>>>> networkCallback) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().getReplyFromNotification(roomId, messageId)
                    .enqueue(new Callback<BaseModel<List<ChatMessage>>>() {
                        @Override
                        public void onResponse(@NonNull Call<BaseModel<List<ChatMessage>>> call,
                                               @NonNull Response<BaseModel<List<ChatMessage>>> response) {
                            networkCallback.onSuccess(response);
                        }

                        @Override
                        public void onFailure(@NonNull Call<BaseModel<List<ChatMessage>>> call, @NonNull Throwable t) {
                            networkCallback.onError(t);
                        }
                    });
        }
    }

    @Override
    public void deleteMessage(String roomId, long messageId) {
        if (SafeYouApp.getChatApiService() != null) {
            SafeYouApp.getChatApiService().deleteMessage(roomId, messageId)
                    .enqueue(new Callback<ResponseBody>() {
                        @Override
                        public void onResponse(@NonNull Call<ResponseBody> call,
                                               @NonNull Response<ResponseBody> response) {

                        }

                        @Override
                        public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {

                        }
                    });
        }
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
