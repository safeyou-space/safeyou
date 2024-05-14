package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;
@Data
public class ProfileQuestionsResponse {

    @SerializedName("id")
    private long id;
    @SerializedName("title")
    private String title;
    @SerializedName("title2")
    private String title2;
    @SerializedName("type")
    private String type;
    @SerializedName("options")
    private List<ProfileQuestionOption> options;

    public List<ProfileQuestionOption> getOptions() {
        return options;
    }

    public void setOptions(List<ProfileQuestionOption> options) {
        this.options = options;
    }

    public long getId() {
        return id;
    }

    public String getType() {
        return type;
    }

    public String getTitle() {
        return title;
    }

    public String getTitle2() {
        return title2;
    }
}

