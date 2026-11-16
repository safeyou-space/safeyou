package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class LoginResponse {
    @SerializedName("id")
    @Expose
    private long id;
    @SerializedName("expires_in")
    @Expose
    private int expires_in;
    @SerializedName("check_police")
    @Expose
    private int check_police;
    @SerializedName("token_type")
    @Expose
    private String token_type;
    @SerializedName("access_token")
    @Expose
    private String access_token;
    @SerializedName("refresh_token")
    @Expose
    private String refresh_token;
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
    @SerializedName("birthday")
    @Expose
    private String birthday;
    @SerializedName("emergency_message")
    @Expose
    private String emergency_message;
    @SerializedName("image")
    @Expose
    private String image;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getExpiresIn() {
        return expires_in;
    }

    public void setExpiresIn(int expiresIn) {
        this.expires_in = expiresIn;
    }

    public int getCheckPolice() {
        return check_police;
    }

    public void setCheckPolice(int checkPolice) {
        this.check_police = checkPolice;
    }

    public String getTokenType() {
        return token_type;
    }

    public void setTokenType(String tokenType) {
        this.token_type = tokenType;
    }

    public String getAccessToken() {
        return access_token;
    }

    public void setAccessToken(String accessToken) {
        this.access_token = accessToken;
    }

    public String getRefreshToken() {
        return refresh_token;
    }

    public void setRefreshToken(String refreshToken) {
        this.refresh_token = refreshToken;
    }

    public String getFirstName() {
        return first_name;
    }

    public void setFirstName(String firstName) {
        this.first_name = firstName;
    }

    public String getLastName() {
        return last_name;
    }

    public void setLastName(String lastName) {
        this.last_name = lastName;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getEmergencyMessage() {
        return emergency_message;
    }

    public void setEmergencyMessage(String emergencyMessage) {
        this.emergency_message = emergencyMessage;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @NotNull
    @Override
    public String toString() {
        return "LoginResponse{" +
                "id=" + id +
                ", expiresIn=" + expires_in +
                ", checkPolice=" + check_police +
                ", tokenType='" + token_type + '\'' +
                ", accessToken='" + access_token + '\'' +
                ", refreshToken='" + refresh_token + '\'' +
                ", firstName='" + first_name + '\'' +
                ", lastName='" + last_name + '\'' +
                ", nickname='" + nickname + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", birthday='" + birthday + '\'' +
                ", emergencyMessage='" + emergency_message + '\'' +
                ", image='" + image + '\'' +
                '}';
    }
}
