package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class SurveyUserAnswerDetails {

    @SerializedName("id")
    private long id;

    @SerializedName("question_id")
    private long questionId;
    @SerializedName("option_id")
    private long optionId;

    public long getOptionId() {
        return optionId;
    }
}

