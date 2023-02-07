package fambox.pro.presenter;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.Nullable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.SafeYouApp;
import fambox.pro.model.ForumCommentModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.BlockUserPostBody;
import fambox.pro.network.model.chat.BlockUserResponse;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.network.model.chat.SingleCommentResponse;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.privatechat.network.model.BaseModel;
import fambox.pro.privatechat.network.model.ChatFile;
import fambox.pro.privatechat.network.model.ChatMessage;
import fambox.pro.privatechat.network.model.Room;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.ForumCommentContract;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Response;

public class ForumCommentPresenter extends BasePresenter<ForumCommentContract.View>
        implements ForumCommentContract.Presenter {

    private static final int LIMIT = 10;
    private static final int SIGNAL_CONNECTED = 1;
    private static final int SIGNAL_M_INSERT = 8;
    private static final int SIGNAL_M_DELETE = 10;
    private static final int SIGNAL_M_UPDATE = 9;
    private static final int SIGNAL_R_COUNTER = 17;
    private Socket mSocket;
    private long mForumId;
    private String roomId;
    private String roomKey;
    private int page = 0;

    private final Emitter.Listener onSignal = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            if (args != null) {
                if (args.length >= 2) {
                    int signal = (int) args[0];
                    switch (signal) {
                        case SIGNAL_CONNECTED:
                            break;
                        case SIGNAL_M_INSERT:
                            String json = args[1].toString();
                            new Handler(Looper.getMainLooper()).post(() -> {
                                SingleCommentResponse comment = getComment(json);
                                if (getView() != null && comment != null) {
                                    getView().addNewMessage(comment.getData());
                                }
                            });
                            break;
                        case SIGNAL_M_DELETE:
                            try {
                                JSONObject main = new JSONObject(args[1].toString());
                                if (main.has("data")) {
                                    JSONObject data = main.getJSONObject("data");
                                    long deletedMessageId = data.getLong("message_id");
                                    if (getView() != null) {
                                        new Handler(Looper.getMainLooper()).post(() ->
                                                getView().deleteComment(deletedMessageId));
                                    }
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            break;
                        case SIGNAL_M_UPDATE:
                            String editJson = args[1].toString();
                            new Handler(Looper.getMainLooper()).post(() -> {
                                SingleCommentResponse comment = getComment(editJson);
                                if (getView() != null && comment != null) {
                                    getView().editComment(comment.getData());
                                }
                            });
                            break;
                        case SIGNAL_R_COUNTER:
                            try {
                                JSONObject commentData = new JSONObject(args[1].toString()).getJSONObject("data");
                                if (Objects.equals(roomKey, commentData.getString("room_key"))) {
                                    new Handler(Looper.getMainLooper()).post(() -> {
                                        try {
                                            if (getView() != null) {
                                                getView().setCommentCount(commentData.getInt("messages_count"));
                                            }
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                    });
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            break;
                    }
                }
            }
        }
    };

    private final Emitter.Listener onConnect = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            String socketId = mSocket.id();
            if (getView() != null) {
                SafeYouApp.initChatSocket(getView().getApplication(), socketId);
                joinRoom();
            }
        }
    };

    private final Emitter.Listener onError = args -> Log.i("onError", "err: " + Arrays.toString(args));
    private long replyCommentId;
    private ForumCommentModel mForumCommentModel;
    private boolean isStopped;

    @Override
    public void viewIsReady() {
        mForumCommentModel = new ForumCommentModel();
        mSocket = ((SafeYouApp) getView().getApplication()).getChatSocket("").getSocket();

        getView().initRecView(new ArrayList<>(), new ArrayList<>());

        getView().setupForumDetail();
    }

    @Override
    public void onStop() {
        isStopped = true;
        mSocket.off("connect_error", onError);
        mSocket.off("connect", onConnect);
        mSocket.off("signal", onSignal);
    }

    @Override
    public void onReply(Comments comment) {
        if (comment != null) {
            this.replyCommentId = comment.getId();
        } else {
            replyCommentId = 0;
        }
    }

    @Override
    public void onClickLike(Comments comments, int likeType) {
        like(comments.getId(), likeType);
    }

    @Override
    public void onClickBlockUser(Comments comments) {
        BlockUserPostBody blockUserPostBody = new BlockUserPostBody();
        blockUserPostBody.setUserId(comments.getUser_id());

        mForumCommentModel.blockUser(getView().getContext(), blockUserPostBody, new NetworkCallback<BlockUserResponse>() {
            @Override
            public void onSuccess(BlockUserResponse response) {
                getView().removeBlockedUser(comments);
            }

            @Override
            public void onError(Throwable error) {

            }
        });
    }

    @Override
    public void onNextPage(int page, int total) {
        this.page += LIMIT;
        getComments(this.page);
    }

    @Override
    public void leaveRoom() {
        if (mForumCommentModel != null)
            mForumCommentModel.leaveRoom("PUBLIC_GROUP_" + mForumId, new NetworkCallback<Response<BaseModel<Room>>>() {
                @Override
                public void onSuccess(Response<BaseModel<Room>> response) {
                    if (getView() != null) {
                        getView().onLeaveRoomSuccess();
                    }
                }

                @Override
                public void onError(Throwable error) {
                    if (getView() != null) {
                        getView().onLeaveRoomSuccess();
                    }
                }
            });
    }

    @Override
    public void deleteMessage(Comments comment) {
        if (mForumCommentModel != null) {
            mForumCommentModel.deleteMessage(roomKey, comment.getId());
        }
    }

    @Override
    public void checkPin(Bundle bundle) {
        String pin = SafeYouApp.getPreference(getView().getContext()).getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
        if (!Objects.equals(pin, "")) {
            if (bundle != null) {
                boolean isOpenedFromNotification = bundle.getBoolean("is_opened_from_notification");
                if (isOpenedFromNotification) {
                    bundle.putBoolean("is_opened_from_notification", false);
                    getView().goPinActivity(bundle);
                }
            }
        }
    }

    @Override
    public void setCommentMassage(String message, String locale, @Nullable List<File> incomingFiles, boolean isEdit, long editedMessageId) {
        List<MultipartBody.Part> files = new ArrayList<>();
        Map<String, RequestBody> body = new HashMap<>();
        if (message != null) {
            RequestBody messageContent = RequestBody.create(MediaType.parse("text/plain"), message);
            body.put("message_content", messageContent);
        }

        if (incomingFiles != null && incomingFiles.size() > 0) {
            for (File file : incomingFiles) {
                try {
                    URLConnection connection = file.toURL().openConnection();
                    String mimeType = connection.getContentType();
                    RequestBody propertyFile = RequestBody.create(MediaType.parse(mimeType), file);

                    MultipartBody.Part propertyFilePart = MultipartBody.Part.createFormData(
                            "message_files[0]",
                            file.getName(),
                            propertyFile
                    );
                    files.add(propertyFilePart);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        RequestBody messageType = RequestBody.create(MediaType.parse("text/plain"), incomingFiles != null && incomingFiles.size() > 0 ? "2" : "1");
        body.put("message_type", messageType);

        if (!isEdit && replyCommentId > 0) {
            RequestBody replyMessage = RequestBody.create(MediaType.parse("text/plain"), String.valueOf(replyCommentId));
            body.put("message_replies[0]", replyMessage);
        }
        if (isEdit) {
            editMessage(roomKey, editedMessageId, files, body);
        } else {
            sendMessage(roomKey, files, body);
        }
    }

    private void sendMessage(String roomId, List<MultipartBody.Part> files, Map<String, RequestBody> body) {
        mForumCommentModel.sendMessageToServer(roomId, files, body,
                new NetworkCallback<Response<BaseModel<ChatMessage>>>() {
                    @Override
                    public void onSuccess(Response<BaseModel<ChatMessage>> response) {
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    private void editMessage(String roomId, long messageId, List<MultipartBody.Part> files, Map<String, RequestBody> body) {
        mForumCommentModel.editMessageToServer(roomId, files, body, messageId,
                new NetworkCallback<Response<BaseModel<ChatMessage>>>() {
                    @Override
                    public void onSuccess(Response<BaseModel<ChatMessage>> response) {
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void initBundle(Bundle bundle, String languageCode) {
        if (bundle != null) {
            getView().showProgress();
            mForumId = bundle.getLong("forum_id");

            if (bundle.getInt("notification_type") == 2 && bundle.getBoolean("is_opened_from_notification")) {
                String roomKey = bundle.getString("room_key");
                long messageParentId = bundle.getLong("message_parent_id");
                long messageId = bundle.getLong("message_id");
                new Handler().postDelayed(() ->
                        showCommentFromNotification(roomKey, messageParentId), 1000);
            }
            getForum(mForumId);
            if (mSocket != null) {
                mSocket.off();
                mSocket.on("connect_error", onError);
                mSocket.on("connect", onConnect);
                mSocket.on("signal", onSignal);
                if (!mSocket.connected()) {
                    mSocket.connect();
                } else {
                    joinRoom();
                }
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        getView().dismissProgress();
        if (mForumCommentModel != null) {
            leaveRoom();
            mForumCommentModel.onDestroy();
        }
    }


    private void getForum(long forumId) {
        mForumCommentModel.getForumById(getView().getApplication(),
                SafeYouApp.getPreference().getStringValue(Constants.Key.KEY_COUNTRY_CODE, "arm"),
                LocaleHelper.getLanguage(getView().getContext()), forumId,
                new NetworkCallback<Response<ForumResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ForumResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {
                                if (getView() != null) {
                                    ForumResponseBody forum = response.body();
                                    String imagePath = "";
                                    if (forum.getImage() != null) {
                                        imagePath = forum.getImage().getUrl();
                                    }
                                    getView().setData(imagePath, forum.getTitle(),
                                            forum.getShortDescription(),
                                            forum.getDescription(), forum.getCommentsCount(),
                                            forum.getAuthor(), forum.getCreatedAt(),
                                            forum.getRate(), forum.getRatesCount(),
                                            forum.getUserRate(), mForumId);

                                }
                            }
                        }

                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    private void joinRoom() {
        mForumCommentModel.joinRoom(getView().getApplication(), "PUBLIC_GROUP_" + mForumId,
                new NetworkCallback<Response<BaseModel<Room>>>() {
                    @Override
                    public void onSuccess(Response<BaseModel<Room>> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                roomId = Objects.requireNonNull(response.body().getData()).getRoom_id();
                                roomKey = Objects.requireNonNull(response.body().getData()).getRoom_key();
                                JSONObject emmitCont = new JSONObject();
                                try {
                                    emmitCont.put("forum_id", mForumId);
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                                if (mSocket != null)
                                    mSocket.emit("signal", SIGNAL_R_COUNTER, emmitCont);
                            }
                            getComments(page);
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    private void getComments(int page) {
        if (getView() == null || isStopped) {
            isStopped = false;
            return;
        }
        getView().showProgress();
        mForumCommentModel.getForumComments(getView().getApplication(), roomKey, LIMIT, page,
                new NetworkCallback<Response<BaseModel<List<ChatMessage>>>>() {
                    @Override
                    public void onSuccess(Response<BaseModel<List<ChatMessage>>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {
                                List<ChatMessage> chatMessages = response.body().getData();
                                new Handler(Looper.getMainLooper()).post(() -> {
                                    if (getView() != null) {
                                        getView().addNewMessages(getCommentsFromHistory(chatMessages), replyCommentId);
                                    }
                                });
                            }
                        }
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    private void like(long messageId, int isLike) {
        JSONObject signalData = new JSONObject();
        try {
            signalData.put("like_room_id", roomId);
            signalData.put("like_message_id", messageId);
            signalData.put("like_is_liked", isLike);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        if (mSocket != null) {
            mSocket.emit("signal", 16, signalData);
        }
    }

    private SingleCommentResponse getComment(String json) {
        SingleCommentResponse chatCurrentUser = new SingleCommentResponse();
        try {
            JSONObject baseMessageObject = new JSONObject(json);
            if (baseMessageObject.has("error") && !baseMessageObject.getBoolean("error")) {
                if (baseMessageObject.has("data")) {
                    Comments comment = getSingleMessage(baseMessageObject.getJSONObject("data"));
                    JSONObject data = baseMessageObject.getJSONObject("data");

                    if (data.has("message_replies")) {
                        JSONArray replies = data.getJSONArray("message_replies");
                        if (replies.length() > 0) {
                            List<Comments> repliesList = new ArrayList<>();
                            for (int i = 0; i < replies.length(); i++) {
                                Comments reply = getSingleMessage(replies.getJSONObject(i));
                                repliesList.add(reply);
                            }
                            comment.setMessageReplies(repliesList);
                        }
                    }
                    chatCurrentUser.setData(comment);
                    chatCurrentUser.setError(baseMessageObject.getString("error"));

                    if (Objects.equals(roomId, data.getString("message_room_id"))) {
                        return chatCurrentUser;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Comments getSingleMessage(JSONObject incomingData) throws JSONException {
        Comments comment = new Comments();
        comment.setForumId(mForumId);
        comment.setRoomKey(roomKey);
        comment.setId(incomingData.getInt("message_id"));
        comment.setMessage(incomingData.getString("message_content"));
        comment.setCreated_at(incomingData.getString("message_created_at"));
        if (incomingData.has("message_replied_message_id")) {
            int repliedMessageId = incomingData.getInt("message_replied_message_id");
            comment.setReply_id(repliedMessageId);
        }

        if (incomingData.has("message_files")) {
            JSONArray files = incomingData.getJSONArray("message_files");
            if (files.length() > 0) {
                JSONObject file = (JSONObject) files.get(0);

                String mimeType = file.getString("file_mime_type");
                if (mimeType.contains("image")) {
                    String filePath = file.getString("file_path");
                    comment.setContentImage(filePath.startsWith("/") ?
                            Constants.BASE_SOCKET_URL + filePath : filePath);
                }
            }
        }

        if (incomingData.has("message_send_by")) {
            JSONObject sendBy = incomingData.getJSONObject("message_send_by");
            comment.setUser_type_id(sendBy.getInt("user_role"));
            comment.setUser_type(sendBy.getJSONObject("user_profession").getString(LocaleHelper.getLanguage(getView().getContext())));
            comment.setName(sendBy.getString("user_username"));
            comment.setImage_path(sendBy.getString("user_image"));
            comment.setMy(sendBy.getInt("user_id") ==
                    SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0));
            comment.setUser_id(sendBy.getInt("user_id"));
        }

        return comment;
    }

    private List<Comments> getCommentsFromHistory(List<ChatMessage> chatMessages) {
        List<Comments> comments = new ArrayList<>();
        if (chatMessages != null) {
            for (ChatMessage chatMessage : chatMessages) {
                Comments forumComment = new Comments();
                forumComment.setForumId(mForumId);
                forumComment.setId(chatMessage.getMessage_id());
                forumComment.setHidden(chatMessage.getMessage_hidden());
                forumComment.setMessage(chatMessage.getMessage_content());
                forumComment.setUser_type_id(chatMessage.getMessage_send_by().getUser_role());
                if (chatMessage.getMessage_send_by().getUser_profession() != null) {
                    forumComment.setUser_type(chatMessage.getMessage_send_by().getUser_profession()
                            .get(LocaleHelper.getLanguage(getView().getContext())));
                }
                forumComment.setName(chatMessage.getMessage_send_by().getUser_username());
                forumComment.setImage_path(chatMessage.getMessage_send_by().getUser_image());
                forumComment.setMy(chatMessage.getMessage_send_by().getUser_id() ==
                        SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0));
                forumComment.setLikes(chatMessage.getMessage_likes());
                forumComment.setUser_id(chatMessage.getMessage_send_by().getUser_id());
                forumComment.setCreated_at(chatMessage.getMessage_created_at());
                forumComment.setRoomKey(roomKey);
                if (chatMessage.getMessage_files().size() > 0) {
                    ChatFile file = chatMessage.getMessage_files().get(0);
                    String filePath = file.getFile_path();
                    forumComment.setContentImage(filePath.startsWith("/") ? Constants.BASE_SOCKET_URL + filePath : filePath);
                }
                comments.add(forumComment);
                List<Comments> replyComments = new ArrayList<>();
                for (ChatMessage messageReply : chatMessage.getMessage_replies()) {
                    Comments forumCommentReply = new Comments();
                    forumCommentReply.setForumId(mForumId);
                    forumCommentReply.setHidden(messageReply.getMessage_hidden());
                    forumCommentReply.setId(messageReply.getMessage_id());
                    forumCommentReply.setName(messageReply.getMessage_send_by().getUser_username());
                    forumCommentReply.setMessage(messageReply.getMessage_content());
                    forumCommentReply.setUser_type_id(messageReply.getMessage_send_by().getUser_role());
                    if (messageReply.getMessage_send_by().getUser_profession() != null) {
                        forumCommentReply.setUser_type(messageReply.getMessage_send_by().getUser_profession()
                                .get(LocaleHelper.getLanguage(getView().getContext())));
                    }
                    forumCommentReply.setImage_path(messageReply.getMessage_send_by().getUser_image());
                    forumCommentReply.setMy(messageReply.getMessage_send_by().getUser_id() ==
                            SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0));
                    forumCommentReply.setLikes(messageReply.getMessage_likes());
                    forumCommentReply.setUser_id(messageReply.getMessage_send_by().getUser_id());
                    forumCommentReply.setCreated_at(messageReply.getMessage_created_at());
                    forumCommentReply.setRoomKey(roomKey);
                    if (messageReply.getMessage_files().size() > 0) {
                        ChatFile file = messageReply.getMessage_files().get(0);
                        String filePath = file.getFile_path();
                        forumCommentReply.setContentImage(filePath.startsWith("/") ? Constants.BASE_SOCKET_URL + filePath : filePath);
                    }
                    replyComments.add(forumCommentReply);
                    forumComment.setMessageReplies(replyComments);
                }
            }
        }
        return comments;
    }

    private void showCommentFromNotification(String roomKey, long messageParentId) {
        if (messageParentId > 0) {
            // is reply
            getReplyFromNotification(roomKey, messageParentId);
        } else {
            // new comment in owner forum
            getView().goneForumDetail();
        }
    }

    private void getReplyFromNotification(String roomKey, long messageId) {
        if (mForumCommentModel == null) {
            return;
        }
        getView().showProgress();
        mForumCommentModel.getReplyFromNotification(roomKey, messageId,
                new NetworkCallback<Response<BaseModel<List<ChatMessage>>>>() {
                    @Override
                    public void onSuccess(Response<BaseModel<List<ChatMessage>>> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {
                                List<ChatMessage> chatMessages = response.body().getData();
                                List<Comments> comments = getCommentsFromHistory(chatMessages);
                                if (comments.size() > 0 && getView() != null) {
                                    getView().setReplyContent(true, comments.get(0), comments.get(0));
                                }
                            }
                            if (getView() != null) {
                                getView().dismissProgress();
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }
}
