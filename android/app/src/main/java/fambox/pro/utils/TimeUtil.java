package fambox.pro.utils;

import android.content.Context;

import com.github.kevinsawicki.timeago.TimeAgo;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import fambox.pro.R;

public class TimeUtil {

    public static String dateDifference(Context context, String dateStr) {
        String dateString = dateStr != null ? dateStr : "1995-12-19T06:43:01.414Z";
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);
        df.setTimeZone(TimeZone.getTimeZone("UTC"));
        try {
            Date date = df.parse(dateString);
            TimeAgo time = new TimeAgo();
            time.setSuffixAgo(context.getResources().getString(R.string.time_ago));
            time.setDay(context.getResources().getString(R.string.day_ago));
            time.setDays(context.getResources().getString(R.string.days_ago));
            time.setHour(context.getResources().getString(R.string.hour_ago));
            time.setHours(context.getResources().getString(R.string.hours_ago));
            time.setMinute(context.getResources().getString(R.string.minute_ago));
            time.setMinutes(context.getResources().getString(R.string.minutes_ago));
            time.setMonth(context.getResources().getString(R.string.month_ago));
            time.setMonths(context.getResources().getString(R.string.months_ago));
            time.setSeconds(context.getResources().getString(R.string.seconds_ago));
            time.setSuffixFromNow(context.getResources().getString(R.string.suffix_from_now));
            time.setYear(context.getResources().getString(R.string.year_ago));
            time.setYears(context.getResources().getString(R.string.years_ago));
            if (date != null) {
                return time.timeAgo(date.getTime());
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return "no time";
    }

    public static String convertDate(String date) {
        SimpleDateFormat inputFormat = new SimpleDateFormat("dd/mm/yyyy", Locale.ENGLISH);
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd/mm/yyyy", Locale.ENGLISH);

        Date data;
        String outputFormatDate = null;

        try {
            data = inputFormat.parse(date);
            if (data != null) {
                outputFormatDate = outputFormat.format(data);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return outputFormatDate;
    }

    public static String getCurrentTime(String pattern) {
        // patterns
        // yyyy-MM-dd_HH:mm:ss
        // yyyy-MM-dd
        // HH:mm:ss
        SimpleDateFormat format = new SimpleDateFormat(pattern, Locale.ENGLISH);
        return format.format(Calendar.getInstance().getTime());
    }

    public static String getCurrentDate(String locale) {
        Date date = new Date();
        String strDateFormat = "dd MMMM, yyyy";
        DateFormat dateFormat = new SimpleDateFormat(strDateFormat, new Locale(locale));
        return dateFormat.format(date);
    }

    public static String convertTime(String locale, String time) {
        SimpleDateFormat inputFormat = new SimpleDateFormat("MM/dd/yyyy", new Locale(locale));
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd MMMM, yyyy", new Locale(locale));

        Date data;
        String outputFormatDate = null;

        try {
            data = inputFormat.parse(time);
            if (data != null) {
                outputFormatDate = outputFormat.format(data);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return outputFormatDate;
    }

    public static String convertSubmissionDate(String locale, String time) {
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", new Locale(locale));
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd MMMM, yyyy", new Locale(locale));

        Date data;
        String outputFormatDate = null;

        try {
            data = inputFormat.parse(time);
            if (data != null) {
                outputFormatDate = outputFormat.format(data);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return outputFormatDate;
    }

    public static String convertPrivatChatListDate(String locale, Date date) {
        SimpleDateFormat outputFormat = new SimpleDateFormat("MMM d, yyyy | HH:mm", new Locale(locale));
        outputFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        return outputFormat.format(date);
    }
}
