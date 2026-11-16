package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class ForgotVerifySmsResponse {

    @SerializedName("message")
    @Expose
    private String message;
    @SerializedName("token")
    @Expose
    private String token;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    @NotNull
    @Override
    public String toString() {
        return "ForgotVerifySmsResponse{" +
                "message='" + message + '\'' +
                ", token='" + token + '\'' +
                '}';
    }
}
