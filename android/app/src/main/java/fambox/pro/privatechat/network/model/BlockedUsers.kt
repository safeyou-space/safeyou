package fambox.pro.privatechat.network.model

data class BlockedUsers(
    val user: User

) : BaseModel<List<BlockedUsers>>()