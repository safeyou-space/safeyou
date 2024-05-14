package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.HashMap;
import java.util.List;

import lombok.Data;

@Data
public class ProfileResponse {

    @SerializedName("id")
    private long id;
    @SerializedName("first_name")
    private String first_name;
    @SerializedName("uid")
    private String uid;
    @SerializedName("last_name")
    private String last_name;
    @SerializedName("nickname")
    private String nickname;
    @SerializedName("marital_status")
    private String marital_status;
    @SerializedName("phone")
    private String phone;
    @SerializedName("location")
    private String location;
    @SerializedName("is_verifying_otp")
    private int is_verifying_otp;
    @SerializedName("check_police")
    private int check_police;
    @SerializedName("birthday")
    private String birthday;
    @SerializedName("image")
    private ImageResponse image;
    @SerializedName("records")
    private List<RecordResponse> records;
    @SerializedName("emergency_contacts")
    private List<EmergencyContactsResponse> emergency_contacts;
    @SerializedName("country")
    private CountriesLanguagesResponseBody country;
    @SerializedName("help_message")
    private HelpMessageResponse help_message;
    @SerializedName("emergency_services")
    private List<ServicesResponseBody> emergencyServices;
    @SerializedName("consultant_request")
    private List<ConsultantRequestResponse> consultantRequest;
    @SerializedName("filled_percent")
    private Double filledPercent;
    @SerializedName("profile_questions_answers")
    private HashMap<String, ProfileQuestionAnswer> profileQuestionsAnswers;

    public HashMap<String, ProfileQuestionAnswer> getProfileQuestionsAnswers() {
        return profileQuestionsAnswers;
    }

    public Double getFilledPercent() {
        return filledPercent;
    }
}
