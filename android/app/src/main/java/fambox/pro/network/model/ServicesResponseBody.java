package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class ServicesResponseBody {

    @SerializedName("id")
    @Expose
    private long id;

    @SerializedName("title")
    @Expose
    private String title;

    @SerializedName("description")
    @Expose
    private String description;

    @SerializedName("latitude")
    @Expose
    private String latitude;

    @SerializedName("longitude")
    @Expose
    private String longitude;

    @SerializedName("address")
    @Expose
    private String address;

    @SerializedName("web_address")
    @Expose
    private String web_address;

    @SerializedName("emergency_service_category_id")
    @Expose
    private String emergency_service_category_id;

    @SerializedName("user_id")
    @Expose
    private String user_id;

    @SerializedName("status")
    @Expose
    private long status;

    @SerializedName("is_send_sms")
    private int is_send_sms;

    @SerializedName("user_emergency_service_id")
    @Expose
    private long user_emergency_service_id;

    @SerializedName("icons")
    @Expose
    private IconsResponse icons;

    @SerializedName("category")
    @Expose
    private String category;

    @SerializedName("category_translation")
    @Expose
    private String category_translation;

    @SerializedName("user_detail")
    @Expose
    private UserDetail user_detail;

    @SerializedName("user_service")
    @Expose
    private List<UserService> user_service;

    @SerializedName("category_trans")
    @Expose
    private CategoryTranslation category_trans;

    @SerializedName("social_links")
    @Expose
    private List<SocialLinks> socialLinks;
}
