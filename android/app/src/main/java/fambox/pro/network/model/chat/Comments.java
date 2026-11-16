package fambox.pro.network.model.chat;

import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import fambox.pro.privatechat.network.model.Like;

public class Comments implements Parcelable {
    @SerializedName("id")
    @Expose
    private long id;
    @SerializedName("level")
    @Expose
    private long level;
    @SerializedName("group_id")
    @Expose
    private long group_id;
    @SerializedName("user_id")
    @Expose
    private long user_id;
    @SerializedName("user_type_id")
    @Expose
    private int user_type_id;
    @SerializedName("user_type")
    @Expose
    private String user_type;
    @SerializedName("comments_count")
    @Expose
    private int comments_count;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("image_path")
    @Expose
    private String image_path;
    @SerializedName("message")
    @Expose
    private String message;
    @SerializedName("created_at")
    @Expose
    private String created_at;
    @SerializedName("reply_count")
    @Expose
    private int reply_count;
    @SerializedName("reply_id")
    @Expose
    private long reply_id;
    @SerializedName("top_commented_users")
    @Expose
    private List<TopUser> top_commented_users;
    @SerializedName("my")
    @Expose
    private boolean my;
    @SerializedName("isReplied")
    @Expose
    private boolean isReplied;
    @SerializedName("isRepliedTo")
    @Expose
    private boolean isRepliedTo;
    @SerializedName("isHidden")
    @Expose
    private boolean isHidden;
    @SerializedName("replayedTo")
    @Expose
    private String replayedTo;

    private List<Comments> messageReplies;

    private List<Like> likes;

    private String contentImage;

    private long forumId;

    private String roomKey;

    public Comments() {
    }

    protected Comments(Parcel in) {
        id = in.readLong();
        level = in.readLong();
        group_id = in.readLong();
        user_id = in.readLong();
        user_type_id = in.readInt();
        user_type = in.readString();
        comments_count = in.readInt();
        name = in.readString();
        image_path = in.readString();
        message = in.readString();
        created_at = in.readString();
        reply_count = in.readInt();
        reply_id = in.readLong();
        my = in.readByte() != 0;
        isReplied = in.readByte() != 0;
        isRepliedTo = in.readByte() != 0;
        isHidden = in.readByte() != 0;
        replayedTo = in.readString();
        messageReplies = in.createTypedArrayList(Comments.CREATOR);
        likes = in.createTypedArrayList(Like.CREATOR);
        contentImage = in.readString();
        forumId = in.readLong();
        roomKey = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeLong(id);
        dest.writeLong(level);
        dest.writeLong(group_id);
        dest.writeLong(user_id);
        dest.writeInt(user_type_id);
        dest.writeString(user_type);
        dest.writeInt(comments_count);
        dest.writeString(name);
        dest.writeString(image_path);
        dest.writeString(message);
        dest.writeString(created_at);
        dest.writeInt(reply_count);
        dest.writeLong(reply_id);
        dest.writeByte((byte) (my ? 1 : 0));
        dest.writeByte((byte) (isReplied ? 1 : 0));
        dest.writeByte((byte) (isRepliedTo ? 1 : 0));
        dest.writeByte((byte) (isHidden ? 1 : 0));
        dest.writeString(replayedTo);
        dest.writeTypedList(messageReplies);
        dest.writeTypedList(likes);
        dest.writeString(contentImage);
        dest.writeLong(forumId);
        dest.writeString(roomKey);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<Comments> CREATOR = new Creator<Comments>() {
        @Override
        public Comments createFromParcel(Parcel in) {
            return new Comments(in);
        }

        @Override
        public Comments[] newArray(int size) {
            return new Comments[size];
        }
    };

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Comments comments = (Comments) o;
        return id == comments.id;
    }

    @NonNull
    @Override
    public String toString() {
        return "Comments{" +
                "id=" + id +
                ", level=" + level +
                ", group_id=" + group_id +
                ", user_id=" + user_id +
                ", user_type_id=" + user_type_id +
                ", user_type='" + user_type + '\'' +
                ", comments_count=" + comments_count +
                ", name='" + name + '\'' +
                ", image_path='" + image_path + '\'' +
                ", message='" + message + '\'' +
                ", created_at='" + created_at + '\'' +
                ", reply_count=" + reply_count +
                ", reply_id=" + reply_id +
                ", top_commented_users=" + top_commented_users +
                ", my=" + my +
                ", isReplied=" + isReplied +
                ", isRepliedTo=" + isRepliedTo +
                ", replayedTo='" + replayedTo + '\'' +
                ", messageReplies=" + messageReplies +
                ", likes=" + likes +
                ", contentImage='" + contentImage + '\'' +
                ", forumId=" + forumId +
                ", roomKey='" + roomKey + '\'' +
                ", isHidden='" + isHidden + '\'' +
                '}';
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getLevel() {
        return level;
    }

    public void setLevel(long level) {
        this.level = level;
    }

    public long getGroup_id() {
        return group_id;
    }

    public void setGroup_id(long group_id) {
        this.group_id = group_id;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public int getUser_type_id() {
        return user_type_id;
    }

    public void setUser_type_id(int user_type_id) {
        this.user_type_id = user_type_id;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public int getComments_count() {
        return comments_count;
    }

    public void setComments_count(int comments_count) {
        this.comments_count = comments_count;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage_path() {
        return image_path;
    }

    public void setImage_path(String image_path) {
        this.image_path = image_path;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public int getReply_count() {
        return reply_count;
    }

    public void setReply_count(int reply_count) {
        this.reply_count = reply_count;
    }

    public long getReply_id() {
        return reply_id;
    }

    public void setReply_id(long reply_id) {
        this.reply_id = reply_id;
    }

    public List<TopUser> getTop_commented_users() {
        return top_commented_users;
    }

    public void setTop_commented_users(List<TopUser> top_commented_users) {
        this.top_commented_users = top_commented_users;
    }

    public boolean isMy() {
        return my;
    }

    public boolean isHidden() {
        return isHidden;
    }

    public void setMy(boolean my) {
        this.my = my;
    }

    public void setHidden(boolean isHidden) {
        this.isHidden = isHidden;
    }

    public boolean isReplied() {
        return isReplied;
    }

    public void setReplied(boolean replied) {
        isReplied = replied;
    }

    public boolean isRepliedTo() {
        return isRepliedTo;
    }

    public void setRepliedTo(boolean repliedTo) {
        isRepliedTo = repliedTo;
    }

    public String getReplayedTo() {
        return replayedTo;
    }

    public void setReplayedTo(String replayedTo) {
        this.replayedTo = replayedTo;
    }

    public List<Comments> getMessageReplies() {
        return messageReplies;
    }

    public void setMessageReplies(List<Comments> messageReplies) {
        this.messageReplies = messageReplies;
    }

    public List<Like> getLikes() {
        return likes;
    }

    public void setLikes(List<Like> likes) {
        this.likes = likes;
    }

    public String getContentImage() {
        return contentImage;
    }

    public void setContentImage(String contentImage) {
        this.contentImage = contentImage;
    }

    public long getForumId() {
        return forumId;
    }

    public void setForumId(long forumId) {
        this.forumId = forumId;
    }

    public String getRoomKey() {
        return roomKey;
    }

    public void setRoomKey(String roomKey) {
        this.roomKey = roomKey;
    }

    public static Creator<Comments> getCREATOR() {
        return CREATOR;
    }
}
