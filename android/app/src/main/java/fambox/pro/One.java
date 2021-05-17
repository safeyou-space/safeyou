package fambox.pro;

import android.os.Parcel;
import android.os.Parcelable;

public class One implements Parcelable {
    public One() {
    }

    protected One(Parcel in) {
    }

    public static final Creator<One> CREATOR = new Creator<One>() {
        @Override
        public One createFromParcel(Parcel in) {
            return new One(in);
        }

        @Override
        public One[] newArray(int size) {
            return new One[size];
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
