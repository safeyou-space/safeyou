package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class UserRateResponseBody {
    @SerializedName("id")
    private long id;

    @SerializedName("rate")
    private int rate;

    @SerializedName("comment")
    private String comment;

}
