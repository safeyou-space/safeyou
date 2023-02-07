package fambox.pro.privatechat.view

import android.Manifest.permission.RECORD_AUDIO
import android.app.Activity
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.MenuItem
import android.widget.Toolbar
import androidx.appcompat.view.ActionMode
import androidx.core.view.isNotEmpty
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.fambox.chatkit.messages.MessageInput
import com.fambox.mention.suggestions.SuggestionsResult
import com.fambox.mention.suggestions.interfaces.Suggestible
import com.fambox.mention.suggestions.interfaces.SuggestionsResultListener
import com.fambox.mention.suggestions.interfaces.SuggestionsVisibilityManager
import com.fambox.mention.tokenization.QueryToken
import com.fambox.mention.tokenization.impl.WordTokenizer
import com.fambox.mention.tokenization.impl.WordTokenizerConfig
import com.fambox.mention.tokenization.interfaces.QueryTokenReceiver
import com.fxn.pix.Options
import com.fxn.pix.Pix
import com.google.gson.Gson
import com.nabinbhandari.android.permissions.PermissionHandler
import com.nabinbhandari.android.permissions.Permissions
import fambox.pro.Constants
import fambox.pro.R
import fambox.pro.SafeYouApp
import fambox.pro.databinding.ActivityChatBinding
import fambox.pro.network.model.chat.Comments
import fambox.pro.privatechat.audio.RecordAudio
import fambox.pro.privatechat.network.model.User
import fambox.pro.privatechat.view.adapter.AdapterMentionList
import fambox.pro.privatechat.viewmodel.ChatViewModel
import fambox.pro.view.ReportActivity
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.util.*


