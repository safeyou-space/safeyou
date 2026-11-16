package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class IconsResponse {
    @SerializedName("facebook")
    @Expose
    private String facebook;
    @SerializedName("instagram")
    @Expose
    private String instagram;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("web_address")
    @Expose
    private String web_address;
    @SerializedName("info")
    @Expose
    private String info;
}
