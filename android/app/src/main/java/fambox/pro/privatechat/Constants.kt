package fambox.pro.privatechat

object Constants {

    /*Rest API*/
    const val GET_ROOM = "/api/rooms/list?type=2"
    const val GET_FRIEND = "/api/friends/list?joint_room_type=2"
    const val GET_JOIN_ROOM = "/api/rooms/{room_key}/join"
    const val GET_LEAVE_ROOM = "/api/rooms/{room_key}/leave"
    const val GET_ROOM_MEMBERS = "/api/rooms/{room_key}/members/list"
    const val GET_MESSAGES = "/api/rooms/{room_key}/messages/list"
    const val POST_SEND_MESSAGES = "/api/rooms/{room_key}/messages/send"
}