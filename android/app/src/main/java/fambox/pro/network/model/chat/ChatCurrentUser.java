package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class ChatCurrentUser {
    @SerializedName("error")
    @Expose
    private String error = null;
    @SerializedName("data")
    @Expose
    private ChatCurrentUserData data;


    // Getter Methods

    public String getError() {
        return error;
    }

    public ChatCurrentUserData getData() {
        return data;
    }

    // Setter Methods

    public void setError(String error) {
        this.error = error;
    }

    public void setData(ChatCurrentUserData dataObject) {
        this.data = dataObject;
    }

    @NotNull
    @Override
    public String toString() {
        return "ChatCurrentUser{" +
                "error='" + error + '\'' +
                ", data=" + data +
                '}';
    }
}