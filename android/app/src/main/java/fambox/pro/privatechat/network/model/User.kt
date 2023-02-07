package fambox.pro.privatechat.network.model

import android.os.Parcel
import android.os.Parcelable
import com.fambox.mention.mentions.Mentionable
import com.fambox.mention.mentions.Mentionable.MentionDeleteStyle
import com.fambox.mention.mentions.Mentionable.MentionDisplayMode

data class User(
    val user_id: Long,
    val user_username: String,
    val user_image: String,
    val user_role: Int,
    val user_role_label: String?,
    val user_profession: Map<String, String>?,
    val user_created_at: String,
    val user_updated_at: String,
    var user_mention_start: Int,
    var user_mention_end: Int,
    var received_type: Int,
    var received_message_id: Int,
    var received_room_id: Int

) : BaseModel<User>(), Mentionable {

    constructor(parcel: Parcel) : this(
        parcel.readLong(),
        parcel.readString().toString(),
        parcel.readString().toString(),
        parcel.readInt(),
        parcel.readString().toString(),
        null,
        parcel.readString().toString(),
        parcel.readString().toString(),
        parcel.readInt(),
        parcel.readInt(),
        parcel.readInt(),
        parcel.readInt(),
        parcel.readInt()
    )

    companion object CREATOR : Parcelable.Creator<User> {
        override fun createFromParcel(parcel: Parcel): User {
            return User(parcel)
        }

        override fun newArray(size: Int): Array<User?> {
            return arrayOfNulls(size)
        }
    }

    override fun describeContents(): Int {
        return 0
    }

    override fun writeToParcel(dest: Parcel?, flags: Int) {
        dest!!.writeLong(user_id)
        dest.writeString(user_username)
        dest.writeString(user_image)
        dest.writeString(user_role_label)
        dest.writeInt(user_role)
        dest.writeString(user_created_at)
        dest.writeString(user_updated_at)
        dest.writeInt(user_mention_start)
        dest.writeInt(user_mention_end)
        dest.writeInt(received_message_id)
        dest.writeInt(received_room_id)
        dest.writeInt(received_type)
    }

    override fun getSuggestibleId(): Int {
        return user_username.hashCode()
    }

    override fun getSuggestiblePrimaryText(): String {
        return user_username
    }

    override fun getTextForDisplayMode(mode: MentionDisplayMode): String {
        return when (mode) {
            MentionDisplayMode.FULL -> user_username
            MentionDisplayMode.PARTIAL -> {
                val words: Array<String> = user_username.split(" ").toTypedArray()
                if (words.size > 1) words[0] else ""
            }
            MentionDisplayMode.NONE -> ""
            else -> ""
        }
    }

    override fun getDeleteStyle(): MentionDeleteStyle {
        // People support partial deletion
        // i.e. "John Doe" -> DEL -> "John" -> DEL -> ""
        return MentionDeleteStyle.PARTIAL_NAME_DELETE
    }
}