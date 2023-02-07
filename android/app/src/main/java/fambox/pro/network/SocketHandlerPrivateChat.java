package fambox.pro.network;

import static fambox.pro.Constants.BASE_SOCKET_URL;
import static fambox.pro.Constants.BASE_SOCKET_URL_GEO;
import static fambox.pro.Constants.BASE_SOCKET_URL_IRQ;

import android.os.Handler;
import android.util.Log;

import java.net.URISyntaxException;
import java.util.Arrays;

import javax.net.ssl.HostnameVerifier;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import okhttp3.OkHttpClient;

public class SocketHandlerPrivateChat {
    private static final String TAG = SocketHandlerPrivateChat.class.getName();
    private static SocketHandlerPrivateChat instance;
    private static final Object monitor = new Object();
    private static final String URI = BASE_SOCKET_URL;
    private static final String URI_GEO = BASE_SOCKET_URL_GEO;
    private static final String URI_IRQ = BASE_SOCKET_URL_IRQ;
    private static final int RECONNECTION_ATTEMPT = 10;
    private static final int RECONNECTION_DELAY = 1000;
    private Socket mSocket;

    public static SocketHandlerPrivateChat getInstance(String accessToken, String countryCode) {
        synchronized (monitor) {
            if (instance == null) {
                instance = new SocketHandlerPrivateChat(accessToken, countryCode);
            }
            return instance;
        }
    }

    private SocketHandlerPrivateChat(String accessToken, String countryCode) {
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
        options.query = "_=".concat(accessToken);
        try {
            String url = URI;
            switch (countryCode) {
                case "arm":
                    url = URI;
                    break;
                case "geo":
                    url = URI_GEO;
                    break;
                case "irq":
                    url = URI_IRQ;
                    break;
            }
            Log.i(TAG, "SocketHandlerPrivateChat: " + url);
            Log.i(TAG, "SocketHandlerPrivateChat: " + options.query);
            mSocket = IO.socket(url, options);
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
}
