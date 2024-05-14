package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class SurveyListResponse {

    @SerializedName("current_page")
    private int id;

    @SerializedName("total")
    private int total;

    @SerializedName("to")
    private int to;

    @SerializedName("per_page")
    private int perPage;

    @SerializedName("data")
    private List<Surveys> surveys;

    public List<Surveys> getSurveys() {
        return surveys;
    }

    public int getTo() {
        return to;
    }

    public int getTotal() {
        return total;
    }

    public int getPerPage() {
        return perPage;
    }
}

