package fambox.pro.privatechat.viewmodel

import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.fambox.chatkit.commons.models.IMentionClickListener
import com.fambox.chatkit.commons.models.ISpan
import com.fambox.chatkit.commons.models.IUser
import com.fambox.chatkit.commons.models.MessageContentType
import com.fambox.chatkit.messages.MessageHolders
import com.fambox.chatkit.messages.MessagesListAdapter
import com.google.gson.Gson
import fambox.pro.R
import fambox.pro.SafeYouApp
import fambox.pro.network.SocketHandlerPrivateChat
import fambox.pro.privatechat.audio.Player
import fambox.pro.privatechat.model.ChatModel
import fambox.pro.privatechat.network.NetworkCallback
import fambox.pro.privatechat.network.model.BaseModel
import fambox.pro.privatechat.network.model.ChatMessage
import fambox.pro.privatechat.network.model.Room
import fambox.pro.privatechat.network.model.User
import fambox.pro.privatechat.util.dateToStringFormat
import fambox.pro.privatechat.util.stringToDateFormat
import fambox.pro.privatechat.view.AbstractViewModel
import fambox.pro.privatechat.view.chatadapter.IncomingReplyMessageViewHolder
import fambox.pro.privatechat.view.chatadapter.IncomingVoiceMessageViewHolder
import fambox.pro.privatechat.view.chatadapter.OutgoingReplyMessageViewHolder
import fambox.pro.privatechat.view.chatadapter.OutgoingVoiceMessageViewHolder
import io.socket.emitter.Emitter
import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.json.JSONObject
import retrofit2.Response
import java.io.File
import java.net.HttpURLConnection
import java.net.URLConnection
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

class ChatViewModel : AbstractViewModel(), MessageHolders.ContentChecker<ChatViewModel.Message> {
    companion object {
        private var MESSAGE_TYPE_VOICE: Byte = 1
        private var MESSAGE_TYPE_REPLY_MESSAGE: Byte = 2
        private var LIMIT = 5
    }

    var mLongClickMessage: MutableLiveData<Message> = MutableLiveData()

    private var mSkip = 0
    private lateinit var mFamboxChatApplication: SafeYouApp
    private lateinit var mSocketHandler: SocketHandlerPrivateChat
    private lateinit var mChatModel: ChatModel
    private var mRoomKey: String = ""
    private lateinit var mMessagesAdapter: MessagesListAdapter<Message>
    private var mJoinRoom: MutableLiveData<Room>? = null
    private var mRoomMembers: MutableLiveData<List<User>>? = null
    private var mMessageList: MutableLiveData<MessagesListAdapter<Message>>? = null
    private var isRoomExist: Boolean = false
    private var disablePagination: Boolean = false
    private var userIdForCreateRoom: String = "0"
    private var roomId: String = "0"
    private var prepareSendFiles = mutableListOf<MultipartBody.Part>()
    private var prepareSendBody = HashMap<String, RequestBody>()
    private var mMentionClickListener: IMentionClickListener =
        IMentionClickListener { text, spanSpan, spanEnd ->
            Toast.makeText(
                mFamboxChatApplication,
                "text: $text  spanSpan: $spanSpan  spanEnd: $spanEnd",
                Toast.LENGTH_SHORT
            ).show()
        }
    private val mConnectError = Emitter.Listener { args: Array<Any>? ->
        Log.i("mConnectError", args.toString())
    }
    private val mConnectFailed = Emitter.Listener { args: Array<Any>? ->
        Log.i("mConnectFailed", args.toString())
    }
    private val mDisconnect = Emitter.Listener { args: Array<Any>? ->
        Log.i("mDisconnect", args.toString())
    }
    private val mSignal = Emitter.Listener { args: Array<Any>? ->
        try {
            if (args!!.size == 2) {
                val type = args[0]
                val arg = args[1]
                val mainJsonObject = JSONObject(arg.toString())
                if (!mainJsonObject.getBoolean("error")) {
                    val currentUser = mainJsonObject.getJSONObject("data")
                    if (type == 8) {
                        if (Objects.equals(roomId, currentUser.getString("message_room_id"))) {
                            val chatMessage =
                                Gson().fromJson(currentUser.toString(), ChatMessage::class.java)
                            Handler(Looper.getMainLooper()).post { addMessage(chatMessage) }
                        }
                    }
                    disablePagination = true
                }
            }
        } catch (ignore: Exception) {
            Log.i("mSignal", "ignore: $ignore")
        }
    }

