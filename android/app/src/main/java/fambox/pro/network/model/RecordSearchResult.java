package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class RecordSearchResult {
    @SerializedName("id")
    @Expose
    private int id;
    @SerializedName("location_with_date_time")
    @Expose
    private String location_with_date_time;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return location_with_date_time;
    }

    public void setName(String name) {
        this.location_with_date_time = name;
    }

    @NotNull
    @Override
    public String toString() {
        return "RecordSearchResult{" +
                "id=" + id +
                ", name='" + location_with_date_time + '\'' +
                '}';
    }
}
