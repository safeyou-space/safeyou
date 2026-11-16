package fambox.pro.network.model.chat;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

public class ChatCurrentUserData {
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("user_type")
    @Expose
    private String user_type;
    @SerializedName("user_id")
    @Expose
    private long user_id;
    @SerializedName("image_path")
    @Expose
    private String image_path;
    @SerializedName("location")
    @Expose
    private String location;
    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("birthday")
    @Expose
    private String birthday;
    @SerializedName("role")
    @Expose
    private int role;

    // Getter Methods

    public String getName() {
        return name;
    }

    public String getUser_type() {
        return user_type;
    }

    public long getUser_id() {
        return user_id;
    }

    public String getImage_path() {
        return image_path;
    }

    public String getLocation() {
        return location;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getBirthday() {
        return birthday;
    }

    public int getRole() {
        return role;
    }

    // Setter Methods

    public void setName(String name) {
        this.name = name;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public void setImage_path(String image_path) {
        this.image_path = image_path;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public void setRole(int role) {
        this.role = role;
    }

    @NotNull
    @Override
    public String toString() {
        return "ChatCurrentUserData{" +
                "name='" + name + '\'' +
                ", user_type='" + user_type + '\'' +
                ", user_id=" + user_id +
                ", image_path='" + image_path + '\'' +
                ", location='" + location + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", birthday='" + birthday + '\'' +
                ", role=" + role +
                '}';
    }
}