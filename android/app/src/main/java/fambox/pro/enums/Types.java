package fambox.pro.enums;

import android.annotation.TargetApi;
import android.os.Build;
import android.view.View;

import androidx.annotation.ColorRes;
import androidx.annotation.DrawableRes;
import androidx.annotation.StringRes;

import fambox.pro.R;

public class Types {
    @TargetApi(Build.VERSION_CODES.M)
    public enum StatusBarConfigType {
        CLOCK_BLACK_STATUS_BAR_WHITE(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR, R.color.statusBarColorWhite),
        CLOCK_BLACK_STATUS_BAR_PURPLE_LIGHT(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR, R.color.statusBarColorPurpleLight),
        CLOCK_WHITE_STATUS_BAR_PURPLE(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY, R.color.statusBarColorPurple),
        CLOCK_WHITE_STATUS_BAR_PURPLE_DARK(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY, R.color.statusBarColorPurpleDark),
        CLOCK_BLACK_STATUS_BAR_PURPLE_LANGUAGE(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR, R.color.statusBarColorPurpleLanguage);

        private int systemUiVisibility;
        private int statusBarColor;

        StatusBarConfigType(int systemUiVisibility, @ColorRes int statusBarColor) {
            this.systemUiVisibility = systemUiVisibility;
            this.statusBarColor = statusBarColor;
        }

        public int getSystemUiVisibility() {
            return systemUiVisibility;
        }

        public int getStatusBarColor() {
            return statusBarColor;
        }
    }

    public enum InfoDialogText {
        TEXT_DUAL_PIN(R.string.title_dual_pin, R.string.dual_pin_description),
        //        TEXT_INFO(R.string),
        TEXT_NGO_S(R.string.title_ngo, R.string.ngo_description),
        TEXT_INFO_NETWORK(R.string.title_network, R.string.network_description),
        TEXT_HELP(R.string.title_help, R.string.help_description),
        TEXT_FORUMS(R.string.title_forums, R.string.forums_description),
        TEXT_ALERT_MESSAGE(R.string.title_alert_message, R.string.alert_message_description);

        private int title, text;

        InfoDialogText(@StringRes int title, @StringRes int text) {
            this.title = title;
            this.text = text;
        }

        public int getTitle() {
            return title;
        }

        public int getText() {
            return text;
        }
    }

    public enum RecordButtonType {
        PUSH_HOLD(R.drawable.push_green_background),
        COUNT_DOWN(R.drawable.push_gray_background),
        STOP_RECORD(R.drawable.push_red_background);

        private int mRecId;

        RecordButtonType(@DrawableRes int recId) {
            this.mRecId = recId;
        }

        public int getRecId() {
            return mRecId;
        }
    }
}
