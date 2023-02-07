package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ReportPostBodyBase {
    @SerializedName("category_id")
    private long categoryID;
    @SerializedName("message")
    private String message;
    @SerializedName("comment_id")
    private long commentID;
    @SerializedName("user_id")
    private long userID;
    @SerializedName("comment")
    private String comment;
    @SerializedName("room_key")
    private String roomKey;
}
