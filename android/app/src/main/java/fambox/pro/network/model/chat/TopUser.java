package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class TopUser {

    @SerializedName("nickname")
    @Expose
    private String nickname;
    @SerializedName("image_path")
    @Expose
    private String image_path;
    @SerializedName("user_id")
    @Expose
    private long user_id;

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getImage_path() {
        return image_path;
    }

    public void setImage_path(String image_path) {
        this.image_path = image_path;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    @NotNull
    @Override
    public String toString() {
        return "TopUser{" +
                "nickname='" + nickname + '\'' +
                ", image_path='" + image_path + '\'' +
                ", user_id=" + user_id +
                '}';
    }
}
