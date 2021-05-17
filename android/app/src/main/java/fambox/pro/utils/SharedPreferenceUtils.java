package fambox.pro.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;

public class SharedPreferenceUtils {
    private static SharedPreferenceUtils mSharedPreferenceUtils;
    protected Context mContext;
    private SharedPreferences mSharedPreferences;
    private SharedPreferences.Editor mSharedPreferencesEditor;
    private SaveDataCallback mSaveDataCallback;

    @SuppressLint("CommitPrefEdits")
    private SharedPreferenceUtils(Context context) {
        mContext = context;
        mSharedPreferences = context.getSharedPreferences("pref_safe_you", Context.MODE_PRIVATE);
        mSharedPreferencesEditor = mSharedPreferences.edit();
    }

    /**
     * Creates single instance of SharedPreferenceUtils
     *
     * @param context context of Activity or Service
     * @return Returns instance of SharedPreferenceUtils
     */
    public static synchronized SharedPreferenceUtils getInstance(Context context) {

        if (mSharedPreferenceUtils == null) {
            mSharedPreferenceUtils = new SharedPreferenceUtils(context);
        }
        return mSharedPreferenceUtils;
    }

    /**
     * Stores String value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    public SharedPreferenceUtils setValue(String key, String value) {
        mSharedPreferencesEditor.putString(key, value);
        commit();
        return this;
    }

    /**
     * Stores int value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    public void setValue(String key, int value) {
        mSharedPreferencesEditor.putInt(key, value);
        commit();
    }

    /**
     * Stores Double value in String format in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    public void setValue(String key, double value) {
        setValue(key, Double.toString(value));
    }

    /**
     * Stores long value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    public void setValue(String key, long value) {
        mSharedPreferencesEditor.putLong(key, value);
        commit();
    }

    /**
     * Stores boolean value in preference
     *
     * @param key   key of preference
     * @param value value for that key
     */
    public void setValue(String key, boolean value) {
        mSharedPreferencesEditor.putBoolean(key, value);
        commit();
    }

    /**
     * Retrieves String value from preference
     *
     * @param key          key of preference
     * @param defaultValue default value if no key found
     */
    public String getStringValue(String key, String defaultValue) {
        return mSharedPreferences.getString(key, defaultValue);
    }

    /**
     * Retrieves int value from preference
     *
     * @param key          key of preference
     * @param defaultValue default value if no key found
     */
    public int getIntValue(String key, int defaultValue) {
        return mSharedPreferences.getInt(key, defaultValue);
    }

    /**
     * Retrieves long value from preference
     *
     * @param key          key of preference
     * @param defaultValue default value if no key found
     */
    public long getLongValue(String key, long defaultValue) {
        return mSharedPreferences.getLong(key, defaultValue);
    }

    /**
     * Retrieves boolean value from preference
     *
     * @param keyFlag      key of preference
     * @param defaultValue default value if no key found
     */
    public boolean getBooleanValue(String keyFlag, boolean defaultValue) {
        return mSharedPreferences.getBoolean(keyFlag, defaultValue);
    }

    /**
     * Removes key from preference
     *
     * @param key key of preference that is to be deleted
     */
    public void removeKey(String key) {
        if (mSharedPreferencesEditor != null) {
            mSharedPreferencesEditor.remove(key);
            commit();
        }
    }


    /**
     * Clears all the preferences stored
     */
    public void clear() {
        mSharedPreferencesEditor.clear();
        commit();
    }

    /**
     * set callback object.
     *
     * @param mSaveDataCallback new object SaveDataCallback
     */
    public void setSaveDataCallback(SaveDataCallback mSaveDataCallback) {
        this.mSaveDataCallback = mSaveDataCallback;
    }

    /**
     * commit save data shared preferences.
     */
    private void commit() {
        if (mSaveDataCallback != null) {
            if (mSharedPreferencesEditor.commit()) {
                mSaveDataCallback.onSuccess();
            } else {
                mSaveDataCallback.onError();
            }
        } else {
            mSharedPreferencesEditor.commit();
        }
    }

    /**
     * Shared preference save data callBack.
     *
     * @see SaveDataCallback
     */
    public interface SaveDataCallback {
        // Successfully saved
        void onSuccess();

        // Not saved
        void onError();
    }
}