class ChatActivity : BaseVMActivity<ChatViewModel, ActivityChatBinding>(), QueryTokenReceiver,
    SuggestionsResultListener, SuggestionsVisibilityManager {

    private lateinit var adapter: AdapterMentionList
    private var mReplyMessageId: String? = ""
    private var mActionMode: ActionMode? = null
    private var returnValue = ArrayList<String>()
    private var mUsers = mutableListOf<User>()
    private var mMentionedUsers = mutableListOf<User>()
    private var recordAudio = RecordAudio()
    private var recordFile: File? = null
    private var isRecordStarted: Boolean = false
    private var roomKey: String = ""

    override fun getViewBinding(): ActivityChatBinding {
        return ActivityChatBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel.attach(application)
        getBundle(intent)

        binding.iconBack.setOnClickListener { onBackPressed() }
        binding.chatKitInput.setInputListener { input ->
            if (isRecordStarted) {
                stopRecording(false)
                viewModel.sendFileMessage(mutableListOf(recordFile!!), 3)
                isRecordStarted = false
            } else {
                val message = input.trim()
                if (message.isNotEmpty()) {
                    viewModel.sendTextMessage(
                        input.toString().trim(),
                        Gson().toJson(mMentionedUsers),
                        mReplyMessageId!!
                    )
                    mMentionedUsers.clear()
                    if (mActionMode != null) {
                        mActionMode!!.finish()
                    }
                }
            }
            true
        }
        binding.chatToolBar.setNavigationContentDescription(R.string.back_icon_description)

        binding.chatKitInput.setAttachmentsListener(object : MessageInput.AttachmentsListener {
            override fun onAddAttachments() {
                val intent = Intent()
                intent.type = "image/*"
                intent.action = Intent.ACTION_GET_CONTENT
                startActivityForResult(Intent.createChooser(intent, "Select Picture"), 151)
            }

            override fun onAddRecordAudio() {
                Permissions.check(this@ChatActivity, arrayOf(
                    RECORD_AUDIO
                ), null, null, object : PermissionHandler() {
                    override fun onGranted() {
                        recordFile = File(externalCacheDir, UUID.randomUUID().toString() + ".mp3")
                        try {
                            if (!isRecordStarted) {
                                recordAudio.start(recordFile!!.path)
                                isRecordStarted = true
                            }
                        } catch (e: IOException) {
                            e.printStackTrace()
                        }
                    }

                    override fun onDenied(
                        context: Context,
                        deniedPermissions: ArrayList<String>
                    ) {

                    }
                })
            }

            override fun onCancelRecordAudio() {
                stopRecording(true)
                isRecordStarted = false
            }

            override fun onAddTakePhoto() {
                val options: Options = Options.init()
                    .setRequestCode(100) //Request code for activity results
                    .setCount(1) //Number of images to restrict selection count
                    .setFrontfacing(false) //Front Facing camera on start
                    .setPreSelectedUrls(returnValue) //Pre selected Image Urls
                    .setSpanCount(4) //Span count for gallery min 1 & max 5
                    .setMode(Options.Mode.Picture) //Option to select only pictures or videos or both
                    .setVideoDurationLimitinSeconds(0) //Duration for video recording
                    .setScreenOrientation(Options.SCREEN_ORIENTATION_PORTRAIT) // Orientation
                    .setPath("/FamboxChat/images") //Custom Path For media Storage

                Pix.start(this@ChatActivity, options)
            }

            override fun onClickClose() {
                mReplyMessageId = ""
            }

            override fun onRemoveImage() {

            }
        })

        binding.chatKitInput.setTypingListener(object : MessageInput.TypingListener {
            override fun onStartTyping() {
            }

            override fun onStopTyping() {
            }

            override fun onInputEmpty() {
            }

            override fun onInputFull() {
            }
        })

        // mention config
        configMention()
    }

    override fun onBackPressed() {
        if (binding.chatToolBar.menu.isNotEmpty()) {
            binding.chatToolBar.menu.clear()
        } else {
            super.onBackPressed()
        }
    }

    private fun stopRecording(deleteFile: Boolean) {
        recordAudio.stop()
        if (deleteFile) {
            recordFile!!.delete()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == 151 && resultCode == RESULT_OK && data != null) {
            val files = mutableListOf<File>()
            val inputStream: InputStream? = contentResolver.openInputStream(data.data!!)
            val file = File(cacheDir, "image_to_upload.jpg")
            copyInputStreamToFile(inputStream!!, file)
            files.add(file)
            viewModel.sendFileMessage(files, 2)
        }

        if (resultCode == Activity.RESULT_OK && requestCode == 100) {
            returnValue = data!!.getStringArrayListExtra(Pix.IMAGE_RESULTS)!!
            val files = mutableListOf<File>()
            for (path in returnValue) {
                files.add(File(path))
            }
            viewModel.sendFileMessage(files, 2)
        }
    }

    override fun onStart() {
        super.onStart()
        viewModel.onStart()
    }

    override fun onStop() {
        super.onStop()
        viewModel.onStop()
    }

    override fun onDestroy() {
        super.onDestroy()
        viewModel.detach()
    }

    override fun onQueryReceived(queryToken: QueryToken): MutableList<String> {
        val buckets = mutableListOf("bucket")
        val result = SuggestionsResult(queryToken, mUsers)
        onReceiveSuggestionsResult(result, "bucket")
        return buckets
    }

    override fun onReceiveSuggestionsResult(result: SuggestionsResult, bucket: String) {
        val suggestions: List<Suggestible?> = result.suggestions
        adapter.setMention(result.suggestions)
        val display = suggestions.isNotEmpty()
        displaySuggestions(display)
    }

    override fun displaySuggestions(display: Boolean) {
        if (display) {
            binding.mentionList.visibility = RecyclerView.VISIBLE
        } else {
            binding.mentionList.visibility = RecyclerView.GONE
        }
    }

    override fun isDisplayingSuggestions(): Boolean {
        return binding.mentionList.visibility == RecyclerView.VISIBLE
    }

    private fun getBundle(intent: Intent) {
        val bundle = intent.extras
        if (bundle != null) {
            val isOpenedFromNetwork = bundle.getBoolean("opened_from_network", false)
            val userId = bundle.getString("user_id", "0")

            if (isOpenedFromNetwork) {
                val currentUserId =
                    SafeYouApp.getPreference().getLongValue(Constants.Key.KEY_USER_ID, 0)
                val imageUrl = bundle.getString("user_image", "0")
                val userName = bundle.getString("user_name", "no name")
                val userProfession = bundle.getString("user_profession")

                roomKey = "PRIVATE_CHAT_${currentUserId}_$userId"
                binding.userName.text = userName
                binding.userProfession.text = userProfession
                viewModel.getUserImage(this, Constants.BASE_URL + imageUrl)
                    .observe(this) { imageDrawable ->
                        binding.userProfileImage.setImageDrawable(imageDrawable)
                    }
            } else {
                roomKey = bundle.getString("room_key", "0")
            }

            viewModel.getJoinRoom(roomKey, userId)!!.observe(this) { joinRoom ->
                binding.userName.text = joinRoom.room_name
                if (joinRoom.room_members != null) {
                    for (roomMember: User in joinRoom.room_members) {
                        if (roomMember.user_id != SafeYouApp.getPreference()
                                .getLongValue(Constants.Key.KEY_USER_ID, 0)
                        ) {
                            if (roomMember.user_profession != null) {
                                binding.userProfession.text =
                                    roomMember.user_profession[SafeYouApp.getLocale()]
                            }
                        }
                    }
                }
                viewModel.getUserImage(this, joinRoom.room_image).observe(this) { imageDrawable ->
                    binding.userProfileImage.setImageDrawable(imageDrawable)
                }

                viewModel.getMessageList()!!.observe(this) { adapter ->
                    binding.chatKitList.setAdapter(adapter)
                }

                viewModel.getRoomMembers()!!.observe(this) { usersList ->
                    mUsers.addAll(usersList)
                }
            }
        }
    }

    private fun configMention() {
        binding.mentionList.layoutManager = LinearLayoutManager(this)
        adapter = AdapterMentionList()
        adapter.mMentionClickListener = object : AdapterMentionList.MentionClickListener {
            override fun onClickMention(user: User) {
                binding.chatKitInput.inputEditText.insertMention(user)
                binding.mentionList.swapAdapter(adapter, true)
                displaySuggestions(false)
                binding.chatKitInput.inputEditText.requestFocus()
            }
        }
        binding.mentionList.adapter = adapter
        binding.chatKitInput.inputEditText.tokenizer = WordTokenizer(
            WordTokenizerConfig.Builder().build()
        )

        viewModel.mLongClickMessage.observe(this) { message ->
            if (binding.chatToolBar.menu.isNotEmpty()) {
                binding.chatToolBar.menu.clear()
            }
            binding.chatToolBar.inflateMenu(R.menu.menu_action_mode)
            if (message.user.id == "1") {
                binding.chatToolBar.menu.getItem(2).isVisible = false
            }
            binding.chatToolBar.setOnMenuItemClickListener(object :
                Toolbar.OnMenuItemClickListener,
                androidx.appcompat.widget.Toolbar.OnMenuItemClickListener {
                override fun onMenuItemClick(item: MenuItem?): Boolean {
                    return when (item!!.itemId) {
                        R.id.action_reply -> {
                            mReplyMessageId = message.id
                            binding.chatKitInput.setReplyMessage(
                                MessageInput.ReplyContent(
                                    message.user.name,
                                    message.text.text
                                )
                            )
                            binding.chatToolBar.menu.clear()
                            true
                        }
                        R.id.action_copy -> {
                            binding.chatToolBar.menu.clear()
                            val clipboard: ClipboardManager =
                                getSystemService(CLIPBOARD_SERVICE) as ClipboardManager
                            val clip: ClipData =
                                ClipData.newPlainText(message.user.name, message.text.text)
                            clipboard.setPrimaryClip(clip)
                            true
                        }
                        R.id.action_info -> {
                            binding.chatToolBar.menu.clear()
                            val bundle = Bundle()
                            val comment = Comments()
                            comment.id = message.id.toLong()
                            comment.message = message.text.text
                            comment.user_id = message.getChatUser().getUserId()
                            comment.name = message.getChatUser().name
                            comment.roomKey = roomKey
                            comment.image_path = message.getChatUser().getImage()
                            comment.user_type = message.getChatUser().getProfession()
                            bundle.putParcelable("comment", comment)
                            val intent = Intent(
                                this@ChatActivity, ReportActivity::class.java
                            )
                            intent.putExtras(bundle)
                            startActivity(intent)
                            true
                        }
                        else -> false
                    }
                }
            })
        }

    }

    companion object {
        @Throws(IOException::class)
        fun copyInputStreamToFile(inputStream: InputStream, file: File) {
            FileOutputStream(file, false).use { outputStream ->
                var read: Int
                val bytes = ByteArray(DEFAULT_BUFFER_SIZE)
                while (inputStream.read(bytes).also { read = it } != -1) {
                    outputStream.write(bytes, 0, read)
                }
            }
        }
    }
}