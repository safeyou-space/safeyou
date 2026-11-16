package fambox.pro;

import android.os.Parcel;
import android.os.Parcelable;

public class Two implements Parcelable {
    public Two() {
    }

    protected Two(Parcel in) {
    }

    public static final Creator<Two> CREATOR = new Creator<Two>() {
        @Override
        public Two createFromParcel(Parcel in) {
            return new Two(in);
        }

        @Override
        public Two[] newArray(int size) {
            return new Two[size];
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
