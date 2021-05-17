package fambox.pro.presenter;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.SafeYouApp;
import fambox.pro.network.SocketHandler;
import fambox.pro.network.model.chat.BaseCommentResponse;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.network.model.chat.SingleCommentResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.ForumCommentContract;
import io.socket.emitter.Emitter;

public class ForumCommentPresenter extends BasePresenter<ForumCommentContract.View>
        implements ForumCommentContract.Presenter {
    // Socket IO listening events.
    private static final String LISTENING_FORUM_INFO = "SafeYOU_V4##FORUM_MORE_INFO#RESULT";
    private static final String LISTENING_NEW_COMMENTS = "SafeYOU_V4##ADD_NEW_COMMENT#RESULT";

    // Socket IO listening emiting.
    private static final String EMITING_ALL_FORUM_INFO = "SafeYOU_V4##FORUM_MORE_INFO";
    private static final String EMITING_ADD_COMMENT = "SafeYOU_V4##ADD_NEW_COMMENT";

    private SocketHandler mSocket;
    private long forumId;
    private long mReplyMessageIdFromNotification;
    private long replyCommentId;
    private long replyUserId;
    private long groupId;
    private int level;

    private Emitter.Listener onForumInfo = args -> {
        if (args != null) {
            String json = args[0].toString();
            Gson gson = new Gson();
            BaseCommentResponse chatCurrentUser = gson.fromJson(json, BaseCommentResponse.class);
            if (chatCurrentUser.getData() != null) {
                String iamgePath = "";
                if (chatCurrentUser.getData().getImage_path() != null) {
                    iamgePath = chatCurrentUser.getData().getImage_path();
                }
                if (getView() != null) {
                    getView().setData(iamgePath,
                            chatCurrentUser.getData().getTitle(),
                            chatCurrentUser.getData().getShort_description(),
                            chatCurrentUser.getData().getDescription(),
                            (int) chatCurrentUser.getData().getComments_count());
                }
            }
            if (chatCurrentUser.getData() != null) {
                List<Comments> comments = chatCurrentUser.getData().getComments();
                List<Comments> replyComments = chatCurrentUser.getData().getReply_list();
                new Handler(Looper.getMainLooper()).post(() -> {
                    if (comments != null) {
                        getView().initRecView(comments, replyComments, mReplyMessageIdFromNotification);
                        getView().dismissProgress();
                    }
                });
            }
        }
    };

    private Emitter.Listener onNewComment = args -> {
        if (args != null) {
            String json = args[0].toString();
            SingleCommentResponse chatCurrentUser = new Gson().fromJson(json, SingleCommentResponse.class);
            new Handler(Looper.getMainLooper()).post(() -> {
                getView().addNewMessage(chatCurrentUser.getData());
                getView().setCommentCount(chatCurrentUser.getData().getComments_count());
            });
        }
    };

    @Override
    public void viewIsReady() {
        mSocket = ((SafeYouApp) getView().getApplication()).getSocket();
    }

    @Override
    public void onReply(Comments comment) {
        if (comment != null) {
            this.replyCommentId = comment.getId();
            this.replyUserId = comment.getUser_id();
            this.groupId = comment.getGroup_id();
            long tempLevel = comment.getLevel() + 1;
            if (tempLevel > 2) {
                tempLevel = 2;
            }
            this.level = (int) tempLevel;
        } else {
            this.replyCommentId = 0;
            this.replyUserId = 0;
            this.groupId = 0;
            this.level = 0;
        }
        Log.i("tagik", "replyCommentId: " + replyCommentId);
        Log.i("tagik", "replyUserId: " + replyUserId);
        Log.i("tagik", "groupId: " + groupId);
        Log.i("tagik", "level: " + level);
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
    public void setCommentMassage(String message, String locale) {
        try {
            JSONObject objectMessage = new JSONObject();
            objectMessage.put("language_code", locale);
            objectMessage.put("level", level);
            objectMessage.put("forum_id", forumId);
            if (groupId > 0) {
                objectMessage.put("group_id", groupId);
            }
            objectMessage.put("messages", message);
            objectMessage.put("reply_id", replyCommentId);
            objectMessage.put("reply_user_id", replyUserId);

            Log.i("tagik", "setCommentMassage: " + objectMessage);
            mSocket.emit(EMITING_ADD_COMMENT, objectMessage);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void initBundle(Bundle bundle, String languageCode) {
        if (bundle != null) {
            getView().showProgress();
            forumId = bundle.getLong("comment_id");
            mReplyMessageIdFromNotification = bundle.getLong("reply_id", -1);
            getView().setupForumDetail(mReplyMessageIdFromNotification > -1);
            getForumCommentInSocket(languageCode);
            registerConnectionAttributes();
        }
    }

    private void getForumCommentInSocket(String languageCode) {
        try {
            JSONObject objectMessage = new JSONObject();
            objectMessage.put("forum_id", forumId);
            objectMessage.put("language_code", languageCode);
            objectMessage.put("comments_rows", 5000);
            objectMessage.put("comments_page", 0);
            mSocket.emit(EMITING_ALL_FORUM_INFO, objectMessage);
        } catch (JSONException e) {
            e.printStackTrace();
            getView().dismissProgress();
        }
//        getView().dismissProgress();
    }

    @Override
    public void destroy() {
        super.destroy();
        unregisterConnectionAttributes();
        getView().dismissProgress();
    }

    private void registerConnectionAttributes() {
        try {
            if (mSocket != null) {
                mSocket.on(LISTENING_FORUM_INFO, onForumInfo);
                mSocket.on(LISTENING_NEW_COMMENTS, onNewComment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void unregisterConnectionAttributes() {
        try {
            if (mSocket != null) {
                mSocket.off(LISTENING_FORUM_INFO, onForumInfo);
                mSocket.off(LISTENING_NEW_COMMENTS, onNewComment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
