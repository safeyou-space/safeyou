package fambox.pro.location;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.core.content.ContextCompat;
import androidx.core.location.LocationManagerCompat;
import androidx.core.os.CancellationSignal;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Uses Android location providers without depending on Google Play Services.
 * Delivers exactly one success/failure callback on the main thread.
 */
public final class AndroidLocationProvider implements LocationProvider {
    private static final String TAG = "AndroidLocationProvider";
    private static final long NETWORK_TIMEOUT_MS = 5000;
    private static final long GPS_TIMEOUT_MS = 10000;

    private final Context context;
    private final LocationManager manager;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    private CancellationSignal signal;
    private Runnable timeout;
    private Callback callback;
    private int generation;

    public AndroidLocationProvider(Context context) {
        this.context = context.getApplicationContext();
        manager = (LocationManager) Objects.requireNonNull(
                this.context.getSystemService(Context.LOCATION_SERVICE));
    }

    public static boolean isLocationEnabled(Context context) {
        LocationManager manager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        return manager != null && LocationManagerCompat.isLocationEnabled(manager);
    }

    @Override
    public void getCurrentLocation(Callback newCallback) {
        Objects.requireNonNull(newCallback, "callback");
        mainHandler.post(() -> {
            cancelInternal();
            callback = newCallback;
            int requestGeneration = generation;
            boolean fine = ContextCompat.checkSelfPermission(context,
                    Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
            boolean coarse = ContextCompat.checkSelfPermission(context,
                    Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;
            if ((!fine && !coarse) || !LocationManagerCompat.isLocationEnabled(manager)) {
                finishUnavailable(requestGeneration);
                return;
            }

            List<String> providers = new ArrayList<>(2);
            // A de-Googled device may not register a NETWORK_PROVIDER at all.
            if (isProviderUsable(LocationManager.NETWORK_PROVIDER)) {
                providers.add(LocationManager.NETWORK_PROVIDER);
            }
            if (fine && isProviderUsable(LocationManager.GPS_PROVIDER)) {
                providers.add(LocationManager.GPS_PROVIDER);
            }
            requestFrom(providers, 0, requestGeneration);
        });
    }

    private boolean isProviderUsable(String provider) {
        try {
            return manager.isProviderEnabled(provider);
        } catch (SecurityException | IllegalArgumentException e) {
            return false;
        }
    }

    private void requestFrom(List<String> providers, int index, int requestGeneration) {
        if (requestGeneration != generation) return;
        if (index >= providers.size()) {
            finishUnavailable(requestGeneration);
            return;
        }

        String provider = providers.get(index);
        CancellationSignal requestSignal = new CancellationSignal();
        signal = requestSignal;
        Runnable advance = () -> {
            if (requestGeneration != generation || signal != requestSignal) return;
            clearPending();
            requestFrom(providers, index + 1, requestGeneration);
        };
        timeout = advance;
        mainHandler.postDelayed(advance, LocationManager.NETWORK_PROVIDER.equals(provider)
                ? NETWORK_TIMEOUT_MS : GPS_TIMEOUT_MS);
        try {
            LocationManagerCompat.getCurrentLocation(manager, provider, requestSignal,
                    runnable -> mainHandler.post(runnable), location -> {
                        if (requestGeneration != generation || signal != requestSignal) return;
                        clearPending();
                        if (location == null) {
                            requestFrom(providers, index + 1, requestGeneration);
                        } else {
                            Callback result = callback;
                            cancelInternal();
                            if (result != null) result.onLocationAvailable(location);
                        }
                    });
        } catch (SecurityException | IllegalArgumentException e) {
            Log.w(TAG, "Unable to request location from " + provider);
            advance.run();
        }
    }

    private void finishUnavailable(int requestGeneration) {
        if (requestGeneration != generation) return;
        Callback result = callback;
        cancelInternal();
        if (result != null) result.onLocationUnavailable();
    }

    private void clearPending() {
        if (timeout != null) mainHandler.removeCallbacks(timeout);
        timeout = null;
        if (signal != null) signal.cancel();
        signal = null;
    }

    private void cancelInternal() {
        generation++;
        clearPending();
        callback = null;
    }

    @Override
    public void cancel() {
        mainHandler.post(this::cancelInternal);
    }
}
