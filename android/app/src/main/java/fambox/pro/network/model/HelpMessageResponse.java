package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import lombok.Data;

@Data
public class HelpMessageResponse {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("message")
    @Expose
    private String message;

    @SerializedName("status")
    @Expose
    private int status;

    @SerializedName("translation")
    @Expose
    private String translation;

    @SerializedName("translations")
    @Expose
    private List<HelpMessageTranslations> helpMessageTranslations;

}
