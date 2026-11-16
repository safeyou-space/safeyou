package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class CheckPoliceResponseBody {
    @SerializedName("check_police_title")
    private String checkPoliceTitle;
    @SerializedName("check_police_description")
    private String checkPoliceDescription;

}
