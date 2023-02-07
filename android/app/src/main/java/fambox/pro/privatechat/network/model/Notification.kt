package fambox.pro.privatechat.network.model

data class Notification(
    val notify_id: Long,
    val notify_type: Int,
    val notify_read: Int,
    val notify_user_id: Long,
    val notify_title: String,
    val notify_body: ChatMessage,
    val notify_created_at: String,
) : BaseModel<Notification>()