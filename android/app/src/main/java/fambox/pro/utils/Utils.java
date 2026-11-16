package fambox.pro.utils;

import android.app.Activity;
import android.os.Build;
import android.text.Editable;
import android.text.Html;
import android.text.Spanned;
import android.text.SpannedString;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.core.content.ContextCompat;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

import fambox.pro.enums.Types;

public class Utils {

    public enum PercentageType {
        NUMBER_TO_PERCENTAGE,
        PERCENTAGE_TO_NUMBER
    }

    public static void setStatusBarColor(Activity activity, Types.StatusBarConfigType statusBarConfigType) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            View decor = activity.getWindow().getDecorView();
            decor.setSystemUiVisibility(statusBarConfigType.getSystemUiVisibility());
            Window window = activity.getWindow();
            // clear FLAG_TRANSLUCENT_STATUS flag:
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            // add FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS flag to the window
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            // finally change the color
            window.setStatusBarColor(ContextCompat.getColor(activity, statusBarConfigType.getStatusBarColor()));
        }
    }

    public static float percentageCalculator(int x, int y, PercentageType percentageType) {
        if (percentageType == PercentageType.PERCENTAGE_TO_NUMBER) {
            return (x / 100f) * y;
        }
        return (x * 100f) / y;
    }

    public static String millisecondsToMinute(int millis) {
        return String.format(Locale.ENGLISH, "%02d:%02d",
                TimeUnit.MILLISECONDS.toMinutes(millis),
                TimeUnit.MILLISECONDS.toSeconds(millis) -
                        TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millis)));
    }

    public static String getEditableToString(Editable editable) {
        if (editable != null) {
            return editable.toString();
        } else {
            return "";
        }
    }

    public static double convertStringToDuple(String convertedValue) {
        double number;
        try {
            number = Double.parseDouble(convertedValue);
        } catch (NumberFormatException | NullPointerException nfe) {
            number = 0.0d;
        }
        return number;
    }

    public static String timeUTC(String time, String locale) {
        return timeUTC(time, locale, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "dd/MM/YY, HH:mm");
    }

    public static String chatReplyTime(String time) {
        return timeUTC(time, Locale.US.getLanguage(), "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "HH:mm");
    }

    public static String timeUTC(String time, String locale, String inputFormatText, String outputFormatText) {
        if (time == null) {
            return "";
        }
        SimpleDateFormat inputFormat = new SimpleDateFormat(inputFormatText, new Locale(locale));
        SimpleDateFormat outputFormat = new SimpleDateFormat(outputFormatText, new Locale(locale));

        Date date;
        String outputFormatDate = null;

        inputFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

        try {
            date = inputFormat.parse(time);
            if (date != null) {
                outputFormatDate = outputFormat.format(date);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return outputFormatDate;
    }

    public static Spanned convertStringToHtml(String text) {
        if (text != null)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                return Html.fromHtml(text, Html.FROM_HTML_MODE_COMPACT);
            } else {
                return Html.fromHtml(text);
            }
        return new SpannedString("");
    }
}
