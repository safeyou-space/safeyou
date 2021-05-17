package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class VerifyPhoneBody {
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("code")
    @Expose
    private String code;

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @NotNull
    @Override
    public String toString() {
        return "VerifyPhoneBody{" +
                "phone='" + phone + '\'' +
                ", code='" + code + '\'' +
                '}';
    }
}
