package fambox.pro.location;

import android.location.Location;

/** One-shot location access with no proprietary provider API. */
public interface LocationProvider {
    interface Callback {
        void onLocationAvailable(Location location);
        void onLocationUnavailable();
    }

    void getCurrentLocation(Callback callback);
    void cancel();
}
