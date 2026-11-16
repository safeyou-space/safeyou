package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class SurveyUserAnswer {

    @SerializedName("id")
    private long id;

    @SerializedName("survey_id")
    private long surveyId;
    @SerializedName("user_id")
    private long userId;
    @SerializedName("details")
    private List<SurveyUserAnswerDetails> userAnswerDetailsList;

    public List<SurveyUserAnswerDetails> getUserAnswerDetailsList() {
        return userAnswerDetailsList;
    }
}

