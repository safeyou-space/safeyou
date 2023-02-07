package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;


public class CountriesLanguagesResponseBody {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("title")
    @Expose
    private String title;

    @SerializedName("code")
    @Expose
    private String code;

    @SerializedName("short_code")
    @Expose
    private String short_code;

    @SerializedName("image_id")
    @Expose
    private int image_id;

    @SerializedName("status")
    @Expose
    private int status;

    @SerializedName("created_at")
    @Expose
    private String created_at;

    @SerializedName("updated_at")
    @Expose
    private String updated_at;

    @SerializedName("image_url")
    @Expose
    private String image_url;

//    @SerializedName("image_url")
//    @Expose
//    private CountryLanguageImageBody image_url;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getShort_code() {
        return short_code;
    }

    public void setShort_code(String short_code) {
        this.short_code = short_code;
    }

    public int getImage_id() {
        return image_id;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }

    public String getImage() {
        return image_url;
    }

    public void setImage(String image) {
        this.image_url = image;
    }

    @NotNull
    @Override
    public String toString() {
        return "CountriesLanguagesResponseBody{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", title='" + title + '\'' +
                ", code='" + code + '\'' +
                ", short_code='" + short_code + '\'' +
                ", image_id=" + image_id +
                ", status=" + status +
                ", created_at='" + created_at + '\'' +
                ", updated_at='" + updated_at + '\'' +
                ", image=" + image_url +
                '}';
    }
}
