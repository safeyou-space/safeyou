package fambox.pro.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Build;
import android.text.Editable;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;

import com.amulyakhare.textdrawable.TextDrawable;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

import fambox.pro.R;
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

    public static byte[] convertStreamToByteArray(InputStream is) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buff = new byte[10240];
        int i = Integer.MAX_VALUE;
        while (true) {
            try {
                if (!((i = is.read(buff, 0, buff.length)) > 0)) break;
            } catch (IOException e) {
                e.printStackTrace();
            }
            baos.write(buff, 0, i);
        }

        return baos.toByteArray(); // be sure to close InputStream in calling function
    }

    public static float percentageCalculator(int x, int y, PercentageType percentageType) {
        switch (percentageType) {
            case NUMBER_TO_PERCENTAGE:
                return (x * 100f) / y;
            case PERCENTAGE_TO_NUMBER:
                return (x / 100f) * y;
            default:
                return (x * 100f) / y;
        }
    }

    public static String millisecondsToMinute(int millis) {
        return String.format(Locale.ENGLISH, "%02d:%02d",
                TimeUnit.MILLISECONDS.toMinutes(millis),
                TimeUnit.MILLISECONDS.toSeconds(millis) -
                        TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millis)));
    }

    public static TextDrawable textToDrawable(Context context, String string) {
        int size = (int) context.getResources().getDimension(R.dimen._15sdp);
//        Typeface face = ResourcesCompat.getFont(context, R.font.hay_roboto_bold_italic);
        return TextDrawable.builder()
                .beginConfig()
                .textColor(Color.WHITE)
//                .useFont(face)
                .fontSize(size) /* size in px */
                .bold()
                .endConfig()
                .buildRect(string, Color.TRANSPARENT);
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
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", new Locale(locale));
        SimpleDateFormat outputFormat = new SimpleDateFormat("MMM d, HH:mm", new Locale(locale));

        Date date;
        String outputFormatDate = null;

//        inputFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

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
}
