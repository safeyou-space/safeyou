package fambox.pro.privatechat.model

import fambox.pro.network.APIService
import fambox.pro.privatechat.network.NetworkCallback
import fambox.pro.privatechat.network.model.BaseModel
import fambox.pro.privatechat.network.model.ChatMessage
import fambox.pro.privatechat.network.model.Room
import fambox.pro.privatechat.network.model.User
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ChatModel {

    fun createRoom(
        apiAdapter: APIService,
        body: HashMap<String, RequestBody>,
        networkCallback: NetworkCallback<Response<BaseModel<Room>?>>
    ) {
        apiAdapter.createRoom(body)!!
            .enqueue(object : Callback<BaseModel<Room>?> {
                override fun onResponse(
                    call: Call<BaseModel<Room>?>,
                    response: Response<BaseModel<Room>?>
                ) {
                    networkCallback.onSuccess(response)
                }

                override fun onFailure(call: Call<BaseModel<Room>?>, t: Throwable) {
                    networkCallback.onError(t)
                }
            })
    }

    fun joinRoom(
        apiAdapter: APIService, roomKey: String,
        networkCallback: NetworkCallback<Response<BaseModel<Room>?>>
    ) {
        apiAdapter.joinRoom(roomKey)!!.enqueue(object : Callback<BaseModel<Room>?> {
            override fun onResponse(
                call: Call<BaseModel<Room>?>,
                response: Response<BaseModel<Room>?>
            ) {
                networkCallback.onSuccess(response)
            }

            override fun onFailure(call: Call<BaseModel<Room>?>, t: Throwable) {
                networkCallback.onError(t)
            }
        })
    }

    fun getRoomMembers(
        apiAdapter: APIService,
        roomKey: String,
        networkCallback: NetworkCallback<Response<BaseModel<List<User>?>?>>
    ) {
        apiAdapter.getRoomMembers(roomKey)!!.enqueue(object : Callback<BaseModel<List<User>?>?> {
            override fun onResponse(
                call: Call<BaseModel<List<User>?>?>,
                response: Response<BaseModel<List<User>?>?>
            ) {
                networkCallback.onSuccess(response)
            }

            override fun onFailure(call: Call<BaseModel<List<User>?>?>, t: Throwable) {
                networkCallback.onError(t)
            }
        })
    }

    fun getMessages(
        apiAdapter: APIService, roomKey: String,
        limit: Int,
        skip: Int,
        networkCallback: NetworkCallback<Response<BaseModel<List<ChatMessage>?>?>>
    ) {
        apiAdapter.getMessages(roomKey, limit, skip)!!
            .enqueue(object : Callback<BaseModel<List<ChatMessage>?>?> {
                override fun onResponse(
                    call: Call<BaseModel<List<ChatMessage>?>?>,
                    response: Response<BaseModel<List<ChatMessage>?>?>
                ) {
                    networkCallback.onSuccess(response)
                }

                override fun onFailure(call: Call<BaseModel<List<ChatMessage>?>?>, t: Throwable) {
                    networkCallback.onError(t)
                }
            })
    }

    fun sendMessage(
        apiAdapter: APIService, roomKey: String,
        files: MutableList<MultipartBody.Part>,
        body: HashMap<String, RequestBody>,
        networkCallback: NetworkCallback<Response<BaseModel<ChatMessage>?>>
    ) {
        apiAdapter.sendMessage(roomKey, files, body)!!
            .enqueue(object : Callback<BaseModel<ChatMessage>?> {
                override fun onResponse(
                    call: Call<BaseModel<ChatMessage>?>,
                    response: Response<BaseModel<ChatMessage>?>
                ) {
                    networkCallback.onSuccess(response)
                }

                override fun onFailure(call: Call<BaseModel<ChatMessage>?>, t: Throwable) {
                    networkCallback.onError(t)
                }
            })
    }

    fun leaveRoom(
        apiAdapter: APIService, roomKey: String,
        networkCallback: NetworkCallback<Response<BaseModel<Room>?>>
    ) {
        apiAdapter.leaveRoom(roomKey)!!.enqueue(object : Callback<BaseModel<Room>?> {
            override fun onResponse(
                call: Call<BaseModel<Room>?>,
                response: Response<BaseModel<Room>?>
            ) {
                networkCallback.onSuccess(response)
            }

            override fun onFailure(call: Call<BaseModel<Room>?>, t: Throwable) {
                networkCallback.onError(t)
            }
        })
    }
}
