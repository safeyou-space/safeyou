package fambox.pro.privatechat.network.model

import java.util.*

data class Room(
    val room_id: String,
    val room_key: String,
    val room_image: String,
    val room_name: String,
    val room_members: List<User>?,
    val room_your_role: String,
    val room_updated_at: Date,
    val room_created_at: Date,
) : BaseModel<Room>()