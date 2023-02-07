package fambox.pro;

public interface Constants {

    String LOCALE_PHAT = "language";
    String COUNTRY_PATH = "country_code";
    String API_KEY_ANDROID = "**********";
    String SAFE_YOU_URL_STRING_FORMAT = "https://safeyou.space?forumId=%d";
    String DOMAIN_URL = "https://safeyou.page.link";
    String ANDROID_PACKAGE_NAME = "fambox.pro";
    String IOS_PACKAGE_NAME = "**********";
    String IOS_APP_STORE_ID = "**********";

    String BASE_URL = "https://dashboard.safeyou.space:88";
    String BASE_SOCKET_URL = "https://dashboard.safeyou.space:1998";
    String BASE_SOCKET_URL_IRQ = "https://dashboard.safeyou.space:1996";
    String BASE_SOCKET_URL_GEO = "https://dashboard.safeyou.space:1997";

    String API_REGISTRATION = "/api/{country_code}/{language}/registration";
    String API_LOGIN = "/api/{country_code}/{language}/login";
    String API_LOGOUT = "/api/{country_code}/{language}/logout";
    String API_DELETE_ACCOUNT = "/api/{country_code}/{language}/profile/delete";
    String API_REFRESH_TOKEN = "/api/{country_code}/{language}/refresh";
    String API_PROFILE = "/api/{country_code}/{language}/profile";
    String API_GET_SERVICES_NAME = "/api/{country_code}/{language}/profile/emergency_contacts";
    String API_PROFILE_SINGLE = "/api/{country_code}/{language}/profile/{field_name}";
    String API_ADD_EMERGENCY_CONTACT = "/api/{country_code}/{language}/profile/emergency_contact";
    String API_EDIT_DELETE_EMERGENCY_CONTACT = "/api/{country_code}/{language}/profile/emergency_contact/{id}";
    String API_ADD_EMERGENCY_SERVICE = "/api/{country_code}/{language}/profile/emergency_service";
    String API_EDIT_DELETE_EMERGENCY_SERVICE = "/api/{country_code}/{language}/profile/emergency_service/{id}";
    String API_VERIFY_PHONE = "/api/{country_code}/{language}/verify_phone";
    String API_VERIFY_PHONE_RESEND = "/api/{country_code}/{language}/resend_verify_code";
    String API_RESEND_VERIFICATION_CODE = "/api/{country_code}/{language}/profile/resend_verify_code";
    String API_TERMS_AND_CONDITIONS = "/api/{country_code}/{language}/content/{title}{age}";
    String API_NGO = "/api/{country_code}/{language}/ngos";
    String API_LEGAL_SERVICE = "/api/{country_code}/{language}/legal_services";
    String API_VOLUNTEER = "/api/{country_code}/{language}/volunteers";
    String API_SERVICES = "/api/{country_code}/{language}/services";
    String API_RECORD = "/api/{country_code}/{language}/record";
    String API_GET_RECORD = "/api/{country_code}/{language}/records";
    String API_CHANGE_PASSWORD = "/api/{country_code}/{language}/profile/change_password";
    String API_GET_SINGLE_RECORD = "/api/{country_code}/{language}/record/{record_id}";
    String API_SEND_RECORD = "/api/{country_code}/{language}/record/sent/{record_id}";
    String API_SEND_HELP_SMS = "/api/{country_code}/{language}/sent/help_sms";
    String API_FORGOT_PASSWORD = "/api/{country_code}/{language}/forgot_password";
    String API_FORGOT_PASSWORD_VERIFY_CODE = "/api/{country_code}/{language}/forgot_password_verify_code";
    String API_VERIFY_CHANGED_PHONE_NUMBER = "/api/{country_code}/{language}/profile/verify_phone_number";
    String API_FORGOT_CREATE_PASSWORD = "/api/{country_code}/{language}/create_password";
    String API_REMOVE_PROFILE_IMAGE = "/api/{country_code}/{language}/profile/remove_image";
    String API_GET_MARRIED_LIST = "/api/{country_code}/{language}/marital_statuses";

    String API_GET_COUNTRIES = "/api/{country_code}/{language}/countries";
    String API_GET_LANGUAGES_BY_COUNTRY = "/api/{country_code}/{language}/languages";
    String API_CHANGE_LANGUAGE = "/api/{country_code}/{language}/profile/language";
    String API_GET_SERVICE_BY_SERVICE_ID = "/api/{country_code}/{language}/service/{service_id}";
    String API_GET_CATEGORY_TYPES = "/api/{country_code}/{language}/service_categories";
    String API_GET_CATEGORY_BY_TYPES = "/api/{country_code}/{language}/services_by_category/{category_id}";
    String API_EDIT_EMERGENCY_SERVICE = "/api/{country_code}/{language}/emergency_service/{service_id}";
    String API_GET_CONFIG = "/api/{country_code}/config";
    String API_CONSULTANT_REQUEST = "/api/{country_code}/{language}/profile/consultant_request";
    String GET_CONSULTANT_CATEGORIES = "/api/{country_code}/{language}/consultant_categories";

