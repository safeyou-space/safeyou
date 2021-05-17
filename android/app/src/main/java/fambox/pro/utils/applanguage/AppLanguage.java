package fambox.pro.utils.applanguage;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.util.DisplayMetrics;
import android.util.Log;

import java.util.Locale;

public class AppLanguage {

    private static final String LOAD_LOCALE_KAY = "locale";
    public static final String LANGUAGE_PREFERENCES_KAY = "language";
    private static final String DEFAULT_LANGUAGE_KAY = "en";
    private SharedPreferences preferences;

    private Context context;

    public AppLanguage(Context context) {
        this.context = context;
        if (context != null) {
            preferences = context.getSharedPreferences(LOAD_LOCALE_KAY, Activity.MODE_PRIVATE);
        }
    }

    public void loadLocale() {
        if (preferences != null) {
            String language = preferences.getString(LANGUAGE_PREFERENCES_KAY, DEFAULT_LANGUAGE_KAY);
            if (language != null) {
                changeLang(language);
            }
        }
    }

    public void changeLang(String lang) {
        if (lang.equalsIgnoreCase("")) {
            return;
        }
        Locale myLocale = new Locale(lang);
        saveLocale(lang);
        if (context != null) {
            Resources res = context.getResources();
            DisplayMetrics dm = res.getDisplayMetrics();
            android.content.res.Configuration conf = res.getConfiguration();
            conf.setLocale(myLocale);
            res.updateConfiguration(conf, dm);
        }
    }

    private void saveLocale(String lang) {
        if (preferences != null) {
            SharedPreferences.Editor editor = preferences.edit();
            editor.putString(LANGUAGE_PREFERENCES_KAY, lang);
            editor.apply();
        }
    }
}
