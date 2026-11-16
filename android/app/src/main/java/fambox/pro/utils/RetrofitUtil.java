package fambox.pro.utils;

import androidx.annotation.Nullable;

import org.json.JSONObject;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class RetrofitUtil {

    public static boolean isResponseSuccess(Response response, int code) {
        return response != null && response.isSuccessful() && response.code() == code && response.body() != null;
    }

    public static String getErrorMessage(@Nullable ResponseBody errorBody) {
        if (errorBody == null) {
            return "Error";
        } else {
            try {
                JSONObject jObjError = new JSONObject(errorBody.string());
                return jObjError.getString("message");
            } catch (Exception e) {
                return "Error";
            }
        }
    }

    public static String getCustomBody(Response<ResponseBody> response, String fieldName) {
        if (response != null) {
            try {
                JSONObject jObjError = null;
                if (response.body() != null) {
                    jObjError = new JSONObject(response.body().string());
                }
                if (jObjError != null) {
                    return jObjError.getString(fieldName);
                }
            } catch (Exception e) {
                return e.getMessage();
            }
        }
        return "Empty!";
    }
}
