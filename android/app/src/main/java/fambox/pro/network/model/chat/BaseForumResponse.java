package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

import java.util.List;

public class BaseForumResponse {
    @SerializedName("error")
    @Expose
    private String error;
    @SerializedName("data")
    @Expose
    private List<ForumData> data;
    @SerializedName("total_data_count")
    @Expose
    private int total_data_count;

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public List<ForumData> getData() {
        return data;
    }

    public void setData(List<ForumData> data) {
        this.data = data;
    }

    public int getTotal_data_count() {
        return total_data_count;
    }

    public void setTotal_data_count(int total_data_count) {
        this.total_data_count = total_data_count;
    }

    @NotNull
    @Override
    public String toString() {
        return "BaseForumResponse{" +
                "error='" + error + '\'' +
                ", data=" + data +
                ", total_data_count=" + total_data_count +
                '}';
    }
}
