package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

import java.util.List;

public class ForumData {
    @SerializedName("id")
    @Expose
    private long id;
    @SerializedName("NEW_MESSAGES_COUNT")
    @Expose
    private int NEW_MESSAGES_COUNT;
    @SerializedName("title")
    @Expose
    private String title;
    @SerializedName("sub_title")
    @Expose
    private String sub_title;
    @SerializedName("short_description")
    @Expose
    private String short_description;
    @SerializedName("description")
    @Expose
    private String description;
    @SerializedName("image_path")
    @Expose
    private String image_path;
    @SerializedName("users_count")
    @Expose
    private long users_count;
    @SerializedName("comments_count")
    @Expose
    private long comments_count;
    @SerializedName("top_commented_users")
    @Expose
    private List<TopUser> top_commented_users;
    @SerializedName("comments")
    @Expose
    private List<Comments> comments;
    @SerializedName("reply_list")
    @Expose
    private List<Comments> reply_list;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSub_title() {
        return sub_title;
    }

    public void setSub_title(String sub_title) {
        this.sub_title = sub_title;
    }

    public String getShort_description() {
        return short_description;
    }

    public void setShort_description(String short_description) {
        this.short_description = short_description;
    }

    public String getImage_path() {
        return image_path;
    }

    public void setImage_path(String image_path) {
        this.image_path = image_path;
    }

    public long getComments_count() {
        return comments_count;
    }

    public void setComments_count(long comments_count) {
        this.comments_count = comments_count;
    }

    public long getUsers_count() {
        return users_count;
    }

    public void setUsers_count(long users_count) {
        this.users_count = users_count;
    }

    public List<TopUser> getTop_commented_users() {
        return top_commented_users;
    }

    public void setTop_commented_users(List<TopUser> top_commented_users) {
        this.top_commented_users = top_commented_users;
    }

    public List<Comments> getComments() {
        return comments;
    }

    public void setComments(List<Comments> comments) {
        this.comments = comments;
    }

    public List<Comments> getReply_list() {
        return reply_list;
    }

    public void setReply_list(List<Comments> reply_list) {
        this.reply_list = reply_list;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getNEW_MESSAGES_COUNT() {
        return NEW_MESSAGES_COUNT;
    }

    public void setNEW_MESSAGES_COUNT(int NEW_MESSAGES_COUNT) {
        this.NEW_MESSAGES_COUNT = NEW_MESSAGES_COUNT;
    }

    @NotNull
    @Override
    public String toString() {
        return "ForumData{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", sub_title='" + sub_title + '\'' +
                ", short_description='" + short_description + '\'' +
                ", image_path='" + image_path + '\'' +
                ", comments_count=" + comments_count +
                ", users_count=" + users_count +
                ", top_commented_users=" + top_commented_users +
                ", comments=" + comments +
                ", comments=" + reply_list +
                '}';
    }
}
