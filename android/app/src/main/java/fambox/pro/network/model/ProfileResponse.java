package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

import java.util.List;

import lombok.Data;

@Data
public class ProfileResponse {

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

    @SerializedName("marital_status")
    @Expose
    private String marital_status;

    @SerializedName("phone")
    @Expose
    private String phone;

    @SerializedName("location")
    @Expose
    private String location;

//    @SerializedName("emergency_message")
//    @Expose
//    private String emergency_message;

    @SerializedName("is_verifying_otp")
    @Expose
    private int is_verifying_otp;

    @SerializedName("check_police")
    @Expose
    private int check_police;

    @SerializedName("birthday")
    @Expose
    private String birthday;

    @SerializedName("image")
    @Expose
    private ImageResponse image;

    @SerializedName("records")
    @Expose
    private List<RecordResponse> records;

    @SerializedName("emergency_contacts")
    @Expose
    private List<EmergencyContactsResponse> emergency_contacts;

    @SerializedName("country")
    @Expose
    private CountriesLanguagesResponseBody country;

    @SerializedName("help_message")
    @Expose
    private HelpMessageResponse help_message;

    @SerializedName("emergency_services")
    @Expose
    private List<ServicesResponseBody> emergencyServices;

    @NotNull
    @Override
    public String toString() {
        return "ProfileResponse{" +
                "id=" + id +
                ", firstName='" + first_name + '\'' +
                ", lastName='" + last_name + '\'' +
                ", nickname='" + nickname + '\'' +
                ", marital_status='" + marital_status + '\'' +
                ", phone='" + phone + '\'' +
                ", location='" + location + '\'' +
                ", isVerifyingOtp=" + is_verifying_otp +
                ", checkPolice=" + check_police +
                ", birthday='" + birthday + '\'' +
                ", image=" + image +
                ", records=" + records +
                ", emergencyContacts=" + emergency_contacts +
                ", country=" + country +
                '}';
    }
}
