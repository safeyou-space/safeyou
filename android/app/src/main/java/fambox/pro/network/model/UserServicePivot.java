package fambox.pro.network.model;

import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class UserServicePivot implements Parcelable {

    @SerializedName("service_id")
    @Expose
    private long service_id;
    @SerializedName("user_id")
    @Expose
    private long user_id;

    protected UserServicePivot(Parcel in) {
        service_id = in.readLong();
        user_id = in.readLong();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeLong(service_id);
        dest.writeLong(user_id);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<UserServicePivot> CREATOR = new Creator<UserServicePivot>() {
        @Override
        public UserServicePivot createFromParcel(Parcel in) {
            return new UserServicePivot(in);
        }

        @Override
        public UserServicePivot[] newArray(int size) {
            return new UserServicePivot[size];
        }
    };

    public long getServiceId() {
        return service_id;
    }

    public void setServiceId(long serviceId) {
        this.service_id = serviceId;
    }

    public long getUserId() {
        return user_id;
    }

    public void setUserId(long userId) {
        this.user_id = userId;
    }

    @NonNull
    @Override
    public String toString() {
        return "UserServicePivot{" +
                "service_id=" + service_id +
                ", user_id=" + user_id +
                '}';
    }
}
