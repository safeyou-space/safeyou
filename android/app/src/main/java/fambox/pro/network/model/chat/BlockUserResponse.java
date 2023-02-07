package fambox.pro.network.model.chat;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class BlockUserResponse {
    @SerializedName("error")
    private boolean error;
    @SerializedName("data")
    private String data;
}
