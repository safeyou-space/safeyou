package fambox.pro.privatechat.util

import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

fun dateToStringFormat(date: Date?): String? {
    val inputFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH)
    var outputFormatDate: String? = ""
    if (date != null) {
        outputFormatDate = inputFormat.format(date)
    }
    return outputFormatDate
}

fun stringToDateFormat(date: String?): Date? {
    val outputFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH)
    var outputFormatDate: Date? = Date()
    if (date != null) {
        try {
            outputFormatDate = outputFormat.parse(date)
        } catch (e: ParseException) {
            e.printStackTrace()
        }
    }
    return outputFormatDate
}