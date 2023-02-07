package fambox.pro.privatechat.network.model

import android.os.Parcel
import android.os.Parcelable

data class Like(
    val like_message_id: Long,
    val like_id: Int,
    val like_type: Int,
    val like_user_id: Long,
    val like_updated_at: String,
    val like_created_at: String
) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readLong(),
        parcel.readInt(),
        parcel.readInt(),
        parcel.readLong(),
        parcel.readString()!!,
        parcel.readString()!!
    )

    override fun equals(other: Any?): Boolean {
        other as Like
        if (like_user_id != other.like_user_id) return false
        return true
    }

    override fun hashCode(): Int {
        return like_user_id.hashCode()
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeLong(like_message_id)
        parcel.writeInt(like_id)
        parcel.writeInt(like_type)
        parcel.writeLong(like_user_id)
        parcel.writeString(like_updated_at)
        parcel.writeString(like_created_at)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<Like> {
        override fun createFromParcel(parcel: Parcel): Like {
            return Like(parcel)
        }

        override fun newArray(size: Int): Array<Like?> {
            return arrayOfNulls(size)
        }
    }
}