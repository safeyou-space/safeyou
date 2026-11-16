package fambox.pro.network.model;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.jetbrains.annotations.NotNull;

import java.util.List;

public class UnityNetworkResponse implements Parcelable {

    @SerializedName("id")
    @Expose
    private long id;
    @SerializedName("user_service_id")
    @Expose
    private long user_service_id;
    @SerializedName("description")
    @Expose
    private String description;
    @SerializedName("user_id")
    @Expose
    private long user_id;
    @SerializedName("latitude")
    @Expose
    private String latitude;
    @SerializedName("longitude")
    @Expose
    private String longitude;

    /***************************/

    @SerializedName("web_address")
    @Expose
    private String web_address;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("address_image")
    @Expose
    private String address_image;
    @SerializedName("instagram_link")
    @Expose
    private String instagram_link;
    @SerializedName("instagram_title")
    @Expose
    private String instagram_title;
    @SerializedName("instagram_image")
    @Expose
    private String instagram_image;
    @SerializedName("facebook_link")
    @Expose
    private String facebook_link;
    @SerializedName("facebook_title")
    @Expose
    private String facebook_title;
    @SerializedName("facebook_image")
    @Expose
    private String facebook_image;

    @SerializedName("email_image")
    @Expose
    private String email_image;

    @SerializedName("phone_image")
    @Expose
    private String phone_image;

    @SerializedName("web_address_image")
    @Expose
    private String web_address_image;


    /***************************/

    @SerializedName("type")
    @Expose
    private String type;
    @SerializedName("user_service")
    @Expose
    private List<UserService> user_service;
    @SerializedName("user_detail")
    @Expose
    private UserDetail user_detail;


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getUser_service_id() {
        return user_service_id;
    }

    public void setUser_service_id(long user_service_id) {
        this.user_service_id = user_service_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
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

    public String getWeb_address() {
        return web_address;
    }

    public void setWeb_address(String web_address) {
        this.web_address = web_address;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress_image() {
        return address_image;
    }

    public void setAddress_image(String address_image) {
        this.address_image = address_image;
    }

    public String getInstagram_link() {
        return instagram_link;
    }

    public void setInstagram_link(String instagram_link) {
        this.instagram_link = instagram_link;
    }

    public String getInstagram_title() {
        return instagram_title;
    }

    public void setInstagram_title(String instagram_title) {
        this.instagram_title = instagram_title;
    }

    public String getInstagram_image() {
        return instagram_image;
    }

    public void setInstagram_image(String instagram_image) {
        this.instagram_image = instagram_image;
    }

    public String getFacebook_link() {
        return facebook_link;
    }

    public void setFacebook_link(String facebook_link) {
        this.facebook_link = facebook_link;
    }

    public String getFacebook_title() {
        return facebook_title;
    }

    public void setFacebook_title(String facebook_title) {
        this.facebook_title = facebook_title;
    }

    public String getFacebook_image() {
        return facebook_image;
    }

    public void setFacebook_image(String facebook_image) {
        this.facebook_image = facebook_image;
    }

    public String getEmail_image() {
        return email_image;
    }

    public void setEmail_image(String email_image) {
        this.email_image = email_image;
    }

    public String getPhone_image() {
        return phone_image;
    }

    public void setPhone_image(String phone_image) {
        this.phone_image = phone_image;
    }

    public String getWeb_address_image() {
        return web_address_image;
    }

    public void setWeb_address_image(String web_address_image) {
        this.web_address_image = web_address_image;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<UserService> getUser_service() {
        return user_service;
    }

    public void setUser_service(List<UserService> user_service) {
        this.user_service = user_service;
    }

    public UserDetail getUser_detail() {
        return user_detail;
    }

    public void setUser_detail(UserDetail user_detail) {
        this.user_detail = user_detail;
    }

    public UnityNetworkResponse() {

    }

    protected UnityNetworkResponse(Parcel in) {
        id = in.readLong();
        user_service_id = in.readLong();
        description = in.readString();
        user_id = in.readLong();
        latitude = in.readString();
        longitude = in.readString();
        web_address = in.readString();
        address = in.readString();
        address_image = in.readString();
        instagram_link = in.readString();
        instagram_title = in.readString();
        instagram_image = in.readString();
        facebook_link = in.readString();
        facebook_title = in.readString();
        facebook_image = in.readString();
        email_image = in.readString();
        phone_image = in.readString();
        web_address_image = in.readString();
        type = in.readString();
//        user_service = in.createTypedArrayList(UserService.CREATOR);
        user_detail = in.readParcelable(UserDetail.class.getClassLoader());
    }

    public static final Creator<UnityNetworkResponse> CREATOR = new Creator<UnityNetworkResponse>() {
        @Override
        public UnityNetworkResponse createFromParcel(Parcel in) {
            return new UnityNetworkResponse(in);
        }

        @Override
        public UnityNetworkResponse[] newArray(int size) {
            return new UnityNetworkResponse[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeLong(id);
        dest.writeLong(user_service_id);
        dest.writeString(description);
        dest.writeLong(user_id);
        dest.writeString(latitude);
        dest.writeString(longitude);
        dest.writeString(web_address);
        dest.writeString(address);
        dest.writeString(address_image);
        dest.writeString(instagram_link);
        dest.writeString(instagram_title);
        dest.writeString(instagram_image);
        dest.writeString(facebook_link);
        dest.writeString(facebook_title);
        dest.writeString(facebook_image);
        dest.writeString(email_image);
        dest.writeString(phone_image);
        dest.writeString(web_address_image);
        dest.writeString(type);
//        dest.writeTypedList(user_service);
//        dest.writeParcelable(user_detail, flags);
    }

    @NotNull
    @Override
    public String toString() {
        return "UnityNetworkResponse{" +
                "id=" + id +
                ", user_service_id=" + user_service_id +
                ", description='" + description + '\'' +
                ", user_id=" + user_id +
                ", latitude='" + latitude + '\'' +
                ", longitude='" + longitude + '\'' +
                ", web_address='" + web_address + '\'' +
                ", address='" + address + '\'' +
                ", address_image='" + address_image + '\'' +
                ", instagram_link='" + instagram_link + '\'' +
                ", instagram_title='" + instagram_title + '\'' +
                ", instagram_image='" + instagram_image + '\'' +
                ", facebook_link='" + facebook_link + '\'' +
                ", facebook_title='" + facebook_title + '\'' +
                ", facebook_image='" + facebook_image + '\'' +
                ", facebook_image='" + email_image + '\'' +
                ", facebook_image='" + phone_image + '\'' +
                ", facebook_image='" + web_address_image + '\'' +
                ", type='" + type + '\'' +
                ", user_service=" + user_service +
                ", user_detail=" + user_detail +
                '}';
    }
}
