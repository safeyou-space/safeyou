package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class LanguageResponse extends Message {
    @SerializedName("id")
    @Expose
    private long id;
    @SerializedName("title")
    @Expose
    private String title;
    @SerializedName("code")
    @Expose
    private String code;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @NotNull
    @Override
    public String toString() {
        return "LanguageResponse{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", code='" + code + '\'' + '}';
    }
}
