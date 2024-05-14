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
        CLOCK_BLACK_STATUS_BAR_WHITE_OTHER(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR, R.color.login_page_background),
        CLOCK_BLACK_STATUS_BAR_PURPLE_LIGHT(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR, R.color.statusBarColorPurpleLight),
        CLOCK_WHITE_STATUS_BAR_PURPLE(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY, R.color.statusBarColorPurple),
        CLOCK_WHITE_STATUS_BAR_PURPLE_DARK(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY, R.color.toolbar_background),
        CLOCK_WHITE_STATUS_BAR_HELP_FRAGMENT_COLOR(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY, R.color.helpScreenBackground),
        CLOCK_BLACK_STATUS_BAR_PURPLE_LANGUAGE(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR, R.color.statusBarColorPurpleLanguage);

        private final int systemUiVisibility;
        private final int statusBarColor;

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
        TEXT_DUAL_PIN(R.string.security, R.string.security_introduction_text_key),
        TEXT_NGO_S(R.string.network_title, R.string.ngos_description_text_key),
        TEXT_INFO_NETWORK(R.string.support_title_key, R.string.intro_support_text_key),
        TEXT_HELP(R.string.help_title_key, R.string.help_section_description_text_key),
        TEXT_FORUMS(R.string.forums_title_key, R.string.forums_description_text_key),
        TEXT_ALERT_MESSAGE(R.string.title_alert_message, R.string.alert_message_description),
        TEXT_PRIVATE_MESSAGE(R.string.messages_title_key, R.string.intro_private_messages_text_key);

        private final int title;
        private final int text;

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

        private final int mRecId;

        RecordButtonType(@DrawableRes int recId) {
            this.mRecId = recId;
        }

        public int getRecId() {
            return mRecId;
        }
    }
}
