package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;

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

public class SplashActivity extends BaseActivity {
    private String mPreferenceRealPin;

    private boolean isAnimationFinished = false;
    private Class<?> nextActivity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ImageView splashImageView = findViewById(R.id.splashImage);

        // Load the animation
        Animation slideInAnimation = AnimationUtils.loadAnimation(this, R.anim.slide_in_animation);
        slideInAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                // Animation started
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                isAnimationFinished = true;
                if (nextActivity != null) {
                    nextActivity(SplashActivity.this, nextActivity);
                    finish();
                }
            }

            @Override
            public void onAnimationRepeat(Animation animation) {
                // Animation repeated
            }
        });
        splashImageView.startAnimation(slideInAnimation);


        mPreferenceRealPin =
                SafeYouApp.getPreference(this).getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
        if (isMyServiceRunning()) {
            stopService(new Intent(this, AudioRecordService.class));
            finish();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        boolean isFirst = SafeYouApp.getPreference().getBooleanValue(KEY_LOG_IN_FIRST_TIME, false);
        if (Connectivity.isConnected(this)) {
            if (!isFirst) {
                if (isAnimationFinished) {
                    nextActivity(this, ChooseCountryActivity.class);
                    finish();
                } else {
                    nextActivity = ChooseCountryActivity.class;
                }
            } else {
                checkIsLogined();
            }
        } else {
            message(getString(R.string.check_internet_connection_text_key), SnackBar.SBType.ERROR);
            new Handler().postDelayed(this::finish, 3000);
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_splash;
    }

    private void checkIsLogined() {
        HashMap<String, String> refreshToken = new HashMap<>();
        refreshToken.put("refresh_token", "refresh_token");

        SafeYouApp.getApiService(this).refreshToken(getCountryCode(), getLocale(), refreshToken)
                .enqueue(new Callback<RefreshTokenResponse>() {
                    @Override
                    public void onResponse(@NonNull Call<RefreshTokenResponse> call, @NonNull Response<RefreshTokenResponse> response) {
                        if (response.code() == HttpURLConnection.HTTP_OK) {
                            RefreshTokenResponse tokenResponse = response.body();
                            if (tokenResponse != null) {
                                SafeYouApp.getApiService();
                                if (isAnimationFinished) {
                                    if (!Objects.equals(mPreferenceRealPin, "")) {
                                        nextActivity(SplashActivity.this, PassKeypadActivity.class);
                                    } else if (Objects.equals(mPreferenceRealPin, "")) {
                                        nextActivity(SplashActivity.this, MainActivity.class);
                                    }
                                    finish();
                                } else {
                                    if (!Objects.equals(mPreferenceRealPin, "")) {
                                        nextActivity = PassKeypadActivity.class;
                                    } else if (Objects.equals(mPreferenceRealPin, "")) {
                                        nextActivity = MainActivity.class;
                                    }
                                }
                            }
                        }
                    }

                    @Override
                    public void onFailure(@NonNull Call<RefreshTokenResponse> call, @NonNull Throwable t) {
                        if (isAnimationFinished) {
                            nextActivity(SplashActivity.this, LoginWithBackActivity.class);
                            finish();
                        } else {
                            nextActivity = LoginWithBackActivity.class;
                        }

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
