package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class MarriedListResponse {
    @SerializedName("type")
    @Expose
    private int type;
    @SerializedName("label")
    @Expose
    private String label;

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    @NotNull
    @Override
    public String toString() {
        return "MarriedListResponse{" +
                "type=" + type +
                ", label='" + label + '\'' +
                '}';
    }
}
