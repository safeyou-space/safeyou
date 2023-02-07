package fambox.pro.privatechat.network.model

import fambox.pro.network.model.forum.ForumImageResponseBody

data class ChatMessage(
    val message_id: Long,
    val message_content: String,
    val message_send_by: User,
    val message_edit_by: User,
    val message_receivers: List<User>,
    val message_files: List<ChatFile>,
    val message_replies: List<ChatMessage>,
    val message_likes: List<Like>,
    val message_mention_options: List<User>,
    val message_type: Int,
    val message_parent_id: Long,
    val message_forum_id: Long,
    val message_room_key: String,
    val message_created_at: String,
    val message_updated_at: String,
    val message_hidden: Boolean,

    val id: Int,
    val title: String,
    val image: ForumImageResponseBody,
) : BaseModel<ChatMessage>()