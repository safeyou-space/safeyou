package fambox.pro.network;

public interface NetworkCallback<T> {
    void onSuccess(T response);

    void onError(Throwable error);
}