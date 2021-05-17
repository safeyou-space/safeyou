package fambox.pro.network.model.chat;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

import java.util.List;

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
    @SerializedName("replayedTo")
    @Expose
    private String replayedTo;

    public Comments(Parcel in) {

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

    public void setId(long id) {
        this.id = id;
    }

    public long getId() {
        return id;
    }

    public long getUser_id() {
        return user_id;
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

    public void setUser_id(long user_id) {
        this.user_id = user_id;
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

    public List<TopUser> getTop_commented_users() {
        return top_commented_users;
    }

    public void setTop_commented_users(List<TopUser> top_commented_users) {
        this.top_commented_users = top_commented_users;
    }

    public long getReply_id() {
        return reply_id;
    }

    public void setReply_id(long reply_id) {
        this.reply_id = reply_id;
    }

    public int getReply_count() {
        return reply_count;
    }

    public void setReply_count(int reply_count) {
        this.reply_count = reply_count;
    }

    public boolean isMy() {
        return my;
    }

    public void setMy(boolean my) {
        this.my = my;
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

    public int getUser_type_id() {
        return user_type_id;
    }

    public void setUser_type_id(int user_type_id) {
        this.user_type_id = user_type_id;
    }

    @NotNull
    @Override
    public String toString() {
        return "Comments{" +
                "id=" + id +
                ", level=" + level +
                ", group_id=" + group_id +
                ", user_id=" + user_id +
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
                '}';
    }

    @Override
    public int describeContents() {
        return 0;
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
        dest.writeString(replayedTo);
    }
}
