package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ForumImageResponseBody {
    @SerializedName("id")
    private long id;

    @SerializedName("name")
    private String name;

    @SerializedName("path")
    private String path;

    @SerializedName("url")
    private String url;

    @SerializedName("type")
    private long type;

    @SerializedName("deleted_at")
    private Object deletedAt;

}
