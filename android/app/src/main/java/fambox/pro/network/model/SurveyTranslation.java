package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class SurveyTranslation {

    @SerializedName("id")
    private long id;

    @SerializedName("title")
    private String title;

    public String getTitle() {
        return title;
    }
}

