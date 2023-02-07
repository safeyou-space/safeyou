package fambox.pro.network.model.chat;


import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class PrivateMessageUnreadListResponse {
    @SerializedName("data_len")
    private int dataLen;
}
