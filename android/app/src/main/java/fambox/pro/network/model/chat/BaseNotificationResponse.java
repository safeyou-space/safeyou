package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class BaseNotificationResponse {
    @SerializedName("error")
    @Expose
    private String error;
    @SerializedName("data")
    @Expose
    private NotificationData data;
}
