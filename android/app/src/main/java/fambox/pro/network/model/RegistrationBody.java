package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class RegistrationBody {

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
    private int marital_status;
//    private String email;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("birthday")
    @Expose
    private String birthday;
    @SerializedName("password")
    @Expose
    private String password;
    @SerializedName("confirm_password")
    @Expose
    private String confirm_password;

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

    public int getMarital_status() {
        return marital_status;
    }

    public void setMarital_status(int marital_status) {
        this.marital_status = marital_status;
    }

    //    public String getEmail() {
//        return email;
//    }
//
//    public void setEmail(String email) {
//        this.email = email;
//    }

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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirm_password;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirm_password = confirmPassword;
    }

    @NotNull
    @Override
    public String toString() {
        return "RegistrationBody{" +
                "firstName='" + first_name + '\'' +
                ", lastName='" + last_name + '\'' +
                ", nickname='" + nickname + '\'' +
                ", marital_status='" + marital_status + '\'' +
                ", phone='" + phone + '\'' +
                ", birthday='" + birthday + '\'' +
                ", password='" + password + '\'' +
                ", confirmPassword='" + confirm_password + '\'' +
                '}';
    }
}
