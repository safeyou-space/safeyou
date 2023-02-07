package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ForumTranslation {

    @SerializedName("id")
    private long id;

    @SerializedName("title")
    private String title;

    @SerializedName("sub_title")
    private String subTitle;

    @SerializedName("description")
    private String description;

    @SerializedName("short_description")
    private String shortDescription;

    @SerializedName("language_id")
    private long languageID;

    @SerializedName("forum_id")
    private long forumID;

    @SerializedName("created_at")
    private Object createdAt;

    @SerializedName("updated_at")
    private Object updatedAt;

    @SerializedName("deleted_at")
    private Object deletedAt;

}
