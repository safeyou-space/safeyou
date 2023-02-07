package fambox.pro.network.model.forum;

import com.google.gson.annotations.SerializedName;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class ForumResponseBody {

    @SerializedName("id")
    private long id;

    @SerializedName("image_id")
    private long imageID;

    @SerializedName("creator_id")
    private long creatorID;

    @SerializedName("from")
    private Object from;

    @SerializedName("to")
    private Object to;

    @SerializedName("age_restricted")
    private long ageRestricted;

    @SerializedName("views_count")
    private long viewsCount;

    @SerializedName("comments_count")
    private int commentsCount;

    @SerializedName("rate")
    private Double rate;

    @SerializedName("rates_count")
    private int ratesCount;

    @SerializedName("last_month_activity")
    private int lastMonthActivity;

    @SerializedName("user_rate")
    private UserRateResponseBody userRate;

    @SerializedName("status")
    private long status;

    @SerializedName("created_at")
    private Date createdAt;

    @SerializedName("updated_at")
    private Date updatedAt;

    @SerializedName("deleted_at")
    private Object deletedAt;

    @SerializedName("title")
    private String title;

    @SerializedName("description")
    private String description;

    @SerializedName("sub_title")
    private String subTitle;

    @SerializedName("short_description")
    private String shortDescription;

    @SerializedName("image")
    private ForumImageResponseBody image;

    @SerializedName("categories")
    private List<ForumCategories> categories;

    @SerializedName("translation")
    private List<ForumTranslation> translation;
    @SerializedName("author")
    private String author;
}
