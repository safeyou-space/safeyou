package fambox.pro.network.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class EmergencyContactsResponse {
    @SerializedName("id")
    @Expose
    private long id;

    @SerializedName("user_id")
    @Expose
    private long user_id;

    @SerializedName("phone")
    @Expose
    private String phone;

    @SerializedName("name")
    @Expose
    private String name;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    @NotNull
    @Override
    public String toString() {
        return "EmergencyContactsResponse{" +
                "id=" + id +
                ", phone='" + phone + '\'' +
                ", name='" + name + '\'' +
                ", user_id='" + user_id + '\'' +
                '}';
    }
}
