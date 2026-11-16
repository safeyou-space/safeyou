package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ForumCategories {
    @SerializedName("id")
    private long id;

    @SerializedName("title")
    private String title;

    @SerializedName("status")
    private long status;

    @SerializedName("creator_id")
    private long creatorID;

    @SerializedName("created_at")
    private String createdAt;

    @SerializedName("updated_at")
    private String updatedAt;

    @SerializedName("deleted_at")
    private Object deletedAt;

    @SerializedName("translation")
    private String translation;

    @SerializedName("pivot")
    private ForumPivot pivot;
}
