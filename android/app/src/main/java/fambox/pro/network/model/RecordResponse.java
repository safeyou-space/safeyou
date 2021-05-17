package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class RecordResponse {
    @SerializedName("id")
    @Expose
    private long id;
    @SerializedName("user_id")
    @Expose
    private long user_id;
    @SerializedName("is_sent")
    @Expose
    private int is_sent;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("latitude")
    @Expose
    private String latitude;
    @SerializedName("longitude")
    @Expose
    private String longitude;
    @SerializedName("location")
    @Expose
    private String location;
    @SerializedName("duration")
    @Expose
    private int duration;
    @SerializedName("date")
    @Expose
    private String date;
    @SerializedName("time")
    @Expose
    private String time;
    @SerializedName("url")
    @Expose
    private String url;
    @SerializedName("size")
    @Expose
    private String size;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public int getIs_sent() {
        return is_sent;
    }

    public void setIs_sent(int is_sent) {
        this.is_sent = is_sent;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    @NotNull
    @Override
    public String toString() {
        return "RecordResponse{" +
                "id=" + id +
                ", user_id=" + user_id +
                ", is_sent=" + is_sent +
                ", name='" + name + '\'' +
                ", latitude='" + latitude + '\'' +
                ", longitude='" + longitude + '\'' +
                ", location='" + location + '\'' +
                ", duration=" + duration +
                ", date='" + date + '\'' +
                ", time='" + time + '\'' +
                ", url='" + url + '\'' +
                ", size='" + size + '\'' +
                '}';
    }
}
