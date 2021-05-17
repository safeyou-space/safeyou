package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ConsultantRequest {
    @SerializedName("category_id")
    private int categoryId;
    @SerializedName("message")
    private String message;
    @SerializedName("email")
    private String email;
}
