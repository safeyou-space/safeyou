package fambox.pro.network.model.chat;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class BasePrivateMessageModel<DATA> {
    @SerializedName("error")
    private boolean error;
    @SerializedName("data")
    private DATA data;
}
