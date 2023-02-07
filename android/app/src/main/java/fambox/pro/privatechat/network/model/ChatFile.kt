package fambox.pro.privatechat.network.model

import java.util.*

data class ChatFile(
    val file_id: String,
    val file_name: String,
    val file_mime_type: String,
    val file_path: String,
    val file_md5: String,
    val file_audio_duration: String?,
    val file_size: Long,
    val file_file_type: Int,
    val file_created_at: Date,
    val file_updated_at: Date,
)