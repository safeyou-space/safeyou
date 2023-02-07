package fambox.pro.network;

import static fambox.pro.Constants.BASE_SOCKET_URL;
import static fambox.pro.Constants.BASE_SOCKET_URL_GEO;
import static fambox.pro.Constants.BASE_SOCKET_URL_IRQ;

import android.util.Log;

import java.net.URISyntaxException;
import java.util.Objects;

import javax.net.ssl.HostnameVerifier;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import okhttp3.OkHttpClient;

public class SocketHandler {
    private static final String TAG = SocketHandler.class.getName();
    private static SocketHandler instance;
    private static final String URI = BASE_SOCKET_URL;
    private static final String URI_GEO = BASE_SOCKET_URL_GEO;
    private static final String URI_IRQ = BASE_SOCKET_URL_IRQ;
    private static final int RECONNECTION_ATTEMPT = 10;
    private static final int RECONNECTION_DELAY = 1000;
    private Socket mSocket;

    public static SocketHandler getInstance(String accessToken, String countryCode) {
        if (instance == null) {
            instance = new SocketHandler(accessToken, countryCode);
        }
        return instance;
    }

    private SocketHandler(String accessToken, String countryCode) {
        IO.Options options = new IO.Options();

        HostnameVerifier myHostnameVerifier = (hostname, session) -> true;
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .hostnameVerifier(myHostnameVerifier)
                .build();

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
            if (Objects.equals(countryCode, "irq")) {
                mSocket = IO.socket(URI_IRQ, options);
            } else if (Objects.equals(countryCode, "geo")) {
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

    public void on(String event, Emitter.Listener fn) {
        if (mSocket != null) {
            mSocket.on(event, fn);
        }
    }
}
