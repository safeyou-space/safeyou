package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class SurveyOptions {

    @SerializedName("id")
    private long id;

    @SerializedName("question_id")
    private long questionId;

    @SerializedName("correct_answer")
    private long correctAnswer;


    @SerializedName("translation")
    private SurveyTranslation translation;

    public SurveyTranslation getTranslation() {
        return translation;
    }

    public long getId() {
        return id;
    }

    public boolean isCorrectAnswer() {
        return correctAnswer == 1;
    }
}

