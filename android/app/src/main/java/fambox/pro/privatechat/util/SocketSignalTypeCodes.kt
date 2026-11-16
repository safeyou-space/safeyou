package fambox.pro.privatechat.util

enum class SocketSignalTypeCodes(val type: Int) {
    /** public: we get it when you connect to server. */
    SIGNAL_PROFILE(0),

    /** public: we get it when new users connect to the server. */
    SIGNAL_CONNECTED(1),

    /** public: we get it when users disconnect from the server. */
    SIGNAL_DISCONNECTED(2),

    /** public: we get it when new users join to the room. */
    SIGNAL_R_JOINED(3),

    /** public: we get it when users leave from the room. */
    SIGNAL_R_LEAVED(4),

    /** public: we get it when we add a new room. */
    SIGNAL_R_INSERT(5),

    /** public: we get it when we edit a room. */
    SIGNAL_R_UPDATE(6),

    /** public: we get it when we delete a room. */
    SIGNAL_R_DELETE(7),

    /** public: we get it when we send a new message in the room. */
    SIGNAL_M_INSERT(8),

    /** public: we get it when we edit a message in the room. */
    SIGNAL_M_UPDATE(9),

    /** public: we get it when we delete a message in the room. */
    SIGNAL_M_DELETE(10),

    /** public: we get it when users type a message in the room. */
    SIGNAL_M_TYPING(11),

    /** public: we get it when users view a message in the room. */
    SIGNAL_M_RECEIVED(12),

    /** public: notification. */
    SIGNAL_NOTIFICATION(13);

    companion object {
        fun find(value: Int): SocketSignalTypeCodes? = values().find { it.ordinal == value }
    }
}