    // NEW INTEGRATIONS
    String GET_PRIVATE_MESSAGES = "/api/rooms/list?type=2";
    String GET_FRIEND = "/api/friends/list?joint_room_type=2";
    String GET_JOIN_ROOM = "/api/rooms/{room_key}/join";
    String POST_CREATE_ROOM = "/api/rooms/create";
    String GET_LEAVE_ROOM = "/api/rooms/{room_key}/leave";
    String GET_ROOM_MEMBERS = "/api/rooms/{room_key}/members/list";
    String GET_MESSAGES = "/api/rooms/{room_key}/messages/list";
    String POST_SEND_MESSAGES = "/api/rooms/{room_key}/messages/send";
    String GET_UNREAD_MESSAGES = "/api/rooms/{room_key}/unread/messages";
    String GET_FORUM_FILTER_CATEGORIES = "/api/{country_code}/{language}/forum/categories";
    String GET_REPORT_CATEGORIES = "/api/{country_code}/{language}/report/categories";
    String POST_REPORT = "/api/{country_code}/{language}/report";
    String GET_CHECK_POLICE = "/api/{country_code}/{language}/translation/check_police_title*****check_police_description";

    //forums
    String GET_ALL_FORUMS = "/api/{country_code}/{language}/forums";
    String GET_FORUM_BY_ID = "/api/{country_code}/{language}/forum/{forum_id}";
    String GET_FORUM_COMMENTS = "/api/rooms/{room_key}/messages/list";
    String DELETE_MESSAGE = "/api/rooms/{room_key}/messages/{message_id}/delete";
    String EDIT_MESSAGE = "/api/rooms/{room_key}/messages/{message_id}/update";
    String GET_NOTIFICATIONS = "/api/notifications";
    String GET_BLOCKED_USERS = "/api/banlist";
    String POST_BLOCK_USER = "/api/banlist/ban";
    String POST_UNBLOCK_USER = "/api/banlist/unban";
    String GET_MESSAGES_FROM_NOTIFICATION = "/api/rooms/{room_key}/messages/{message_id}/list";

    String POST_FORUM_RATE = "/api/{country_code}/{language}/rate/forum";
    String POST_NGO_RATE = "/api/{country_code}/{language}/rate/service";

    int NOTIFICATION_ID_FOREGROUND_SERVICE = 8466503;

    interface Key {
        String KEY_USER_ID = "user_id";
        String KEY_USER_PHONE = "user_phone";
        String KEY_BIRTHDAY = "user_birthday";
        String KEY_PASSWORD = "password";
        String KEY_VERIFICATION_FOR_NEW_PASSWORD = "key_verification_for_new_password";
        String KEY_PHONE_NUMBER = "key_phone_number";
        String KEY_PHONE_NUMBER_BUNDLE = "key_phone_number_bundle";
        String KEY_REQUEST_NEW_PASSWORD = "key_request_new_password";
        String KEY_LOG_IN_FIRST_TIME = "key_log_in_first_time";
        String KEY_IS_NOTIFICATION_ENABLED = "key_is_notification_enabled";
        String KEY_IS_DARK_MODE_ENABLED = "key_night_mode_enabled";
        String KEY_LOG_IN_FIRST_TIME_FOR_POPUP = "key_log_in_first_time_for_popup";
        String KEY_SEND_PHONE_TO_VERIFICATION = "key_send_verification";
        String KEY_SHARED_REAL_PIN = "key_shared_real_pin";
        String KEY_SHARED_FAKE_PIN = "key_shared_fake_pin";
        String KEY_ACTION_LOG_OUT = "key_action_log_out";
        String KEY_IS_TERM = "is_term";
        String KEY_REGISTRATION_FORM = "REGISTRATION_FORM";
        String KEY_IS_PRIVACY_POLICY = "privacy_police";
        String KEY_IS_CONSULTANT_CONDITION = "is_consultant_condition";
        String KEY_IS_ABOUT_US = "about_us";
        String KEY_UNITY_NETWORK = "key_unity_network";
        String KEY_SERVICE_ID = "key_service_id";
        String KEY_SERVICE_TYPE = "key_service_type";
        String KEY_FORGOT_PASSWORD = "key_forgot_password";
        String KEY_FORGOT_PASSWORD_VERIFY_TOKEN = "key_forgot_password_verify_token";
        String KEY_CHANGE_PHONE_NUMBER = "key_change_phone_number";
        String KEY_CHANGE_PHONE_NUMBER_BOOLEAN = "key_change_phone_number_boolean";
        String KEY_MARITAL_STATUS = "key_marital_status";
        String KEY_WITHOUT_PIN = "key_without_pin";
        String KEY_COUNTRY_CODE = "key_country_code";
        String KEY_COUNTRY_CODE_BUNDLE = "key_country_code_BUNDLE";
        String KEY_CHANGE_COUNTRY = "key_change_country";
        String KEY_CHANGE_LANGUAGE = "key_change_language";
        String KEY_CHANGE_PIN = "key_change_pin";
        String KEY_COUNTRY_CHANGED = "key_country_changed";
        String KEY_IS_CAMOUFLAGE_ICON_ENABLED = "key_is_camouflage_icon_enabled";
        String KEY_IS_ART_GALLERY_ENABLED = "key_is_art_gallery_enabled";
        String KEY_IS_GALLERY_EDIT_ENABLED = "key_is_gallery_edit_enabled";
        String KEY_IS_PHOTO_EDITOR_ENABLED = "key_is_photo_editor_enabled";
    }
}