    override fun attach(application: Application) {
        mFamboxChatApplication = application as SafeYouApp
        mChatModel = ChatModel()
    }

    override fun detach() {
        leaveRoom()
    }

    fun onStart() {
        initSocket()
    }

    fun onStop() {
        mSocketHandler.off("connect_error", mConnectError)
        mSocketHandler.off("connect_failed", mConnectFailed)
        mSocketHandler.off("disconnect", mDisconnect)
        mSocketHandler.off("signal", mSignal)
        Player.getInstance().clear()
    }

    fun getJoinRoom(roomKey: String, roomMember: String): LiveData<Room>? {
        if (mJoinRoom == null) {
            mJoinRoom = MutableLiveData()
            joinRoom(roomKey, roomMember)
        }
        return mJoinRoom
    }

    fun getRoomMembers(): LiveData<List<User>>? {
        if (mRoomMembers == null) {
            mRoomMembers = MutableLiveData()
            roomMembers()
        }
        return mRoomMembers
    }

    fun getMessageList(): LiveData<MessagesListAdapter<Message>>? {
        if (mMessageList == null) {
            mMessageList = MutableLiveData()
            getMessage()

            // init message adapter
            initMessageAdapter()
        }
        return mMessageList
    }


    fun getUserImage(context: Context, imageUrl: String): LiveData<Drawable> {
        val getImageDate: MutableLiveData<Drawable> = MutableLiveData()
        Glide.with(context)
            .asBitmap()
            .load(imageUrl)
            .placeholder(R.drawable.siruk)
            .circleCrop()
            .into(object : CustomTarget<Bitmap>() {
                override fun onResourceReady(
                    bitmap: Bitmap, transition: Transition<in Bitmap>?
                ) {
                    val drawable: Drawable = BitmapDrawable(
                        context.resources,
                        Bitmap.createScaledBitmap(
                            bitmap, context.resources.getDimensionPixelSize(R.dimen._32sdp),
                            context.resources.getDimensionPixelSize(R.dimen._32sdp), false
                        )
                    )
                    getImageDate.postValue(drawable)
                }

                override fun onLoadCleared(placeholder: Drawable?) {
                    getImageDate.postValue(placeholder)
                }
            })
        return getImageDate
    }

    private fun createRoom(roomName: String, roomType: Int, roomMember: String) {
        val createdRoomType = RequestBody.create("text/plain".toMediaTypeOrNull(), roomType.toString())
        val createdRoomImage = RequestBody.create(
            "text/plain".toMediaTypeOrNull(),
            fambox.pro.Constants.BASE_SOCKET_URL + "/static/admin.png"
        )
        val createdRoomName = RequestBody.create("text/plain".toMediaTypeOrNull(), roomName)
        val createdRoomMember = RequestBody.create("text/plain".toMediaTypeOrNull(), roomMember)

        val body = HashMap<String, RequestBody>()
        body["room_type"] = createdRoomType
        body["room_image"] = createdRoomImage
        body["room_name"] = createdRoomName
        body["room_member[0]"] = createdRoomMember
        if (SafeYouApp.getChatApiService() != null) {
            mChatModel.createRoom(SafeYouApp.getChatApiService(), body,
                object : NetworkCallback<Response<BaseModel<Room>?>> {
                    override fun onSuccess(response: Response<BaseModel<Room>?>) {
                        if (response.isSuccessful) {
                            if (!isRoomExist) {
                                val roomDate = response.body()!!.data
                                joinRoom(roomDate!!.room_key, roomMember)
                                disablePagination = true
                            }
                        } else {
                            if (response.body() == null) return
                        }
                    }

                    override fun onError(error: Throwable) {
                        Log.i("onError", "onSuccess: $error")
                    }
                })
        }
    }

    private fun joinRoom(roomKey: String, roomMember: String) {
        this.mRoomKey = roomKey
        if (SafeYouApp.getChatApiService() != null) {
            mChatModel.joinRoom(SafeYouApp.getChatApiService(), roomKey,
                object : NetworkCallback<Response<BaseModel<Room>?>> {
                    override fun onSuccess(response: Response<BaseModel<Room>?>) {
                        if (response.isSuccessful) {
                            mJoinRoom!!.postValue(response.body()!!.data)
                            if (prepareSendFiles.isNotEmpty() || prepareSendBody.isNotEmpty()) {
                                sendMessage(prepareSendFiles, prepareSendBody)
                            }
                            isRoomExist = true
                            roomId = response.body()!!.data!!.room_id
                        } else {
                            if (response.code() == HttpURLConnection.HTTP_NOT_FOUND) {
                                isRoomExist = false
                                userIdForCreateRoom = roomMember
                            }
                        }
                    }

                    override fun onError(error: Throwable) {
                        Log.i("onError", "onError: $error")
                    }
                })
        }
    }

