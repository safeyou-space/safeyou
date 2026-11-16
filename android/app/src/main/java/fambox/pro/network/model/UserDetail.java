package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class UserDetail {

    @SerializedName("id")
    @Expose
    private long id;

    @SerializedName("first_name")
    @Expose
    private String first_name;

    @SerializedName("last_name")
    @Expose
    private String last_name;

    @SerializedName("nickname")
    @Expose
    private String nickname;

    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("location")
    @Expose
    private String location;
    @SerializedName("role")
    @Expose
    private String role;

    @SerializedName("image")
    @Expose
    private ImageResponse image;

}
