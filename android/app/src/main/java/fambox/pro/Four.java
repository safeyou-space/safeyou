package fambox.pro;

import android.os.Parcel;
import android.os.Parcelable;

public class Four implements Parcelable {
    public Four() {
    }

    protected Four(Parcel in) {
    }

    public static final Creator<Four> CREATOR = new Creator<Four>() {
        @Override
        public Four createFromParcel(Parcel in) {
            return new Four(in);
        }

        @Override
        public Four[] newArray(int size) {
            return new Four[size];
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