    private fun roomMembers() {
        if (SafeYouApp.getChatApiService() != null) {
            mChatModel.getRoomMembers(SafeYouApp.getChatApiService(), mRoomKey,
                object : NetworkCallback<Response<BaseModel<List<User>?>?>> {
                    override fun onSuccess(response: Response<BaseModel<List<User>?>?>) {
                        if (response.isSuccessful) {
                            mRoomMembers!!.postValue(response.body()!!.data)
                        } else {
                            if (response.body() == null) return
                        }
                    }

                    override fun onError(error: Throwable) {
                        Log.i("onError", "onSuccess: $error")
                    }
                })
        }
    }

    private fun getMessage() {
        if (SafeYouApp.getChatApiService() != null) {
            mChatModel.getMessages(SafeYouApp.getChatApiService(), mRoomKey, LIMIT, mSkip,
                object : NetworkCallback<Response<BaseModel<List<ChatMessage>?>?>> {
                    override fun onSuccess(response: Response<BaseModel<List<ChatMessage>?>?>) {
                        if (response.isSuccessful) {
                            setMessagesToAdapter(response.body()!!.data!!)
                        } else {
                            if (response.body() == null) return
                        }
                    }

                    override fun onError(error: Throwable) {
                        Log.i("onError", "onSuccess: $error")
                    }
                })
        }
    }

    private fun initSocket() {
        mSocketHandler = mFamboxChatApplication.getChatSocket("")
        mSocketHandler.on("connect_error", mConnectError)
        mSocketHandler.on("connect_failed", mConnectFailed)
        mSocketHandler.on("disconnect", mDisconnect)
        mSocketHandler.on("signal", mSignal)
    }

    fun sendTextMessage(message: String, userMention: String, replyMessageId: String) {
        val messageType = RequestBody.create("text/plain".toMediaTypeOrNull(), "1")
        val messageContent = RequestBody.create("text/plain".toMediaTypeOrNull(), message)
        val userMentionBody = RequestBody.create("text/plain".toMediaTypeOrNull(), userMention)
        val files = mutableListOf<MultipartBody.Part>()

        val body = HashMap<String, RequestBody>()
        body["message_type"] = messageType
        body["message_content"] = messageContent
        body["message_mention_options"] = userMentionBody
        if (replyMessageId.isNotEmpty()) {
            val replyMessage = RequestBody.create("text/plain".toMediaTypeOrNull(), replyMessageId)
            body["message_replies[0]"] = replyMessage
        }

        if (!isRoomExist) {
            createRoom("roomname", 2, userIdForCreateRoom)
            prepareSendFiles = files
            prepareSendBody = body
            return
        } else {
            prepareSendFiles.clear()
            prepareSendBody.clear()
        }

        sendMessage(files, body)
    }

    fun sendFileMessage(selectedFiles: List<File>, fileType: Int) {
        val messageType = RequestBody.create("text/plain".toMediaTypeOrNull(), "$fileType")
        val files = mutableListOf<MultipartBody.Part>()

        for (file in selectedFiles) {
            val connection: URLConnection = file.toURL().openConnection()
            val mimeType: String = connection.contentType

            val propertyFile: RequestBody = RequestBody.create(
                mimeType.toMediaTypeOrNull(),
                file
            )

            val propertyFilePart = MultipartBody.Part.createFormData(
                "message_files[0]",
                file.name,
                propertyFile
            )
            files.add(propertyFilePart)
        }

        val body = HashMap<String, RequestBody>()
        body["message_type"] = messageType

        if (!isRoomExist) {
            createRoom("roomname", 2, userIdForCreateRoom)
            prepareSendFiles = files
            prepareSendBody = body
            return
        } else {
            prepareSendFiles.clear()
            prepareSendBody.clear()
        }


        sendMessage(files, body)
    }

    private fun sendMessage(
        files: MutableList<MultipartBody.Part>,
        body: HashMap<String, RequestBody>
    ) {
        mChatModel.sendMessage(SafeYouApp.getChatApiService(), mRoomKey, files, body,
            object : NetworkCallback<Response<BaseModel<ChatMessage>?>> {
                override fun onSuccess(response: Response<BaseModel<ChatMessage>?>) {

                }

                override fun onError(error: Throwable) {
                    Log.i("sendMessage", "onError: $error")
                }
            })
    }

