package fambox.pro;

import static fambox.pro.Constants.Key.KEY_BIRTHDAY;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;

import androidx.appcompat.app.AppCompatDelegate;

import java.util.Calendar;

import fambox.pro.network.APIService;
import fambox.pro.network.ApiClient;
import fambox.pro.network.SocketHandler;
import fambox.pro.network.SocketHandlerPrivateChat;
import fambox.pro.utils.SharedPreferenceUtils;
import fambox.pro.utils.applanguage.AppLanguage;

public class SafeYouApp extends Application {
    @SuppressLint("StaticFieldLeak")
    private static Context mInstance;
    @SuppressLint("StaticFieldLeak")
    private static SharedPreferenceUtils preference;
    private static String countryCode;
    private static String locale;

    private static APIService chatApi;

    @Override
    public void onCreate() {
        super.onCreate();
        mInstance = getApplicationContext();
        preference = SharedPreferenceUtils.getInstance(getContext());
        countryCode = preference.getStringValue(KEY_COUNTRY_CODE, "");
        locale = LocaleHelper.getLanguage(getBaseContext());
        configNightMode();

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
        AppLanguage.getInstance(context).loadLocale();
        return ApiClient.getAdapter(context);
    }

    public static void initChatSocket(Context context, String socketId) {
        chatApi = ApiClient.getChatAdapter(context, socketId,
                getPreference().getStringValue(KEY_COUNTRY_CODE, ""));
    }

    public static APIService getChatApiService() {
        return chatApi;
    }

    public SocketHandler getSocket() {
        return SocketHandler.getInstance("",
                getPreference().getStringValue(KEY_COUNTRY_CODE, ""));
    }

    public SocketHandlerPrivateChat getChatSocket(String accessToken) {
        return SocketHandlerPrivateChat.getInstance(accessToken,
                getPreference().getStringValue(KEY_COUNTRY_CODE, ""));
    }

    public static APIService getApiService() {
        AppLanguage.getInstance(getContext()).loadLocale();
        return ApiClient.getAdapter(getContext());
    }

    public static boolean isMinorUser() {
        String birthday = SafeYouApp.getPreference(getContext()).getStringValue(KEY_BIRTHDAY, "");
        if (!birthday.isEmpty()) {
            String[] birthDay = birthday.split("/");
            if (birthDay.length == 3) {
                int ageInt = getAge(Integer.parseInt(birthDay[2]),
                        Integer.parseInt(birthDay[1]), Integer.parseInt(birthDay[0]));
                return ageInt < 18;
            }
        }
        return false;
    }

    public static SharedPreferenceUtils getPreference() {
        return preference;
    }

    public static SharedPreferenceUtils getPreference(Context context) {
        return SharedPreferenceUtils.getInstance(context);
    }

    private void configNightMode() {
        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
        if (isDarkModeEnabled) {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
        } else {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);

        }
    }

    private static int getAge(int year, int month, int day) {
        Calendar c = Calendar.getInstance();
        c.set(Calendar.YEAR, year);
        c.set(Calendar.MONTH, month);
        c.set(Calendar.DAY_OF_MONTH, day);

        Calendar dob = Calendar.getInstance();
        dob.setTimeInMillis(c.getTimeInMillis());
        Calendar today = Calendar.getInstance();
        int age = today.get(Calendar.YEAR) - dob.get(Calendar.YEAR);
        if (today.get(Calendar.DAY_OF_MONTH) < dob.get(Calendar.DAY_OF_MONTH)) {
            age--;
        }
        return age;
    }
}
