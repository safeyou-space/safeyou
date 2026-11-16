package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class ForumBase {
    @SerializedName("data")
    private List<ForumResponseBody> data;
}
