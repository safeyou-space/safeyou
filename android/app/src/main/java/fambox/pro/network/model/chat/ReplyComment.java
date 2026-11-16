package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class ReplyComment {
    @SerializedName("message")
    @Expose
    private String message;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("image_path")
    @Expose
    private String image_path;
    @SerializedName("created_at")
    @Expose
    private String created_at;


    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
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

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return "ReplyComment{" +
                "message='" + message + '\'' +
                ", name='" + name + '\'' +
                ", image_path='" + image_path + '\'' +
                ", created_at='" + created_at + '\'' +
                '}';
    }
}
