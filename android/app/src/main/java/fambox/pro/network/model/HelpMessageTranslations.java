package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import lombok.Data;

@Data
class HelpMessageTranslations {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("help_message_id")
    @Expose
    private int help_message_id;

    @SerializedName("translation")
    @Expose
    private String translation;

    @SerializedName("language_id")
    @Expose
    private int language_id;

    @SerializedName("language")
    @Expose
    private LanguageResponse language;

}
