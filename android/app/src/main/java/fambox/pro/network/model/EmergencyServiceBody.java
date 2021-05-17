package fambox.pro.network.model;

import androidx.annotation.NonNull;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;


public class EmergencyServiceBody {

    @SerializedName("contact_id")
    @Expose
    private long contact_id;
    @SerializedName("type")
    @Expose
    private String type;

    public long getContact_id() {
        return contact_id;
    }

    public void setContact_id(long contact_id) {
        this.contact_id = contact_id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @NonNull
    @Override
    public String toString() {
        return "EmergencyServiceBody{" +
                "contact_id=" + contact_id +
                ", type='" + type + '\'' +
                '}';
    }
}
