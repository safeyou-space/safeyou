package fambox.pro.privatechat.network

interface NetworkCallback<T> {
    fun onSuccess(response: T)

    fun onError(error: Throwable)
}