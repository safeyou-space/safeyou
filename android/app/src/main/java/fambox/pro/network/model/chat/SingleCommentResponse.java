package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class SingleCommentResponse {
    @SerializedName("error")
    @Expose
    private String error;
    @SerializedName("data")
    @Expose
    private Comments data;

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public Comments getData() {
        return data;
    }

    public void setData(Comments data) {
        this.data = data;
    }

    @NotNull
    @Override
    public String toString() {
        return "SingleCommentResponse{" +
                "error='" + error + '\'' +
                ", data=" + data +
                '}';
    }
}