    private fun leaveRoom() {
        if (SafeYouApp.getChatApiService() != null) {
            mChatModel.leaveRoom(SafeYouApp.getChatApiService(), mRoomKey,
                object : NetworkCallback<Response<BaseModel<Room>?>> {
                    override fun onSuccess(response: Response<BaseModel<Room>?>) {
                        if (!response.isSuccessful) {
                            if (response.body() == null) return
                        }
                    }

                    override fun onError(error: Throwable) {
                        Log.i("onError", "onError: $error")
                    }
                })
        }
    }

    private fun addMessage(chatMessage: ChatMessage) {
        val messageList: MutableList<Message> = ArrayList<Message>()
        setMessageToAdapter(chatMessage, messageList)
        if (messageList.size == 1)
            mMessagesAdapter.addToStart(messageList[0], true)
        for (user in chatMessage.message_receivers) {
            sendReceivedMessage(user.received_room_id, user.received_message_id)
        }
    }

    private fun setMessagesToAdapter(serverChatMessages: List<ChatMessage>) {
        val messageList: MutableList<Message> = ArrayList<Message>()
        for (message in serverChatMessages) {

            for (user in message.message_receivers) {
                sendReceivedMessage(
                    user.received_room_id,
                    user.received_message_id
                )
            }
            setMessageToAdapter(message, messageList)
        }

        mMessagesAdapter.addToEnd(messageList, true)
        mMessagesAdapter.setLoadMoreListener { _, _ ->
            mSkip += LIMIT
            getMessage()
            disablePagination = false
        }
    }

    private fun signal(signalData: JSONObject) {
        mSocketHandler.emit("signal", 12, signalData)
    }

    private fun sendReceivedMessage(room_id: Int, message_id: Int) {
        val signalData = JSONObject()
        signalData.put("received_room_id", room_id)
        signalData.put("received_message_id", message_id)
        signalData.put("received_type", 2)
        signal(signalData)
    }

    private fun setMessageToAdapter(
        chatMessage: ChatMessage,
        messageList: MutableList<Message>
    ) {
        val messageId: Long = chatMessage.message_id
        val messageContent: String = chatMessage.message_content
        val messageSendBy: User = chatMessage.message_send_by
        val messageCreatedAt = chatMessage.message_created_at
        val replyMessageList = chatMessage.message_replies
        val messageMentionOptions = chatMessage.message_mention_options
        val messageFiles = chatMessage.message_files
        val preferences = SafeYouApp.getPreference()
        val currentUserId = preferences.getLongValue(fambox.pro.Constants.Key.KEY_USER_ID, 0)

        val user = if (currentUserId == messageSendBy.user_id) {
            // current user
            Message.User(
                true,
                messageSendBy.user_id,
                messageSendBy.user_username,
                messageSendBy.user_image,
                messageSendBy.user_role_label!!
            )
        } else {
            // other user
            Message.User(
                false,
                messageSendBy.user_id,
                messageSendBy.user_username,
                messageSendBy.user_image,
                messageSendBy.user_role_label!!
            )
        }


        val spans = mutableListOf<ISpan>()
        if (messageMentionOptions != null) {
            for (messageMention in messageMentionOptions) {
                val spanStart = messageMention.user_mention_start
                val spanEnd = messageMention.user_mention_end
                val span = ISpan()
                span.spanStart = spanStart
                span.spanEnd = spanEnd
                spans.add(span)
            }
        }

        val messageToAttach = Message(
            messageId,
            messageContent,
            spans,
            0,
            dateToStringFormat(stringToDateFormat(messageCreatedAt))!!,
            user,
            mMentionClickListener
        )

        for (file in messageFiles) {
            if (file.file_mime_type.contains("image")) {
                messageToAttach.setImage((if (file.file_path.startsWith('/')) fambox.pro.Constants.BASE_SOCKET_URL else "") + file.file_path)
            } else if (file.file_mime_type.contains("audio")) {
                messageToAttach.setVoice(Message.Voice(file.file_path, file.file_audio_duration!!))
            }
        }

        if (replyMessageList.isNotEmpty()) {
            val messageReply = replyMessageList[0]
            var filename = ""
            if (messageReply.message_files != null && messageReply.message_files.isNotEmpty()) {
                val messageFile = messageReply.message_files[0]
                filename = messageFile.file_name
            }
            val replyMessage =
                messageReply.message_content

            messageToAttach.setReplyMessage(
                Message.ReplyMessage(
                    messageReply.message_send_by.user_username,
                    replyMessage,
                    messageContent,
                    messageReply.message_updated_at
                )
            )
        }

        messageList.add(messageToAttach)
    }

