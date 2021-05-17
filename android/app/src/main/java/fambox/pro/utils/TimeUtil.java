package fambox.pro.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class TimeUtil {

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
}
