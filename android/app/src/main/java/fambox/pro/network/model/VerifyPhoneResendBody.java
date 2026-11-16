package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class VerifyPhoneResendBody {
    @SerializedName("phone")
    @Expose
    private String phone;

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @NotNull
    @Override
    public String toString() {
        return "VerifyPhoneResendBody{" +
                "phone='" + phone + '\'' +
                '}';
    }
}
