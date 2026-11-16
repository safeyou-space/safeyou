package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
public class ProfileQuestionAnswer {
    @SerializedName("answer_id")
    private long answerId;
    @SerializedName("question_id")
    private long questionId;
    @SerializedName("question_option_id")
    private long questionOptionId;
    @SerializedName("question_type")
    private String questionType;
    @SerializedName("answer")
    private String answer;


    public long getAnswerId() {
        return answerId;
    }

    public long getQuestionId() {
        return questionId;
    }

    public long getQuestionOptionId() {
        return questionOptionId;
    }

    public String getQuestionType() {
        return questionType;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}