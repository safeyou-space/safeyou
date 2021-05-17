package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class SocialLinks {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("title")
    @Expose
    private String title;

    @SerializedName("url")
    @Expose
    private String url;

    @SerializedName("icon")
    @Expose
    private String icon;

    @SerializedName("emergency_service_id")
    @Expose
    private int emergency_service_id;

}
