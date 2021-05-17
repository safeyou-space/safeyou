package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class CreateNewPasswordBody {

    @SerializedName("password")
    @Expose
    private String password;
    @SerializedName("confirm_password")
    @Expose
    private String confirm_password;
    @SerializedName("token")
    @Expose
    private String token;
    @SerializedName("phone")
    @Expose
    private String phone;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirm_password() {
        return confirm_password;
    }

    public void setConfirm_password(String confirm_password) {
        this.confirm_password = confirm_password;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @NotNull
    @Override
    public String toString() {
        return "CreateNewPasswordBody{" +
                "password='" + password + '\'' +
                ", confirm_password='" + confirm_password + '\'' +
                ", token='" + token + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}
