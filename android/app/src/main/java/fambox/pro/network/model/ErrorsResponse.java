package fambox.pro.network.model;

import com.google.gson.annotations.SerializedName;

import java.util.HashMap;
import java.util.List;

public class ErrorsResponse {
    //todo functionality
    @SerializedName("message")
    private String message;

    @SerializedName("errors")
    private HashMap<String, List<String>> errors;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public HashMap<String, List<String>> getErrors() {
        return errors;
    }

    public void setErrors(HashMap<String, List<String>> errors) {
        this.errors = errors;
    }
}
