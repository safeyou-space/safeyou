package fambox.pro;

import android.os.Parcel;
import android.os.Parcelable;

public class Three implements Parcelable {
    public Three() {
    }

    protected Three(Parcel in) {
    }

    public static final Creator<Three> CREATOR = new Creator<Three>() {
        @Override
        public Three createFromParcel(Parcel in) {
            return new Three(in);
        }

        @Override
        public Three[] newArray(int size) {
            return new Three[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
    }
}
