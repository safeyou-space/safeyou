package fambox.pro;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;

import org.jetbrains.annotations.NotNull;

import fambox.pro.network.APIService;
import fambox.pro.network.ApiClient;
import fambox.pro.network.SocketHandler;
import fambox.pro.utils.SharedPreferenceUtils;
import fambox.pro.utils.applanguage.AppLanguage;

import static com.facebook.FacebookSdk.setAutoLogAppEventsEnabled;
import static fambox.pro.Constants.Key.KEY_ACCESS_TOKEN;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

public class SafeYouApp extends Application implements Application.ActivityLifecycleCallbacks {
    @SuppressLint("StaticFieldLeak")
    private static Context mInstance;
    @SuppressLint("StaticFieldLeak")
    private static SharedPreferenceUtils preference;
    private boolean onStoped = false;
    private int activityReferences = 0;
    private boolean isActivityChangingConfigurations = false;
    private static String countryCode;
    private static String locale;

    @Override
    public void onCreate() {
        super.onCreate();
        registerActivityLifecycleCallbacks(this);
        mInstance = getApplicationContext();
        preference = SharedPreferenceUtils.getInstance(getContext());
        countryCode = preference.getStringValue(KEY_COUNTRY_CODE, "");
        locale = getResources().getConfiguration().locale.getLanguage();

        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this);
        setAutoLogAppEventsEnabled(true);

        FacebookSdk.setAutoInitEnabled(true);
        FacebookSdk.fullyInitialize();
        FacebookSdk.setAdvertiserIDCollectionEnabled(true);


    }

    public static Context getContext() {
        return mInstance;
    }

    public static String getCountryCode() {
        return countryCode;
    }

    public static String getLocale() {
        return locale;
    }

    public static APIService getApiService(Context context) {
        new AppLanguage(context).loadLocale();
        return ApiClient.getAdapter(context, countryCode, locale);
    }

    public SocketHandler getSocket() {
        return SocketHandler.getInstance(getPreference().getStringValue(KEY_ACCESS_TOKEN, ""),
                getPreference().getStringValue(KEY_COUNTRY_CODE, ""));
    }

    public static APIService getApiService() {
        new AppLanguage(getContext()).loadLocale();
        return ApiClient.getAdapter(getContext(), countryCode, locale);
    }

    public static SharedPreferenceUtils getPreference() {
        return preference;
    }

    public static SharedPreferenceUtils getPreference(Context context) {
        return SharedPreferenceUtils.getInstance(context);
    }

    @Override
    public void onActivityCreated(@NotNull Activity activity, Bundle savedInstanceState) {
    }


    @Override
    public void onActivityResumed(@NotNull Activity activity) {
    }

    @Override
    public void onActivityPaused(@NotNull Activity activity) {
    }


    @Override
    public void onActivitySaveInstanceState(@NotNull Activity activity, @NotNull Bundle outState) {
    }

    @Override
    public void onActivityDestroyed(@NotNull Activity activity) {
    }

    @Override
    public void onActivityStarted(@NotNull Activity activity) {
        if (++activityReferences == 1 && !isActivityChangingConfigurations) {
            // App enters foreground
            String preferenceRealPin = SafeYouApp.getPreference(activity)
                    .getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
            String preferenceFakePin = SafeYouApp.getPreference(activity)
                    .getStringValue(Constants.Key.KEY_SHARED_FAKE_PIN, "");

//
//            if (!preferenceRealPin.equals("") || !preferenceFakePin.equals("") && onStoped){
//                Intent intent = new Intent(this, PassKeypadActivity.class);
//                intent.addFlags(FLAG_ACTIVITY_NEW_TASK);
//                startActivity(intent);
//            }
        }
    }

    @Override
    public void onActivityStopped(Activity activity) {
        isActivityChangingConfigurations = activity.isChangingConfigurations();
        if (--activityReferences == 0 && !isActivityChangingConfigurations) {
            // App enters background
            onStoped = true;

        }
    }
}
