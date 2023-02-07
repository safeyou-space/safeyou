package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ForumPivot {
    @SerializedName("forum_id")
    private long forumID;

    @SerializedName("category_id")
    private long categoryID;

}
