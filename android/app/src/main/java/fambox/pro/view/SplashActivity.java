package fambox.pro.view;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import androidx.annotation.NonNull;

import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.Objects;

import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.audiorecordservice.AudioRecordService;
import fambox.pro.network.model.RefreshTokenResponse;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.SnackBar;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_ACCESS_TOKEN;
import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME;
import static fambox.pro.Constants.Key.KEY_REFRESH_TOKEN;

public class SplashActivity extends BaseActivity {
    private String mPreferenceRealPin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        boolean isFirst = SafeYouApp.getPreference().getBooleanValue(KEY_LOG_IN_FIRST_TIME, false);
        mPreferenceRealPin =
                SafeYouApp.getPreference(this).getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");

        if (isMyServiceRunning()) {
            stopService(new Intent(this, AudioRecordService.class));
            finish();
        }

        if (Connectivity.isConnected(this)) {
            if (!isFirst) {
                nextActivity(this, ChooseCountryActivity.class);
                finish();
            } else if (checkLogin()) {
                checkIsLogined();
            } else {
                nextActivity(this, LoginWithBackActivity.class);
                finish();
            }
        } else {
            message(getResources().getString(R.string.internet_connection), SnackBar.SBType.ERROR);
            new Handler().postDelayed(this::finish, 3000);
        }
    }

    @Override
    protected int getLayout() {
        return 0;
    }

    private void checkIsLogined() {
        HashMap<String, String> refreshToken = new HashMap<>();
        refreshToken.put("refresh_token", SafeYouApp.getPreference()
                .getStringValue(KEY_REFRESH_TOKEN, ""));

        SafeYouApp.getApiService(this).refreshToken(getCountryCode(), getLocale(), refreshToken)
                .enqueue(new Callback<RefreshTokenResponse>() {
                    @Override
                    public void onResponse(@NonNull Call<RefreshTokenResponse> call, @NonNull Response<RefreshTokenResponse> response) {
                        if (response.code() == HttpURLConnection.HTTP_OK) {
                            RefreshTokenResponse tokenResponse = response.body();
                            if (tokenResponse != null) {
                                SafeYouApp.getPreference().setValue(KEY_REFRESH_TOKEN, tokenResponse.getRefreshToken());
                                SafeYouApp.getPreference().setValue(KEY_ACCESS_TOKEN, tokenResponse.getAccessToken());

                                SafeYouApp.getApiService();

                                if (!Objects.equals(mPreferenceRealPin, "")) {
                                    nextActivity(SplashActivity.this, PassKeypadActivity.class);
                                } else if (Objects.equals(mPreferenceRealPin, "")) {
                                    nextActivity(SplashActivity.this, MainActivity.class);
                                }
                                finish();
                            }
                        }
                    }

                    @Override
                    public void onFailure(@NonNull Call<RefreshTokenResponse> call, @NonNull Throwable t) {
                        nextActivity(SplashActivity.this, LoginWithBackActivity.class);
                        finish();
                    }
                });
    }

    private boolean isMyServiceRunning() {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        if (manager != null) {
            for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
                if (AudioRecordService.class.getName().equals(service.service.getClassName())) {
                    return true;
                }
            }
        }
        return false;
    }
}
