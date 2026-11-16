package fambox.pro.network.model.chat;


import com.google.gson.annotations.SerializedName;

import java.util.Date;
import java.util.List;

import fambox.pro.privatechat.network.model.User;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class PrivateMessageUserListResponse extends
        BasePrivateMessageModel<PrivateMessageUserListResponse> {
    @SerializedName("room_id")
    private String roomId;
    @SerializedName("room_key")
    private String roomKey;
    @SerializedName("room_type")
    private String roomType;
    @SerializedName("room_image")
    private String roomImage;
    @SerializedName("room_name")
    private String roomName;
    @SerializedName("room_members")
    private List<User> room_members;
    @SerializedName("room_is_owner")
    private boolean roomIsOwner;
    @SerializedName("room_updated_at")
    private Date roomUpdatedAt;
    @SerializedName("room_created_at")
    private Date roomCreatedAt;

    private int unreadMessageCount;

    public int getUnreadMessageCount() {
        return unreadMessageCount;
    }

    public void setUnreadMessageCount(int unreadMessageCount) {
        this.unreadMessageCount = unreadMessageCount;
    }
}