    private fun initMessageAdapter() {
        val holders = MessageHolders()
            .registerContentType(
                MESSAGE_TYPE_VOICE,
                IncomingVoiceMessageViewHolder::class.java,
                R.layout.incoming_voice_message_item,
                OutgoingVoiceMessageViewHolder::class.java,
                R.layout.outgoing_voice_message_item,
                this
            ).registerContentType(
                MESSAGE_TYPE_REPLY_MESSAGE,
                IncomingReplyMessageViewHolder::class.java,
                R.layout.incoming_reply_message_item,
                OutgoingReplyMessageViewHolder::class.java,
                R.layout.outgoing_reply_message_item,
                this
            )

        mMessagesAdapter = MessagesListAdapter<Message>(
            "1",
            holders
        ) { imageView, url, _ ->
            Glide.with(mFamboxChatApplication).load(url).into(imageView)
        }

        mMessagesAdapter.setOnMessageLongClickListener { message ->
            mLongClickMessage.postValue(
                message
            )
        }

        // post message adapter from recycler view
        mMessageList!!.postValue(mMessagesAdapter)
    }

    override fun hasContentFor(message: Message?, type: Byte): Boolean {
        if (type == MESSAGE_TYPE_VOICE) {
            return message!!.getVoice().url.isNotEmpty()
        } else if (type == MESSAGE_TYPE_REPLY_MESSAGE) {
            return message!!.getReplyMessage().replyMessage.isNotEmpty()
        }
        return false
    }

    class Message internal constructor(
        private val id: Long,
        text: String?,
        spans: List<ISpan>,
        messageState: Int,
        date: String,
        user: User,
        mentionClick: IMentionClickListener
    ) : MessageContentType.Image,
        MessageContentType {
        private val text: String?
        private var messageState: Int
        private var spans: List<ISpan>
        private val date: String
        private val user: User
        private var voice: Voice
        private var replyMessage: ReplyMessage
        private val mentionClick: IMentionClickListener
        private var image: String? = null
        private var isCallEvent = false
        fun setImage(image: String?) {
            this.image = image
        }

        fun setVoice(voice: Voice) {
            this.voice = voice
        }

        fun getVoice(): Voice {
            return voice
        }

        fun setReplyMessage(replyMessage: ReplyMessage) {
            this.replyMessage = replyMessage
        }

        fun getReplyMessage(): ReplyMessage {
            return replyMessage
        }

        fun getChatUser(): User {
            return user
        }

        override fun getId(): String {
            return id.toString()
        }

        override fun getText(): com.fambox.chatkit.commons.models.Message {
            val message = com.fambox.chatkit.commons.models.Message()
            message.text = text
            message.spans = spans
            return message
        }

        override fun getMessageState(): Int {
            return messageState
        }

        override fun getUser(): IUser {
            return user
        }

        override fun getCallEvent(): Int {
            return if (isCallEvent) 1 else 0
        }

        override fun getCreatedAt(): Date? {
            val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.getDefault())
            var convertDate: Date? = Date()
            dateFormat.timeZone = TimeZone.getTimeZone("UTC")
            try {
                convertDate = dateFormat.parse(date)
                convertDate?.time
            } catch (e: ParseException) {
                e.printStackTrace()
            }
            return convertDate
        }

        override fun getClick(): IMentionClickListener {
            return mentionClick
        }

        override fun getImageUrl(): String? {
            return image
        }

        class User(
            private val isSender: Boolean,
            private val userId: Long,
            private val userName: String,
            private val userImage: String,
            private val userProfession: String
        ) : IUser {
            override fun getId(): String {
                return if (isSender) SENDER else RECEIVER
            }

            override fun getName(): String {
                return userName
            }

            fun getUserId(): Long {
                return userId
            }

            fun getProfession(): String {
                return userProfession
            }

            fun getImage(): String {
                return userImage
            }

            override fun getAvatar(): String {
                return ""
            }

            companion object {
                private const val SENDER = "1"
                private const val RECEIVER = "0"
            }
        }


        init {
            this.text = text
            this.messageState = messageState
            this.date = date
            this.user = user
            this.voice = Voice("", "00:00")
            this.replyMessage = ReplyMessage("", "", "", "")
            this.mentionClick = mentionClick
            this.spans = spans
        }

        data class Voice(val url: String, val duration: String)

        class ReplyMessage(
            val userName: String,
            val replyMessage: String,
            val message: String,
            val time: String
        )
    }
}