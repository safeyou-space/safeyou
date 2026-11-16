package fambox.pro.utils.applanguage;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import fambox.pro.LocaleHelper;

public class AppLanguage {

    private static final String LOAD_LOCALE_KAY = "locale";
    public static final String LANGUAGE_PREFERENCES_KAY = "language";
    private static final String DEFAULT_LANGUAGE_KAY = "en";
    private SharedPreferences preferences;

    private final Context context;
    private static AppLanguage instance;

    private AppLanguage(Context context) {
        this.context = context;
        if (context != null) {
            preferences = context.getSharedPreferences(LOAD_LOCALE_KAY, Activity.MODE_PRIVATE);
        }
    }

    public static AppLanguage getInstance(Context context) {
        if (instance == null) {
            instance = new AppLanguage(context);
        }
        return instance;
    }

    public void loadLocale() {
        if (preferences != null) {
            String language = preferences.getString(LANGUAGE_PREFERENCES_KAY, DEFAULT_LANGUAGE_KAY);
            if (language != null) {
                LocaleHelper.setLocale(context, language);
            }
        }
    }

    public void changeLang(String lang) {
        if (lang.equalsIgnoreCase("")) {
            return;
        }
        if (lang.equals("iw")) {
            lang = "ku";
        }
        saveLocale(lang);
        LocaleHelper.setLocale(context, lang);
    }

    private void saveLocale(String lang) {
        if (preferences != null) {
            SharedPreferences.Editor editor = preferences.edit();
            editor.putString(LANGUAGE_PREFERENCES_KAY, lang);
            editor.apply();
        }
    }
}
