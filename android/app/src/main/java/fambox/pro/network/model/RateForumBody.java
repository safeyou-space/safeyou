package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class RateForumBody {
    @SerializedName("forum_id")
    private long forumID;
    @SerializedName("rate")
    private int rate;
    @SerializedName("comment")
    private String comment;
}
