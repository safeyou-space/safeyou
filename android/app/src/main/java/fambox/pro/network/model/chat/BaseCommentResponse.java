package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class BaseCommentResponse {
    @SerializedName("error")
    @Expose
    private String error;
    @SerializedName("data")
    @Expose
    private ForumData data;

    public ForumData getData() {
        return data;
    }

    public void setData(ForumData data) {
        this.data = data;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    @NotNull
    @Override
    public String toString() {
        return "BaseCommentResponse{" +
                "error='" + error + '\'' +
                ", data=" + data + '}';
    }
}
