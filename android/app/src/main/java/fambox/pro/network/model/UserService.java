package fambox.pro.network.model;

import androidx.annotation.NonNull;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class UserService {

    @SerializedName("user_service_id")
    @Expose
    private long user_service_id;
    @SerializedName("pivot")
    @Expose
    private UserServicePivot pivot;

    @NonNull
    @Override
    public String toString() {
        return "UserService{" +
                "user_service_id=" + user_service_id +
                ", pivot=" + pivot +
                '}';
    }
}
