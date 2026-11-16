package fambox.pro.view;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.BlockUserPostBody;
import fambox.pro.network.model.chat.BlockUserResponse;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.network.model.forum.UserRateResponseBody;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import fambox.pro.privatechat.network.model.ChatMessage;
import fambox.pro.privatechat.network.model.Room;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Response;

public interface ForumCommentContract {

    interface View extends MvpView {
        Application getApplication();

        void setupForumDetail();

        void initRecView(List<Comments> comments, List<Comments> replyComments);

        void setData(String imagePath, String title, String shortDescription, String description,
                     int commentCount, String author, Date createdAt, Double rate, int ratesCount,
                     UserRateResponseBody userRate, long forumId);

        void setCommentCount(int commentCount);

        void setReplyContent(boolean fromNotification, Comments comment, Comments replyComment);

        void setPageTitle(String title);

        void goneForumDetail();

        void addNewMessage(Comments comment);

        void addNewMessages(List<Comments> comments, long replyIdFromNotification);

        void deleteComment(long messageId);

        void editComment(Comments comment);

        void goPinActivity(Bundle bundle);

        void showProgress();

        void removeBlockedUser(Comments comments);

        void dismissProgress();

        void onLeaveRoomSuccess();
    }

    interface Presenter extends MvpPresenter<ForumCommentContract.View> {
        void initBundle(Bundle bundle, String languageCode);

        void onStop();

        void setCommentMassage(String message, String locale, List<File> files, boolean isEdit, long editedMessageId);

        void onReply(Comments comment);

        void checkPin(Bundle bundle);

        void onClickLike(Comments comments, int likeType);

        void onClickBlockUser(Comments comments);

        void onNextPage(int page, int total);

        void deleteMessage(Comments comment);

        void leaveRoom();
    }

    interface Model extends BaseModel {
        void getForumById(Context appContext, String countryCode, String languageCode, long forumId,
                          NetworkCallback<Response<ForumResponseBody>> response);


        void joinRoom(Context appContext, String roomId, NetworkCallback<Response<fambox.pro.privatechat.network.model.BaseModel<Room>>> responseNetworkCallback);

        void blockUser(Context appContext, BlockUserPostBody blockUserPostBody, NetworkCallback<BlockUserResponse> responseNetworkCallback);

        void leaveRoom(String roomId, NetworkCallback<Response<fambox.pro.privatechat.network.model.BaseModel<Room>>> responseNetworkCallback);

        void deleteMessage(String roomId, long messageId);

        void getForumComments(Context appContext, String roomKey, int limit, int skip,
                              NetworkCallback<Response<fambox.pro.privatechat.network.model.BaseModel<List<ChatMessage>>>> response);

        void sendMessageToServer(String roomId, List<MultipartBody.Part> files,
                                 Map<String, RequestBody> body, NetworkCallback<Response<fambox.pro.privatechat.network.model.BaseModel<ChatMessage>>> networkCallback);

        void editMessageToServer(String roomId, List<MultipartBody.Part> files,
                                 Map<String, RequestBody> body, long messageId,
                                 NetworkCallback<Response<fambox.pro.privatechat.network.model.BaseModel<ChatMessage>>> networkCallback);

        void getReplyFromNotification(String roomId, long messageId,
                                      NetworkCallback<Response<fambox.pro.privatechat.network.model.BaseModel<List<ChatMessage>>>> networkCallback);
    }
}
