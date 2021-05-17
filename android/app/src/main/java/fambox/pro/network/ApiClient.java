package fambox.pro.network;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.jakewharton.retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Objects;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.view.LoginWithBackActivity;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import static fambox.pro.Constants.BASE_URL;
import static fambox.pro.Constants.Key.KEY_ACCESS_TOKEN;

public class ApiClient {
    private static final String AUTHORIZATION = "Authorization";
    private static final String ACCEPT = "Accept";
    private static final String CONTENT_TYPE = "Content-Type";
    private static final String TYPE = "application/json";
    private static final String TOKEN_TYPE = "Bearer %s";
    private static Retrofit retrofit = null;
    private static OpenInfoDialogListener mOpenInfoDialogListener;

    public static APIService getAdapter(Context context, String countryCode, String locale) {
        if (retrofit == null) {

//            final OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
            final OkHttpClient.Builder httpClient = getUnsafeOkHttpClient(context);

//            httpClient.connectTimeout(5, TimeUnit.MINUTES);
//            httpClient.readTimeout(15, TimeUnit.MINUTES);
//            httpClient.writeTimeout(15, TimeUnit.MINUTES);

//             add logger interceptor for logging HEADERS and BODY.
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.HEADERS);
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            httpClient.addNetworkInterceptor(interceptor);

            httpClient.addInterceptor(chain -> {
                Request request = chain.request();
                Request.Builder builder = request.newBuilder();
                builder.header(AUTHORIZATION, String.format(TOKEN_TYPE,
                        SafeYouApp.getPreference(context)
                                .getStringValue(KEY_ACCESS_TOKEN, "")));
                builder.header(ACCEPT, TYPE);
                builder.header(CONTENT_TYPE, TYPE);

                request = builder.build();
                okhttp3.Response response = chain.proceed(request);
                if (response.code() >= 400 && response.code() <= 499) {
                    if (response.body() != null) {
                        if (mOpenInfoDialogListener != null) {
                            mOpenInfoDialogListener.openDialog(response.code() + "\n"
                                    + response.message(), parseErrors(response.body().string()));
                        }
                    }
                } else if (response.code() >= 500 && response.code() <= 599) {
                    if (response.body() != null) {
                        if (mOpenInfoDialogListener != null) {
                            mOpenInfoDialogListener.openDialog(response.code() + "\n"
                                    + response.message(), parseErrors(response.body().string()));
                        }
                    }
                }
                return response;
            });

            httpClient.authenticator((route, response) -> {
                String apiSuffix = "/api/" + countryCode + "/" + locale + "/login";
                if (Objects.equals(response.request().url().encodedPath(), apiSuffix)) {
                    return null;
                }

                // retry the failed 401 request with new access token
                SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_ACCESS_TOKEN);
                SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_REFRESH_TOKEN);
                SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_PASSWORD);
                SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_USER_PHONE);
                SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_SHARED_REAL_PIN);
                SafeYouApp.getPreference(context).removeKey(Constants.Key.KEY_SHARED_FAKE_PIN);

                Intent intent = new Intent(context, LoginWithBackActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                context.startActivity(intent);
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

    public static void setmOpenInfoDialogListener(OpenInfoDialogListener mOpenInfoDialogListener) {
        ApiClient.mOpenInfoDialogListener = mOpenInfoDialogListener;
    }

    public interface OpenInfoDialogListener {
        void openDialog(String title, String text);
    }

    public static OkHttpClient.Builder getUnsafeOkHttpClient(Context context) {
        try {
            // Create a trust manager that does not validate certificate chains
            final TrustManager[] trustAllCerts = new TrustManager[]{
                    new X509TrustManager() {
                        @SuppressLint("TrustAllX509TrustManager")
                        @Override
                        public void checkClientTrusted(java.security.cert.X509Certificate[] chain, String authType) {
                            Log.d("tagikkk", "checkClientTrusted() called with: chain = [" + Arrays.toString(chain) + "], authType = [" + authType + "]");
                        }

                        @SuppressLint("TrustAllX509TrustManager")
                        @Override
                        public void checkServerTrusted(java.security.cert.X509Certificate[] chain, String authType) {
                            Log.d("tagikkk", "checkServerTrusted() called with: chain = [" + Arrays.toString(chain) + "], authType = [" + authType + "]");
                        }

                        @Override
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                            Log.d("tagikkk", "getAcceptedIssuers() returned: ");
                            return new java.security.cert.X509Certificate[]{};
                        }
                    }
            };

            SSLContext sslContext = null;
            try {
                sslContext = createCertificate(context.getResources().openRawResource(R.raw.cerc));
            } catch (CertificateException | IOException | KeyStoreException | KeyManagementException | NoSuchAlgorithmException e) {
                Log.i("tagikkk", "getUnsafeOkHttpClient: " + e.getMessage());
            }

            OkHttpClient.Builder builder = new OkHttpClient.Builder();
            builder.sslSocketFactory(sslContext.getSocketFactory(), (X509TrustManager) trustAllCerts[0]);
            builder.hostnameVerifier((hostname, session) -> {
                HostnameVerifier hv =
                        HttpsURLConnection.getDefaultHostnameVerifier();
                return hv.verify("safeyou.space", session);
            });
            return builder;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static SSLContext createCertificate(InputStream trustedCertificateIS)
            throws IOException, KeyStoreException, NoSuchAlgorithmException, KeyManagementException, CertificateException {
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        Certificate ca;
        try {
            ca = cf.generateCertificate(trustedCertificateIS);
        } finally {
            trustedCertificateIS.close();
        }

        // creating a KeyStore containing our trusted CAs
        String keyStoreType = KeyStore.getDefaultType();
        KeyStore keyStore = KeyStore.getInstance(keyStoreType);
        keyStore.load(null, null);
        keyStore.setCertificateEntry("ca", ca);

        // creating a TrustManager that trusts the CAs in our KeyStore
        String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
        TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
        tmf.init(keyStore);

        // creating an SSLSocketFactory that uses our TrustManager
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, tmf.getTrustManagers(), null);
        return sslContext;
    }

    private static String parseErrors(String body) {
        Map<String, JSONArray> errors = new HashMap<>();
        StringBuilder stringBuilder = new StringBuilder();

        if (!errors.isEmpty()) {
            errors.clear();
        }
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
            Log.i("tagik", "parseErrors: " + e.getMessage());
        }
        return stringBuilder.toString();
    }
}

