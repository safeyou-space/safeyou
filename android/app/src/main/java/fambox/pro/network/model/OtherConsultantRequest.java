package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class OtherConsultantRequest {
    @SerializedName("suggested_category")
    private String suggested_category;
    @SerializedName("message")
    private String message;
    @SerializedName("email")
    private String email;
}
