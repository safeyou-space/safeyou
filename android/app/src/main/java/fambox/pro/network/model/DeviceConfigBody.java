package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class DeviceConfigBody {
    @SerializedName("config")
    @Expose
    String deviceConfig;
}
