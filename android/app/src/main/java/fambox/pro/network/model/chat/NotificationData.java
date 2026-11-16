package fambox.pro.network.model.chat;

import androidx.annotation.Nullable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.Objects;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NotificationData {
    @SerializedName("id")
    @Expose
    private String id;
    @SerializedName("forum_id")
    @Expose
    private String forum_id;
    @SerializedName("reply_id")
    @Expose
    private String reply_id;
    @SerializedName("user_id")
    @Expose
    private String user_id;
    @SerializedName("user_type")
    @Expose
    private String user_type;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("isReaded")
    @Expose
    private String isReaded;
    @SerializedName("key")
    @Expose
    private String key;
    @SerializedName("created_at")
    @Expose
    private String created_at;
    @SerializedName("image_path")
    @Expose
    private String image_path;

    @Override
    public boolean equals(@Nullable Object obj) {
        if (obj instanceof NotificationData) {
            NotificationData notificationData = (NotificationData) obj;
            return this.id.equals(notificationData.getId());
        } else {
            return false;
        }
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
