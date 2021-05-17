package fambox.pro;


import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.tasks.Task;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Locale;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import fambox.pro.network.ApiClient;
import fambox.pro.network.SocketHandler;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.applanguage.AppLanguage;
import fambox.pro.view.ChooseAppLanguageActivity;
import fambox.pro.view.ChooseCountryActivity;
import fambox.pro.view.DualPinActivity;
import fambox.pro.view.EditProfileActivity;
import fambox.pro.view.HelpActivity;
import fambox.pro.view.LoginPageActivity;
import fambox.pro.view.LoginWithBackActivity;
import fambox.pro.view.MainActivity;
import fambox.pro.view.NotificationActivity;
import fambox.pro.view.dialog.InfoDialog;
import io.socket.emitter.Emitter;
import q.rorbin.badgeview.QBadgeView;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CHANGED;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;
import static io.nlopez.smartlocation.location.providers.LocationGooglePlayServicesProvider.REQUEST_CHECK_SETTINGS;

public abstract class BaseActivity extends AppCompatActivity {

    private Locale mLocale;
    private TextView actionBarTitle;
    private View mActionBar;
    private Toolbar toolbar;
    private static SocketHandler mSocketHandler;
    private static int mNotificationCount;
    private QBadgeView mQBadgeView;
    private final Emitter.Listener mNotificationListener = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            if (args[0] instanceof JSONObject) {
                JSONObject json = (JSONObject) args[0];
                runOnUiThread(() -> {
                    try {
                        mNotificationCount = json.getInt("count");
                        if (mQBadgeView != null) {
                            mQBadgeView.setBadgeNumber(mNotificationCount);
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                });
            }
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        new AppLanguage(this).loadLocale();
        super.onCreate(savedInstanceState);
        mLocale = getResources().getConfiguration().locale;
        if (getLayout() != 0) {
            setContentView(getLayout());
        }

        if (BaseActivity.this instanceof MainActivity) {
            mSocketHandler = ((SafeYouApp) getApplication()).getSocket();
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

    @Override
    protected void onPause() {
        super.onPause();
        if (mSocketHandler != null) {
            mSocketHandler.off("SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT#RESULT", mNotificationListener);
        }
    }

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

        mActionBar = getSupportActionBar().getCustomView();
        toolbar = mActionBar.findViewById(R.id.toolbarBase);
        toolbar.setTitle(toolbarDefaultTitle);
        // find views
        Button nextButton = mActionBar.findViewById(R.id.btnNextToolbar);
        ImageView notificationImage = mActionBar.findViewById(R.id.notificationView);
        notificationImage.setOnClickListener(v -> {
            nextActivity(BaseActivity.this, NotificationActivity.class);
            clearNotification();
        });

        actionBarTitle = mActionBar.findViewById(R.id.actionBarTitle);
        actionBarTitle.setText(title);

        if (statusBarColorLight) {
            if (BaseActivity.this instanceof LoginPageActivity) {
                toolbar.setBackgroundColor(getResources().getColor(R.color.statusBarColorPurpleLight));
            } else {
                toolbar.setBackgroundColor(getResources().getColor(R.color.statusBarColorPurple));
            }
        } else {
            toolbar.setBackgroundColor(getResources().getColor(R.color.statusBarColorPurpleDark));
        }

        if (backEnable) {
            if (BaseActivity.this instanceof LoginPageActivity) {
                toolbar.setNavigationIcon(getResources().getDrawable(R.drawable.icon_back));
            } else {
                toolbar.setNavigationIcon(getResources().getDrawable(R.drawable.icon_back_white));
            }
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
                                    + getResources().getDimensionPixelOffset(R.dimen._13sdp),
                            notificationImage.getPivotY()
                                    - getResources().getDimensionPixelOffset(R.dimen._1sdp), false)
                    .setBadgeBackgroundColor(getResources().getColor(R.color.white))
                    .setBadgeTextColor(getResources().getColor(R.color.textPurpleColor))
                    .setBadgeTextSize(getResources().getDimensionPixelOffset(R.dimen._4ssp), true)
//                    .setOnDragStateChangedListener(new Badge.OnDragStateChangedListener() {
//                        @Override
//                        public void onDragStateChanged(int dragState, Badge badge, View targetView) {
//                            if (Badge.OnDragStateChangedListener.STATE_SUCCEED == dragState) {
//                                Toast.makeText(BaseActivity.this, "Wow! its Cool", Toast.LENGTH_SHORT).show();
//                            }
//                        }
//                    })
                    .setExactMode(true));
        }
    }

    /* setBaseTitle used only main activity for change toolbar title with view pager*/
    public void setBaseTitle(String title) {
        actionBarTitle.setText(title);
    }

    /* setDefaultTitle used only view more activity for change default title to forum name*/
    public void setDefaultTitle(String toolbarDefaultTitle) {
        if (toolbarDefaultTitle != null && toolbarDefaultTitle.length() >= 20) {
            toolbar.setTitle(toolbarDefaultTitle.substring(0, 20).concat("..."));
        } else {
            toolbar.setTitle(toolbarDefaultTitle);
        }
    }

    private void setUpGps() {
        LocationRequest locationRequest = LocationRequest.create();

        //Setting priority of Location request to high
        locationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
        locationRequest.setInterval(10000);

        //5 sec Time interval for location update
        locationRequest.setFastestInterval(5000);
        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest);
        builder.setNeedBle(true);
        builder.setAlwaysShow(true);

        Task<LocationSettingsResponse> result2 =
                LocationServices.getSettingsClient(this).checkLocationSettings(builder.build());
        result2.addOnCompleteListener(task -> {
            try {
                task.getResult(ApiException.class);
                // All location settings are satisfied. The client can initialize location
                // requests here.
            } catch (ApiException exception) {
                switch (exception.getStatusCode()) {
                    case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                        // Location settings are not satisfied. But could be fixed by showing the
                        // user a dialog.
                        try {
                            // Cast to a resolvable exception.
                            ResolvableApiException resolvable = (ResolvableApiException) exception;
                            // Show the dialog by calling startResolutionForResult(),
                            // and check the result in onActivityResult().
                            resolvable.startResolutionForResult(
                                    BaseActivity.this,
                                    REQUEST_CHECK_SETTINGS);
                        } catch (IntentSender.SendIntentException e) {
                            // Ignore the error.
                        } catch (ClassCastException e) {
                            // Ignore, should be an impossible error.
                        }
                        break;
                    case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                        // Location settings are not satisfied. However, we have no way to fix the
                        // settings so we won't show the dialog.
                        break;
                }
            }
        });
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
        return mLocale.getLanguage();
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
            mSocketHandler.emit("SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT", jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void notificationCount() {
        if (mSocketHandler != null) {
            mSocketHandler.on("SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT#RESULT", mNotificationListener);

            try {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("datetime", (TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis())) + 4 * 60 * 60);
                if (mSocketHandler != null) {
                    mSocketHandler.emit("SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT", jsonObject);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private void openDialog() {
        ApiClient.setmOpenInfoDialogListener((title, text) -> runOnUiThread(() -> {
            InfoDialog infoDialog = new InfoDialog(BaseActivity.this);
            infoDialog.setContent(title, text);
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
