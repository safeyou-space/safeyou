package fambox.pro.network;

import static fambox.pro.Constants.BASE_SOCKET_URL;
import static fambox.pro.Constants.BASE_SOCKET_URL_GEO;
import static fambox.pro.Constants.BASE_SOCKET_URL_IRQ;
import static fambox.pro.Constants.BASE_SOCKET_URL_ZWE;
import static fambox.pro.Constants.BASE_URL;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.jakewharton.retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import fambox.pro.Constants;
import fambox.pro.SafeYouApp;
import fambox.pro.view.LoginWithBackActivity;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ApiClient {
    private static final String AUTHORIZATION = "Authorization";
    private static final String ACCEPT = "Accept";
    private static final String CONTENT_TYPE = "Content-Type";
    private static final String TYPE = "application/json";
    private static final String TOKEN_TYPE = "Bearer %s";
    private static Retrofit retrofit = null;
    private static OpenInfoDialogListener mOpenInfoDialogListener;

    public static APIService getAdapter(Context context) {
        if (retrofit == null) {

            final OkHttpClient.Builder httpClient = getUnsafeOkHttpClient();

//             add logger interceptor for logging HEADERS and BODY.
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.HEADERS);
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            httpClient.addNetworkInterceptor(interceptor);

            httpClient.addInterceptor(chain -> {
                Request request = chain.request();
                Request.Builder builder = request.newBuilder();
                builder.header(AUTHORIZATION, String.format(TOKEN_TYPE,
                        ""));
                builder.header(ACCEPT, TYPE);
                builder.header("device_type", "android");
                builder.header(CONTENT_TYPE, TYPE);

                request = builder.build();
                okhttp3.Response response = chain.proceed(request);
                if (response.code() >= 400 && response.code() < 500) {
                    if (response.body() != null) {
                        if (mOpenInfoDialogListener != null) {
                            mOpenInfoDialogListener.openDialog(response.code(), parseErrors(response.body().string()));
                        }
                    }
                } else if (response.code() >= 500 && response.code() <= 599) {
                    if (response.body() != null) {
                        if (mOpenInfoDialogListener != null) {
                            mOpenInfoDialogListener.openDialog(response.code(), parseErrors(response.body().string()));
                        }
                    }
                }
                return response;
            });

            httpClient.authenticator((route, response) -> {
                String apiSuffix = "/login";
                if (response.request().url().encodedPath().contains(apiSuffix)) {
                    return null;
                }

                // retry the failed 401 request with new access token
                if (response.code() == 401) {
                    SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_PASSWORD);
                    SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_USER_PHONE);
                    SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
                    SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);

                    Intent intent = new Intent(context, LoginWithBackActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    context.startActivity(intent);
                }
                return null;
            });
            retrofit = new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .client(httpClient.build())
                    .build();
        }
        return retrofit.create(APIService.class);
    }

    // TODO: for test
    public static APIService getChatAdapter(Context context, String socketId, String countryCode) {
        final OkHttpClient.Builder httpClient = getUnsafeOkHttpClient();
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.HEADERS);
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        httpClient.addNetworkInterceptor(interceptor);

        httpClient.addInterceptor(chain -> {
            Request request = chain.request();
            Request.Builder builder = request.newBuilder();
            builder.header(ACCEPT, TYPE);
            builder.header("_", socketId);
            builder.header(CONTENT_TYPE, TYPE);
            request = builder.build();
            return chain.proceed(request);
        });

        String url = BASE_SOCKET_URL;
        switch (countryCode) {
            case "arm":
                url = BASE_SOCKET_URL;
                break;
            case "geo":
                url = BASE_SOCKET_URL_GEO;
                break;
            case "irq":
                url = BASE_SOCKET_URL_IRQ;
                break;
            case "zwe":
                url = BASE_SOCKET_URL_ZWE;
                break;
        }

        return new Retrofit.Builder()
                .baseUrl(url)
                .addConverterFactory(GsonConverterFactory.create())
                .client(httpClient.build())
                .build().create(APIService.class);
    }

    public static void setmOpenInfoDialogListener(OpenInfoDialogListener mOpenInfoDialogListener) {
        ApiClient.mOpenInfoDialogListener = mOpenInfoDialogListener;
    }

    public interface OpenInfoDialogListener {
        void openDialog(int errorCode, String text);
    }

    public static OkHttpClient.Builder getUnsafeOkHttpClient() {
        try {
            OkHttpClient.Builder builder = new OkHttpClient.Builder();
            builder.hostnameVerifier((hostname, session) -> true);

            return builder;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static String parseErrors(String body) {
        Map<String, JSONArray> errors = new HashMap<>();
        StringBuilder stringBuilder = new StringBuilder();

        try {
            JSONObject jsonObject = new JSONObject(body);
            Iterator<String> iterator = jsonObject.keys();
            while (iterator.hasNext()) {
                String key = iterator.next();
                if (jsonObject.get(key) instanceof String) {
                    stringBuilder.append(jsonObject.get(key)).append("\n");
                }
                if (jsonObject.get(key) instanceof JSONObject) {
                    JSONObject errorTypes = new JSONObject(jsonObject.get(key).toString());
                    Iterator<String> errorTypesIterator = errorTypes.keys();
                    while (errorTypesIterator.hasNext()) {
                        String keyErrors = errorTypesIterator.next();
                        if (errorTypes.get(keyErrors) instanceof JSONArray) {
                            errors.put(keyErrors, errorTypes.getJSONArray(keyErrors));
                        }
                    }
                }
            }

            if (!errors.isEmpty()) {
                for (Map.Entry<String, JSONArray> entry : errors.entrySet()) {
                    JSONArray value = entry.getValue();
                    for (int i = 0; i < value.length(); i++) {
                        stringBuilder.append(value.get(i)).append("\n");
                    }
                }
            }
        } catch (Exception e) {
            Log.i("Exception", "parseErrors: " + e.getMessage());
        }
        return stringBuilder.toString();
    }
}

