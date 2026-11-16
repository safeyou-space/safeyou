package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class SurveyQuestion {

    @SerializedName("id")
    private long id;

    @SerializedName("survey_id")
    private long surveyId;

    @SerializedName("type")
    private String type;

    @SerializedName("long_answer")
    private int longAnswer;

    @SerializedName("required")
    private int required;

    @SerializedName("translation")
    private SurveyTranslation translation;

    @SerializedName("options")
    private List<SurveyOptions> options;

    public SurveyTranslation getTranslation() {
        return translation;
    }

    public String getType() {
        return type;
    }

    public long getId() {
        return id;
    }

    public int getLongAnswer() {
        return longAnswer;
    }

    public List<SurveyOptions> getOptions() {
        return options;
    }

    public long getSurveyId() {
        return surveyId;
    }

    public int getRequired() {
        return required;
    }
}

