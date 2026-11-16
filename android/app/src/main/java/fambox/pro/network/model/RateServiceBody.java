package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class RateServiceBody {
    @SerializedName("emergency_service_id")
    private long emergencyServiceId;
    @SerializedName("rate")
    private int rate;
    @SerializedName("comment")
    private String comment;
}
