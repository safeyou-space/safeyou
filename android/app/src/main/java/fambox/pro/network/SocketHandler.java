package fambox.pro.network;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.util.Log;

import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.Objects;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import io.socket.client.Ack;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import okhttp3.OkHttpClient;

import static fambox.pro.Constants.BASE_SOCKET_URL;
import static fambox.pro.Constants.BASE_SOCKET_URL_GEO;

public class SocketHandler {
    private static final String TAG = SocketHandler.class.getName();
    private static SocketHandler instance;
    private static final String URI = BASE_SOCKET_URL;
    private static final String URI_GEO = BASE_SOCKET_URL_GEO;
    private static final int RECONNECTION_ATTEMPT = 10;
    private static final int RECONNECTION_DELAY = 1000;
    private Socket mSocket;

    public static SocketHandler getInstance(String accessToken, String countryCode) {
        if (instance == null) {
            Log.i(TAG, "accessToken: " + accessToken);
            Log.i(TAG, "countryCode: " + countryCode);
            instance = new SocketHandler(accessToken, countryCode);
        }
        return instance;
    }

    private SocketHandler(String accessToken, String countryCode) {
        IO.Options options = new IO.Options();
        SSLContext mySSLContext = null;
        try {
            mySSLContext = SSLContext.getInstance("SSL");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        X509TrustManager trustManager = new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return new java.security.cert.X509Certificate[]{};
            }

            @SuppressLint("TrustAllX509TrustManager")
            public void checkClientTrusted(X509Certificate[] chain,
                                           String authType) throws CertificateException {
            }

            @SuppressLint("TrustAllX509TrustManager")
            public void checkServerTrusted(X509Certificate[] chain,
                                           String authType) throws CertificateException {
            }
        };

        try {
            if (mySSLContext != null) {
                mySSLContext.init(null, new TrustManager[]{trustManager}, null);
            }
        } catch (KeyManagementException e) {
            e.printStackTrace();
        }

        HostnameVerifier myHostnameVerifier = new HostnameVerifier() {
            @SuppressLint("BadHostnameVerifier")
            @Override
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        };
        OkHttpClient okHttpClient = null;
        if (mySSLContext != null) {
            okHttpClient = new OkHttpClient.Builder()
                    .hostnameVerifier(myHostnameVerifier)
                    .sslSocketFactory(mySSLContext.getSocketFactory(), trustManager)
                    .build();
        }

        // default settings for all sockets
        IO.setDefaultOkHttpWebSocketFactory(okHttpClient);
        IO.setDefaultOkHttpCallFactory(okHttpClient);
        // set as an option
        options.callFactory = okHttpClient;
        options.webSocketFactory = okHttpClient;
        options.secure = true;
        options.forceNew = true;
        options.reconnection = true;
        options.reconnectionAttempts = RECONNECTION_ATTEMPT;
        options.reconnectionDelay = RECONNECTION_DELAY;
        options.query = "key=".concat(accessToken);
        try {
            if (Objects.equals(countryCode, "geo")) {
                mSocket = IO.socket(URI_GEO, options);
            } else {
                mSocket = IO.socket(URI, options);
            }
            mSocket.connect();
        } catch (URISyntaxException e) {
            e.getStackTrace();
            Log.i(TAG, "SocketHandler: " + e.getMessage());
        }
    }

    public void disconnect() {
        if (mSocket != null) {
            mSocket.disconnect();
            mSocket.close();
            mSocket = null;
            instance = null;
        }
    }

    public boolean isConnected() {
        return mSocket != null && mSocket.connected();
    }

    public void emit(String event, Object... args) {
        Log.i(TAG, "emit: " + " event >> " + event + " value >> " + Arrays.toString(args));
        if (mSocket != null && isConnected()) {
            mSocket.emit(event, args);
        } else {
            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (mSocket != null && isConnected()) {
                        mSocket.emit(event, args);
                        Log.i(TAG, "emit: true");
                    } else {
                        Log.i(TAG, "emit: false");
                        if (mSocket != null) {
                            mSocket.connect();
                            handler.postDelayed(this, 100);
                        }
                    }
                }
            }, 100);
        }
    }

    public void emit(String event, Object[] args, Ack ack) {
        if (mSocket != null) {
            mSocket.emit(event, args, ack);
        }
    }

    public void once(String event, Emitter.Listener fn) {
        if (mSocket != null) {
            mSocket.once(event, fn);
        }
    }

    public void on(String event, Emitter.Listener fn) {
        if (mSocket != null) {
            mSocket.on(event, fn);
        }
    }

    public void off(String event, Emitter.Listener fn) {
        if (mSocket != null) {
            mSocket.off(event, fn);
        }
    }

    public Socket getSocket() {
        return mSocket;
    }

    public interface ConnectionListener {
        void onConnect(boolean isConnected);
    }
}
