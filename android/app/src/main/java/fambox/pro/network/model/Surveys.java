package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class Surveys {

    @SerializedName("id")
    private long id;

    @SerializedName("translation")
    private SurveyTranslation translation;

    @SerializedName("questions")
    private List<SurveyQuestion> questions;

    @SerializedName("is_answered")
    private boolean isAnswered;

    @SerializedName("quiz")
    private int quiz;

    @SerializedName("user_answer")
    private SurveyUserAnswer userAnswer;

    public SurveyTranslation getTranslation() {
        return translation;
    }

    public long getId() {
        return id;
    }

    public List<SurveyQuestion> getQuestions() {
        return questions;
    }

    public boolean isAnswered() {
        return isAnswered;
    }

    public boolean isQuiz() {
        return quiz == 1;
    }

    public SurveyUserAnswer getUserAnswer() {
        return userAnswer;
    }
}

