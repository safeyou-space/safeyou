package fambox.pro.network.model;


import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class Category {
    @SerializedName("id")
    private int id;
    @SerializedName("profession")
    private String profession;
    @SerializedName("status")
    private int status;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("translation")
    private String translation;
    @SerializedName("translations")
    private List<CategoryTranslation> translations;
}
