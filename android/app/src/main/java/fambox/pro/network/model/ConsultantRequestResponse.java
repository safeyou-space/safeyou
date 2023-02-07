package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ConsultantRequestResponse {
    @SerializedName("id")
    private int id;
    @SerializedName("message")
    private String message;
    @SerializedName("profession_consultant_service_category_id")
    private int professionConsultantServiceCategoryId;
    @SerializedName("email")
    private String email;
    @SerializedName("suggested_category")
    private String suggestedCategory;
    @SerializedName("user_id")
    private int userId;
    @SerializedName("status")
    private int status;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("category")
    private Category category;
}
