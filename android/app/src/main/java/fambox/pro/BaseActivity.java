package fambox.pro;


import static fambox.pro.Constants.Key.KEY_COUNTRY_CHANGED;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;
import static fambox.pro.utils.applanguage.AppLanguage.LANGUAGE_PREFERENCES_KAY;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Objects;
import java.util.concurrent.TimeUnit;

import fambox.pro.network.ApiClient;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.applanguage.AppLanguage;
import fambox.pro.view.ChooseAppLanguageActivity;
import fambox.pro.view.ChooseCountryActivity;
import fambox.pro.view.DualPinActivity;
import fambox.pro.view.EditProfileActivity;
import fambox.pro.view.EmergencyContactActivity;
import fambox.pro.view.HelpActivity;
import fambox.pro.view.LoginPageActivity;
import fambox.pro.view.LoginWithBackActivity;
import fambox.pro.view.MainActivity;
import fambox.pro.view.NotificationActivity;
import fambox.pro.view.SplashActivity;
import fambox.pro.view.dialog.InfoDialog;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import q.rorbin.badgeview.QBadgeView;

public abstract class BaseActivity extends AppCompatActivity {

    private Toolbar toolbar;
    private Socket mSocket;
    private static int mNotificationCount;
    private QBadgeView mQBadgeView;
    private final Emitter.Listener mNotificationListener = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            if (args.length >= 2 && (int) args[0] == 19) {
                try {
                    JSONObject notification = new JSONObject(args[1].toString()).getJSONObject("data");
                    runOnUiThread(() -> {
                        try {
                            mNotificationCount = notification.getInt("notify_read_0_count");
                            if (mQBadgeView != null) {
                                mQBadgeView.setBadgeNumber(mNotificationCount);
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    });
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            if (mSocket != null && args.length >= 2 && (int) args[0] != 19) {
                mSocket.emit("signal", 19, new JSONObject());
            }
        }
    };

    private final Emitter.Listener onConnect = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            SafeYouApp.initChatSocket(getApplication(), mSocket.id());
        }
    };

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(LocaleHelper.onAttach(newBase, newBase.getSharedPreferences("locale", Activity.MODE_PRIVATE).getString(LANGUAGE_PREFERENCES_KAY, "en")));
    }
    public  void adjustFontScale(Configuration configuration, float scale) {

        configuration.fontScale = scale;
        DisplayMetrics metrics = getResources().getDisplayMetrics();
        WindowManager wm = (WindowManager) getSystemService(WINDOW_SERVICE);
        wm.getDefaultDisplay().getMetrics(metrics);
        metrics.scaledDensity = configuration.fontScale * metrics.density;
        getBaseContext().getResources().updateConfiguration(configuration, metrics);

    }
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        AppLanguage.getInstance(this).loadLocale();
        super.onCreate(savedInstanceState);
        if (LocaleHelper.getLanguage(this).equals("iw")) {
            getWindow().getDecorView().setLayoutDirection(View.LAYOUT_DIRECTION_RTL);
        }
        if (getLayout() != 0) {
            setContentView(getLayout());
        }

        if (BaseActivity.this instanceof MainActivity) {
            mSocket = ((SafeYouApp) getApplication()).getChatSocket("").getSocket();
            mSocket.on("connect", onConnect);
            if (!mSocket.isActive()) {
                mSocket.connect();
            }
            adjustFontScale( getResources().getConfiguration(),1.0f);
        }

        boolean isNotificationEnabled = SafeYouApp.getPreference(this)
                .getBooleanValue(Constants.Key.KEY_IS_NOTIFICATION_ENABLED, false);
        if (isNotificationEnabled) {
            notificationCount();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mQBadgeView != null) {
            mQBadgeView.setBadgeNumber(mNotificationCount);
        }
        openDialog();
    }

    protected abstract int getLayout();

    protected void addAppBar(@Nullable String toolbarDefaultTitle,
                             boolean statusBarColorLight,
                             boolean backEnable,
                             boolean nextEnable,
                             @Nullable String title,
                             boolean notificationEnable) {
        Objects.requireNonNull(getSupportActionBar()).setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
        getSupportActionBar().setDisplayShowCustomEnabled(true);
        getSupportActionBar().setElevation(0);
        getSupportActionBar().setCustomView(R.layout.toolbar);

        View mActionBar = getSupportActionBar().getCustomView();
        toolbar = mActionBar.findViewById(R.id.toolbarBase);
        toolbar.setTitle(toolbarDefaultTitle);
        // find views
        Button nextButton = mActionBar.findViewById(R.id.btnNextToolbar);
        ImageView notificationImage = mActionBar.findViewById(R.id.notificationView);
        notificationImage.setOnClickListener(v -> {
            nextActivity(BaseActivity.this, NotificationActivity.class);
            clearNotification();
        });

        toolbar.setSubtitle(title);

        if (statusBarColorLight) {
            if (BaseActivity.this instanceof LoginPageActivity) {
                toolbar.setBackgroundColor(getResources().getColor(R.color.login_page_background));
            } else {
                toolbar.setBackgroundColor(getResources().getColor(R.color.statusBarColorPurple));
            }
        } else {
            toolbar.setBackgroundColor(getResources().getColor(R.color.toolbar_background));
        }

        if (backEnable) {
            toolbar.setNavigationIcon(getResources().getDrawable(R.drawable.icon_back_white));
            if (toolbar.getNavigationIcon() != null) {
                toolbar.getNavigationIcon().setTint(getResources().getColor(R.color.white));
            }

            toolbar.setNavigationContentDescription(R.string.back_icon_description);
            toolbar.setNavigationOnClickListener(v -> {
                        if (BaseActivity.this instanceof DualPinActivity) {
                            ((DualPinActivity) BaseActivity.this).backCanceledIntent();
                        } else if (BaseActivity.this instanceof LoginWithBackActivity && isChangedCountry()) {
                            nextActivity(this, LoginPageActivity.class);
                        } else if (BaseActivity.this instanceof LoginPageActivity && isChangedCountry()) {
                            nextActivity(this, ChooseCountryActivity.class);
                        } else {
                            onBackPressed();
                        }
                    }
            );
        }

        if (nextEnable) {
            nextButton.setVisibility(View.VISIBLE);
            nextButton.setOnClickListener(v -> {
                if (BaseActivity.this instanceof ChooseCountryActivity) {
                    ((ChooseCountryActivity) BaseActivity.this).saveCountryCode();
                } else if (BaseActivity.this instanceof ChooseAppLanguageActivity) {
                    ((ChooseAppLanguageActivity) BaseActivity.this).saveLanguage();
                } else if (BaseActivity.this instanceof HelpActivity) {
                    ((HelpActivity) BaseActivity.this).nextClick();
                }
            });
        }

        if (notificationEnable) {
            notificationImage.setVisibility(View.VISIBLE);
            mQBadgeView = new QBadgeView(getApplicationContext());
            notificationImage.post(() -> mQBadgeView.bindTarget(toolbar)
                    .setShowShadow(false)
                    .setGravityOffset(notificationImage.getPivotX()
                                    + 10,
                            notificationImage.getPivotY()
                                    + 5, false)
                    .setBadgeBackgroundColor(getResources().getColor(R.color.white))
                    .setBadgeTextColor(getResources().getColor(R.color.textPurpleColor))
                    .setBadgeTextSize(getResources().getDimensionPixelOffset(R.dimen._3ssp), true)
                    .setExactMode(true));
        }
    }

    /* setBaseTitle used only main activity for change toolbar title with view pager*/
    public void setBaseTitle(String title) {
        toolbar.setSubtitle(title);
        if (Objects.equals(getResources().getString(R.string.help_title_key), title)) {
            toolbar.setSubtitle("");
            toolbar.setLogo(R.drawable.safe_you_text_logo);
        } else {
            toolbar.setLogo(null);
        }
    }

    public void setToolbarColor(int color) {
        toolbar.setBackgroundColor(color);
    }

    /* setDefaultTitle used only view more activity for change default title to forum name*/
    public void setDefaultTitle(String toolbarDefaultTitle) {
        if (toolbarDefaultTitle != null && toolbarDefaultTitle.length() >= 20) {
            toolbar.setTitle(toolbarDefaultTitle.substring(0, 20).concat("..."));
        } else {
            toolbar.setTitle(toolbarDefaultTitle);
        }
    }

    public static boolean checkLogin() {
        String username = SafeYouApp.getPreference().getStringValue(KEY_USER_PHONE, "");
        String password = SafeYouApp.getPreference().getStringValue(KEY_PASSWORD, "");
        return !(Objects.equals(username, "") && Objects.equals(password, ""));
    }

    public void nextActivity(Context context, Class<?> clazz) {
        Intent intent = new Intent(context, clazz);
        startActivity(intent);
    }

    public void nextActivity(Context context, Class<?> clazz, Bundle extra) {
        Intent intent = new Intent(context, clazz);
        intent.putExtras(extra);
        startActivity(intent);
    }

    public String getLocale() {
        return LocaleHelper.getLanguage(getBaseContext());
    }

    public String getCountryCode() {
        return SafeYouApp.getPreference(this)
                .getStringValue(KEY_COUNTRY_CODE, "");
    }

    public boolean isChangedCountry() {
        return SafeYouApp.getPreference(getApplicationContext()).getBooleanValue(KEY_COUNTRY_CHANGED, false);
    }

    protected void message(String message, SnackBar.SBType type) {
        SnackBar.make(this,
                findViewById(android.R.id.content),
                type,
                message).show();
    }

    private void clearNotification() {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("datetime", (TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()) + 4 * 60 * 60));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void notificationCount() {
        if (mSocket != null) {
            mSocket.on("signal", mNotificationListener);
            mSocket.emit("signal", 19, new JSONObject());
        }
    }

    private void openDialog() {
        ApiClient.setmOpenInfoDialogListener((errorCode, text) -> runOnUiThread(() -> {
            if (BaseActivity.this instanceof SplashActivity) {
                return;
            }
            String message = text;
            InfoDialog infoDialog = new InfoDialog(BaseActivity.this);
            String title = getString(R.string.error_text_key);
            if (BaseActivity.this instanceof EmergencyContactActivity) {
                if (errorCode == 422) {
                    message = getString(R.string.error_message_emergency_contact);
                }
            }
            infoDialog.setContent(title, message);
            infoDialog.setOnDismissListener(dialog -> {
                if (BaseActivity.this instanceof EditProfileActivity) {
                    finish();
                    overridePendingTransition(0, 0);
                    startActivity(getIntent());
                    overridePendingTransition(0, 0);
                }
            });
            if (!infoDialog.isShowing()) {
                if (!isFinishing()) {
                    //show dialog
                    infoDialog.show();
                }
            }
        }));
    }
}
