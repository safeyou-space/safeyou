package fambox.pro.network.model;

import androidx.annotation.NonNull;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;


public class ChangePasswordBody {

    @SerializedName("old_password")
    @Expose
    private String old_password;
    @SerializedName("password")
    @Expose
    private String password;
    @SerializedName("confirm_password")
    @Expose
    private String confirm_password;

    public String getOld_password() {
        return old_password;
    }

    public void setOld_password(String old_password) {
        this.old_password = old_password;
    }

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

    @NotNull
    @Override
    public String toString() {
        return "ChangePasswordBody{" +
                "old_password='" + old_password + '\'' +
                ", password='" + password + '\'' +
                ", confirm_password='" + confirm_password + '\'' +
                '}';
    }
}
