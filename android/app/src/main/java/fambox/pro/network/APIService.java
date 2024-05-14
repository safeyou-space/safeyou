package fambox.pro.network;

import static fambox.pro.Constants.API_ADD_EMERGENCY_CONTACT;
import static fambox.pro.Constants.API_ADD_EMERGENCY_SERVICE;
import static fambox.pro.Constants.API_CHANGE_LANGUAGE;
import static fambox.pro.Constants.API_CHANGE_PASSWORD;
import static fambox.pro.Constants.API_CONSULTANT_REQUEST;
import static fambox.pro.Constants.API_CREATE_SURVEY_ANSWER;
import static fambox.pro.Constants.API_DELETE_ACCOUNT;
import static fambox.pro.Constants.API_EDIT_DELETE_EMERGENCY_CONTACT;
import static fambox.pro.Constants.API_EDIT_DELETE_EMERGENCY_SERVICE;
import static fambox.pro.Constants.API_FORGOT_CREATE_PASSWORD;
import static fambox.pro.Constants.API_FORGOT_PASSWORD;
import static fambox.pro.Constants.API_FORGOT_PASSWORD_VERIFY_CODE;
import static fambox.pro.Constants.API_GET_CATEGORY_BY_TYPES;
import static fambox.pro.Constants.API_GET_CATEGORY_TYPES;
import static fambox.pro.Constants.API_GET_CONFIG;
import static fambox.pro.Constants.API_GET_COUNTRIES;
import static fambox.pro.Constants.API_GET_LANGUAGES_BY_COUNTRY;
import static fambox.pro.Constants.API_GET_MARRIED_LIST;
import static fambox.pro.Constants.API_GET_RECORD;
import static fambox.pro.Constants.API_GET_SERVICES_NAME;
import static fambox.pro.Constants.API_GET_SERVICE_BY_SERVICE_ID;
import static fambox.pro.Constants.API_GET_SINGLE_RECORD;
import static fambox.pro.Constants.API_LEGAL_SERVICE;
import static fambox.pro.Constants.API_LOGIN;
import static fambox.pro.Constants.API_LOGOUT;
import static fambox.pro.Constants.API_NGO;
import static fambox.pro.Constants.API_PROFILE;
import static fambox.pro.Constants.API_PROFILE_FIND_TOWN_CITY;
import static fambox.pro.Constants.API_PROFILE_QUESTIONS;
import static fambox.pro.Constants.API_PROFILE_SINGLE;
import static fambox.pro.Constants.API_RECORD;
import static fambox.pro.Constants.API_REFRESH_TOKEN;
import static fambox.pro.Constants.API_REGISTRATION;
import static fambox.pro.Constants.API_REMOVE_PROFILE_IMAGE;
import static fambox.pro.Constants.API_RESEND_VERIFICATION_CODE;
import static fambox.pro.Constants.API_SEND_HELP_SMS;
import static fambox.pro.Constants.API_SEND_RECORD;
import static fambox.pro.Constants.API_SERVICES;
import static fambox.pro.Constants.API_SURVEY_BY_ID;
import static fambox.pro.Constants.API_SURVEY_LIST;
import static fambox.pro.Constants.API_TERMS_AND_CONDITIONS;
import static fambox.pro.Constants.API_VERIFY_CHANGED_PHONE_NUMBER;
import static fambox.pro.Constants.API_VERIFY_PHONE;
import static fambox.pro.Constants.API_VERIFY_PHONE_RESEND;
import static fambox.pro.Constants.API_VOLUNTEER;
import static fambox.pro.Constants.COUNTRY_PATH;
import static fambox.pro.Constants.DELETE_MESSAGE;
import static fambox.pro.Constants.EDIT_MESSAGE;
import static fambox.pro.Constants.GET_ALL_FORUMS;
import static fambox.pro.Constants.GET_BLOCKED_USERS;
import static fambox.pro.Constants.GET_CHECK_POLICE;
import static fambox.pro.Constants.GET_CONSULTANT_CATEGORIES;
import static fambox.pro.Constants.GET_FORUM_BY_ID;
import static fambox.pro.Constants.GET_FORUM_COMMENTS;
import static fambox.pro.Constants.GET_FORUM_FILTER_CATEGORIES;
import static fambox.pro.Constants.GET_JOIN_ROOM;
import static fambox.pro.Constants.GET_LEAVE_ROOM;
import static fambox.pro.Constants.GET_MESSAGES;
import static fambox.pro.Constants.GET_MESSAGES_FROM_NOTIFICATION;
import static fambox.pro.Constants.GET_NOTIFICATIONS;
import static fambox.pro.Constants.GET_PRIVATE_MESSAGES;
import static fambox.pro.Constants.GET_REPORT_CATEGORIES;
import static fambox.pro.Constants.GET_ROOM_MEMBERS;
import static fambox.pro.Constants.GET_UNREAD_MESSAGES;
import static fambox.pro.Constants.LOCALE_PHAT;
import static fambox.pro.Constants.POST_BLOCK_USER;
import static fambox.pro.Constants.POST_CREATE_ROOM;
import static fambox.pro.Constants.POST_FORUM_RATE;
import static fambox.pro.Constants.POST_NGO_RATE;
import static fambox.pro.Constants.POST_REPORT;
import static fambox.pro.Constants.POST_SEND_MESSAGES;
import static fambox.pro.Constants.POST_UNBLOCK_USER;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import fambox.pro.network.model.BlockUserPostBody;
import fambox.pro.network.model.ChangePasswordBody;
import fambox.pro.network.model.CheckPoliceResponseBody;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.CreateNewPasswordBody;
import fambox.pro.network.model.DeviceConfigBody;
import fambox.pro.network.model.EmergencyContactBody;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ForgotVerifySmsResponse;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.network.model.RateForumBody;
import fambox.pro.network.model.RateServiceBody;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.network.model.RefreshTokenResponse;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.network.model.ReportPostBody;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.network.model.SurveyListResponse;
import fambox.pro.network.model.Surveys;
import fambox.pro.network.model.UnityNetworkResponse;
import fambox.pro.network.model.VerifyPhoneBody;
import fambox.pro.network.model.VerifyPhoneResendBody;
import fambox.pro.network.model.chat.BasePrivateMessageModel;
import fambox.pro.network.model.chat.BlockUserResponse;
import fambox.pro.network.model.chat.PrivateMessageUnreadListResponse;
import fambox.pro.network.model.chat.PrivateMessageUserListResponse;
import fambox.pro.network.model.forum.ForumBase;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.privatechat.network.model.BaseModel;
import fambox.pro.privatechat.network.model.BlockedUsers;
import fambox.pro.privatechat.network.model.ChatMessage;
import fambox.pro.privatechat.network.model.Notification;
import fambox.pro.privatechat.network.model.Room;
import fambox.pro.privatechat.network.model.User;
import io.reactivex.Single;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.FieldMap;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Part;
import retrofit2.http.PartMap;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface APIService {

    /*-----------------------------Auth-----------------------------------*/
    @POST(API_REGISTRATION)
    Single<Response<Message>> registration(@Path(COUNTRY_PATH) String countryCode,
                                           @Path(LOCALE_PHAT) String language,
                                           @Body RegistrationBody registrationBody);

    @POST(API_LOGIN)
    Single<Response<LoginResponse>> login(@Path(COUNTRY_PATH) String countryCode,
                                          @Path(LOCALE_PHAT) String language,
                                          @Body LoginBody loginBody);

    @POST(API_LOGOUT)
    Single<Response<Message>> logout(@Path(COUNTRY_PATH) String countryCode,
                                     @Path(LOCALE_PHAT) String language);

    @DELETE(API_DELETE_ACCOUNT)
    Single<Response<Message>> deleteAccount(@Path(COUNTRY_PATH) String countryCode,
                                            @Path(LOCALE_PHAT) String language);

    @POST(API_REFRESH_TOKEN)
    Call<RefreshTokenResponse> refreshToken(@Path(COUNTRY_PATH) String countryCode,
                                            @Path(LOCALE_PHAT) String locale,
                                            @Body HashMap<String, String> refreshTokenBody);

    @POST(API_VERIFY_PHONE)
    Single<Response<Message>> verifyPhone(@Path(COUNTRY_PATH) String countryCode,
                                          @Path(LOCALE_PHAT) String language,
                                          @Body VerifyPhoneBody verifyPhoneBody);

    @POST(API_VERIFY_PHONE_RESEND)
    Single<Response<Message>> verifyPhoneResend(@Path(COUNTRY_PATH) String countryCode,
                                                @Path(LOCALE_PHAT) String language,
                                                @Body VerifyPhoneResendBody verifyPhoneResendBody);

    @POST(API_RESEND_VERIFICATION_CODE)
    Single<Response<Message>> resendVerificationCode(@Path(COUNTRY_PATH) String countryCode,
                                                     @Path(LOCALE_PHAT) String language,
                                                     @Body VerifyPhoneResendBody verifyPhoneResendBody);

    @POST(API_CHANGE_PASSWORD)
    Single<Response<Message>> changePassword(@Path(COUNTRY_PATH) String countryCode,
                                             @Path(LOCALE_PHAT) String language,
                                             @Body ChangePasswordBody body);

    @FormUrlEncoded
    @POST(API_FORGOT_PASSWORD)
    Single<Response<Message>> forgotPasswordSendPhone(@Path(COUNTRY_PATH) String countryCode,
                                                      @Path(LOCALE_PHAT) String language,
                                                      @FieldMap HashMap<String, String> phoneNumber);


    @POST(API_FORGOT_PASSWORD_VERIFY_CODE)
    Single<Response<ForgotVerifySmsResponse>> verifyForgotPhone(@Path(COUNTRY_PATH) String countryCode,
                                                                @Path(LOCALE_PHAT) String language,
                                                                @Body VerifyPhoneBody verifyPhoneBody);

    @POST(API_FORGOT_CREATE_PASSWORD)
    Single<Response<Message>> createNewPassword(@Path(COUNTRY_PATH) String countryCode,
                                                @Path(LOCALE_PHAT) String language,
                                                @Body CreateNewPasswordBody createNewPasswordBody);


    /*-----------------------------Language-----------------------------------*/

    @GET(API_GET_LANGUAGES_BY_COUNTRY)
    Single<Response<List<CountriesLanguagesResponseBody>>> getLanguages(@Path(COUNTRY_PATH) String countryCode,
                                                                        @Path(LOCALE_PHAT) String locale);

    /*-----------------------------Change language-----------------------------------*/
    @GET(API_CHANGE_LANGUAGE)
    Single<Response<ResponseBody>> changeLanguage(@Path(COUNTRY_PATH) String countryCode,
                                                  @Path(LOCALE_PHAT) String locale);

    /*-----------------------------Profile-----------------------------------*/
    @GET(API_PROFILE)
    Single<Response<ProfileResponse>> getProfile(@Path(COUNTRY_PATH) String countryCode,
                                                 @Path(LOCALE_PHAT) String language);

    //    @DELETE("/api/{country_code}/{language}/profile/delete_answer_question?answer_id=92")
//    Single<Response<List<ProfileQuestionsResponse>>> getProfileQuestions(@Path(COUNTRY_PATH) String countryCode,
//                                                                         @Path(LOCALE_PHAT) String language);
    @GET(API_SURVEY_LIST)
    Single<Response<SurveyListResponse>> getSurveyList(@Path(COUNTRY_PATH) String countryCode,
                                                       @Path(LOCALE_PHAT) String language,
                                                       @Query("page") int page);

    @GET(API_SURVEY_BY_ID)
    Single<Response<Surveys>> getSurveyById(@Path(COUNTRY_PATH) String countryCode,
                                            @Path(LOCALE_PHAT) String language,
                                            @Path("surveyId") long surveyId);

    @POST(API_CREATE_SURVEY_ANSWER)
    Single<Response<Message>> createSurveyAnswer(@Path(COUNTRY_PATH) String countryCode,
                                                 @Path(LOCALE_PHAT) String language,
                                                 @Body HashMap<String, Object> data);

    @GET(API_PROFILE_QUESTIONS)
    Single<Response<List<ProfileQuestionsResponse>>> getProfileQuestions(@Path(COUNTRY_PATH) String countryCode,
                                                                         @Path(LOCALE_PHAT) String language);

    @GET(API_PROFILE_QUESTIONS)
    Single<Response<List<ProfileQuestionsResponse>>> getQuestionOptions(@Path(COUNTRY_PATH) String countryCode,
                                                                        @Path(LOCALE_PHAT) String language,
                                                                        @Query("question_id") long questionId);

    @GET(API_PROFILE_FIND_TOWN_CITY)
    Single<Response<List<ProfileQuestionOption>>> findTownOrCity(@Path(COUNTRY_PATH) String countryCode,
                                                                 @Path(LOCALE_PHAT) String language,
                                                                 @Query("keyword") String keyword);

    @GET(API_PROFILE_SINGLE)
    Single<Response<ResponseBody>> getProfileSingle(@Path(COUNTRY_PATH) String countryCode,
                                                    @Path(LOCALE_PHAT) String language,
                                                    @Path("field_name") String fieldName);

    @FormUrlEncoded
    @PUT(API_PROFILE)
    Single<Response<Message>> editProfile(@Path(COUNTRY_PATH) String countryCode,
                                          @Path(LOCALE_PHAT) String language,
                                          @FieldMap HashMap<String, Object> data);

    @Multipart
    @POST(API_PROFILE)
    Single<Response<Message>> editPhoto(@Path(COUNTRY_PATH) String countryCode,
                                        @Path(LOCALE_PHAT) String language,
                                        @Part MultipartBody.Part image,
                                        @Part("field_name") RequestBody fieldName,
                                        @Part("_method") RequestBody method);

    @POST(API_ADD_EMERGENCY_CONTACT)
    Single<Response<Message>> addEmergencyContact(@Path(COUNTRY_PATH) String countryCode,
                                                  @Path(LOCALE_PHAT) String language,
                                                  @Body EmergencyContactBody body);

    @PUT(API_EDIT_DELETE_EMERGENCY_CONTACT)
    Single<Response<Message>> editEmergencyContact(@Path(COUNTRY_PATH) String countryCode,
                                                   @Path(LOCALE_PHAT) String language,
                                                   @Path("id") long id,
                                                   @Body EmergencyContactBody body);

    @DELETE(API_EDIT_DELETE_EMERGENCY_CONTACT)
    Single<Response<Message>> deleteEmergencyContact(@Path(COUNTRY_PATH) String countryCode,
                                                     @Path(LOCALE_PHAT) String language,
                                                     @Path("id") long id);

    @POST(API_ADD_EMERGENCY_SERVICE)
    Single<Response<Message>> addEmergencyService(@Path(COUNTRY_PATH) String countryCode,
                                                  @Path(LOCALE_PHAT) String language,
                                                  @Body HashMap<String, Long> data);

    @PUT(API_EDIT_DELETE_EMERGENCY_SERVICE)
    Single<Response<Message>> editEmergencyService(@Path(COUNTRY_PATH) String countryCode,
                                                   @Path(LOCALE_PHAT) String language,
                                                   @Path("id") long id,
                                                   @Body HashMap<String, Long> data);

    @DELETE(API_EDIT_DELETE_EMERGENCY_SERVICE)
    Single<Response<Message>> deleteEmergencyService(@Path(COUNTRY_PATH) String countryCode,
                                                     @Path(LOCALE_PHAT) String language,
                                                     @Path("id") long id);

    @POST(API_VERIFY_CHANGED_PHONE_NUMBER)
    Single<Response<Message>> verifyChangedPhoneNumber(@Path(COUNTRY_PATH) String countryCode,
                                                       @Path(LOCALE_PHAT) String language,
                                                       @Body VerifyPhoneBody verifyPhoneBody);

    @DELETE(API_REMOVE_PROFILE_IMAGE)
    Single<Response<Message>> removeProfileImage(@Path(COUNTRY_PATH) String countryCode,
                                                 @Path(LOCALE_PHAT) String language);

    @GET(API_GET_SERVICES_NAME)
    Single<Response<ResponseBody>> getAllServicesNameLit(@Path(COUNTRY_PATH) String countryCode,
                                                         @Path(LOCALE_PHAT) String language);

    /*-----------------------------Content-----------------------------------*/
    @GET(API_TERMS_AND_CONDITIONS)
    Single<Response<ContentResponse>> getContent(@Path(COUNTRY_PATH) String countryCode,
                                                 @Path(LOCALE_PHAT) String language,
                                                 @Path("title") String title,
                                                 @Path("age") String age);

    /*-----------------------------NGO-----------------------------------*/
    @GET(API_NGO)
    Single<Response<List<UnityNetworkResponse>>> getNGO(@Path(COUNTRY_PATH) String countryCode,
                                                        @Path(LOCALE_PHAT) String language);

    /*-----------------------------Legal Service-----------------------------------*/
    @GET(API_LEGAL_SERVICE)
    Single<Response<List<UnityNetworkResponse>>> getLegalService(@Path(COUNTRY_PATH) String countryCode,
                                                                 @Path(LOCALE_PHAT) String language);

    /*-----------------------------Volunteer-----------------------------------*/
    @GET(API_VOLUNTEER)
    Single<Response<List<UnityNetworkResponse>>> getVolunteers(@Path(COUNTRY_PATH) String countryCode,
                                                               @Path(LOCALE_PHAT) String language);

    /*-----------------------------Services-----------------------------------*/
    @GET(API_SERVICES)
    Single<Response<List<ServicesResponseBody>>> getServices(@Path(COUNTRY_PATH) String countryCode,
                                                             @Path(LOCALE_PHAT) String language,
                                                             @Query("is_send_sms") boolean isSendSms);

    @GET(API_SERVICES)
    Single<Response<List<ServicesSearchResponse>>> searchServices(@Path(COUNTRY_PATH) String countryCode,
                                                                  @Path(LOCALE_PHAT) String language,
                                                                  @Query("search_string") String search);

    /*-----------------------------Record-----------------------------------*/
    @Multipart
    @POST(API_RECORD)
    Single<Response<Message>> addRecord(@Path(COUNTRY_PATH) String countryCode,
                                        @Path(LOCALE_PHAT) String language,
                                        @Part MultipartBody.Part audio,
                                        @Part("name") RequestBody name,
                                        @Part("location") RequestBody location,
                                        @Part("latitude") RequestBody latitude,
                                        @Part("longitude") RequestBody longitude,
                                        @Part("duration") RequestBody duration,
                                        @Part("date") RequestBody date,
                                        @Part("time") RequestBody time,
                                        @Query("send") boolean send);

    @GET(API_GET_RECORD)
    Single<Response<List<RecordResponse>>> getRecords(@Path(COUNTRY_PATH) String countryCode,
                                                      @Path(LOCALE_PHAT) String language);

    @GET(API_GET_RECORD)
    Single<Response<List<RecordResponse>>> getRecordIsSentSearch(@Path(COUNTRY_PATH) String countryCode,
                                                                 @Path(LOCALE_PHAT) String language,
                                                                 @Query("sent") String sent,
                                                                 @Query("search_string") String search);

    @GET(API_GET_RECORD)
    Single<Response<List<RecordSearchResult>>> searchRecord(@Path(COUNTRY_PATH) String countryCode,
                                                            @Path(LOCALE_PHAT) String language,
                                                            @Query("search_string") String search);

    @GET(API_GET_SINGLE_RECORD)
    Single<Response<RecordResponse>> getSingleRecord(@Path(COUNTRY_PATH) String countryCode,
                                                     @Path(LOCALE_PHAT) String language,
                                                     @Path("record_id") long recordId);

    @DELETE(API_GET_SINGLE_RECORD)
    Single<Response<Message>> deleteRecord(@Path(COUNTRY_PATH) String countryCode,
                                           @Path(LOCALE_PHAT) String language,
                                           @Path("record_id") long recordId);

    @FormUrlEncoded
    @POST(API_SEND_RECORD)
    Single<Response<Message>> sendMailRecord(@Path(COUNTRY_PATH) String countryCode,
                                             @Path(LOCALE_PHAT) String language,
                                             @Path("record_id") long recordId,
                                             @FieldMap HashMap<String, String> location);


    /*-----------------------------Send Help Message-----------------------------------*/
    @FormUrlEncoded
    @POST(API_SEND_HELP_SMS)
    Single<Response<Message>> sendHelpSms(@Path(COUNTRY_PATH) String countryCode,
                                          @Path(LOCALE_PHAT) String language,
                                          @FieldMap HashMap<String, String> location);

    /*-----------------------------GET married list-----------------------------------*/
    @GET(API_GET_MARRIED_LIST)
    Single<Response<List<MarriedListResponse>>> getMarriedList(@Path(COUNTRY_PATH) String countryCode,
                                                               @Path(LOCALE_PHAT) String locale);

    /*-----------------------------GET countries-----------------------------------*/
    @GET(API_GET_COUNTRIES)
    Single<Response<List<CountriesLanguagesResponseBody>>> getCountries(@Path(COUNTRY_PATH) String countryCode,
                                                                        @Path(LOCALE_PHAT) String locale);

    /*-----------------------------GET service by service id-----------------------------------*/
    @GET(API_GET_SERVICE_BY_SERVICE_ID)
    Single<Response<ServicesResponseBody>> getServiceByServiceId(@Path(COUNTRY_PATH) String countryCode,
                                                                 @Path(LOCALE_PHAT) String locale,
                                                                 @Path("service_id") long id);

    /*-----------------------------GET categories-----------------------------------*/
    @GET(API_GET_CATEGORY_TYPES)
    Single<Response<ResponseBody>> getCategoryTypes(@Path(COUNTRY_PATH) String countryCode,
                                                    @Path(LOCALE_PHAT) String locale,
                                                    @Query("is_send_sms") boolean isSendSms);

    @GET(API_GET_CATEGORY_BY_TYPES)
    Single<Response<List<ServicesResponseBody>>> getCategoryByTypesID(@Path(COUNTRY_PATH) String countryCode,
                                                                      @Path(LOCALE_PHAT) String locale,
                                                                      @Path("category_id") long categoryId,
                                                                      @Query("is_send_sms") boolean isSendSms);

    /*-----------------------------GET config----------------------------------*/
    @GET(API_GET_CONFIG)
    Single<Response<List<DeviceConfigBody>>> getDeviceConfig(@Path(COUNTRY_PATH) String countryCode,
                                                             @Query("api_key") String apiKey);

    /*-----------------------------POST consultant request----------------------------------*/
    @POST(API_CONSULTANT_REQUEST)
    Single<Response<ResponseBody>> consultantRequest(@Path(COUNTRY_PATH) String countryCode,
                                                     @Path(LOCALE_PHAT) String language,
                                                     @Body Object consultantRequest);

    /*-----------------------------DELETE consultant request----------------------------------*/
    @DELETE(API_CONSULTANT_REQUEST)
    Single<Response<ResponseBody>> cancelConsultantRequest(@Path(COUNTRY_PATH) String countryCode,
                                                           @Path(LOCALE_PHAT) String language);

    /*-----------------------------PUT consultant request----------------------------------*/
    @PUT(API_CONSULTANT_REQUEST)
    Single<Response<ResponseBody>> deactivateConsultantRequest(@Path(COUNTRY_PATH) String countryCode,
                                                               @Path(LOCALE_PHAT) String language);

    /*-----------------------------GET consultant categories----------------------------------*/
    @GET(GET_CONSULTANT_CATEGORIES)
    Single<Response<HashMap<Integer, String>>> getConsultantCategories(@Path(COUNTRY_PATH) String countryCode,
                                                                       @Path(LOCALE_PHAT) String language);

    /*-----------------------NEW INTEGRATIONS----------------------------*/

    /*-----------------------------Private Message list-----------------------------------*/
    @GET(GET_PRIVATE_MESSAGES)
    Call<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>> getPrivateMessageUserList();

    /*-----------------------------Private Message list-----------------------------------*/
    @GET(GET_UNREAD_MESSAGES)
    Call<PrivateMessageUnreadListResponse> getUnreadMessageList(@Path("room_key") String roomKey);

    /*-----------------------------Jon room-----------------------------------*/
    // PRIVATE_CHAT_5_15
    @GET(GET_JOIN_ROOM)
    Call<BaseModel<Room>> joinRoom(@Path("room_key") String roomKey);

    /*-----------------------------Create room-----------------------------------*/
    @Multipart
    @POST(POST_CREATE_ROOM)
    Call<BaseModel<Room>> createRoom(@PartMap Map<String, RequestBody> body);

    /*-----------------------------Leave room-----------------------------------*/
    @GET(GET_LEAVE_ROOM)
    Call<BaseModel<Room>> leaveRoom(@Path("room_key") String roomKey);

    /*-----------------------------Room members list-----------------------------------*/
    @GET(GET_ROOM_MEMBERS)
    Call<BaseModel<List<User>>> getRoomMembers(@Path("room_key") String roomKey);

    /*-----------------------------Get messages-----------------------------------*/
    @GET(GET_MESSAGES)
    Call<BaseModel<List<ChatMessage>>> getMessages(
            @Path("room_key") String roomKey,
            @Query("limit") int limit,
            @Query("skip") int skip
    );

    /*-----------------------------Send Message-----------------------------------*/
    @Multipart
    @POST(POST_SEND_MESSAGES)
    Call<BaseModel<ChatMessage>> sendMessage(
            @Path("room_key") String roomKey,
            @Part List<MultipartBody.Part> files,
            @PartMap Map<String, RequestBody> body
    );

    /*-----------------------------Edit Message-----------------------------------*/
    @Multipart
    @POST(EDIT_MESSAGE)
    Call<BaseModel<ChatMessage>> editMessage(
            @Path("room_key") String roomKey,
            @Path("message_id") long messageId,
            @Part List<MultipartBody.Part> files,
            @PartMap Map<String, RequestBody> body
    );

    @GET(GET_MESSAGES_FROM_NOTIFICATION)
    Call<BaseModel<List<ChatMessage>>> getReplyFromNotification(
            @Path("room_key") String roomKey,
            @Path("message_id") long messageId);

    /*-----------------------------Delete Message-----------------------------------*/
    @POST(DELETE_MESSAGE)
    Call<ResponseBody> deleteMessage(@Path("room_key") String roomKey,
                                     @Path("message_id") long messageId);

    /*-----------------------------Get forum filter categories----------------------*/
    @GET(GET_FORUM_FILTER_CATEGORIES)
    Single<Response<TreeMap<String, String>>> getForumFilterCategories(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language
    );

    /*-----------------------------Get all forums-----------------------------------*/
    @GET(GET_ALL_FORUMS)
    Single<Response<ForumBase>> getAllForums(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language,
            @Query("page") int page,
            @Query("_lang") String languageFilter,
            @Query("_cat") String categoryFilter,
            @Query("sorts") String categorySort
    );

    /*-----------------------------Get forum by id-----------------------------------*/
    @GET(GET_FORUM_BY_ID)
    Single<Response<ForumResponseBody>> getForumById(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language,
            @Path("forum_id") long forumId,
            @Query("device_type") String deviceType
    );

    /*-----------------------------Get forum comments-----------------------------------*/
    @GET(GET_FORUM_COMMENTS)
    Call<BaseModel<List<ChatMessage>>> getForumComments(
            @Path("room_key") String roomKey,
            @Query("limit") int limit,
            @Query("skip") int skip
    );

    @GET(GET_NOTIFICATIONS)
    Call<BaseModel<List<Notification>>> getNotifications();

    @GET(GET_BLOCKED_USERS)
    Call<BlockedUsers> getBlockedUsers();

    /*-----------------------------Get report categories----------------------*/
    @GET(GET_REPORT_CATEGORIES)
    Single<Response<HashMap<String, String>>> getReportCategories(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language
    );

    /*-----------------------------report----------------------*/
    @POST(POST_REPORT)
    Single<Response<HashMap<String, String>>> postReport(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language,
            @Body ReportPostBody reportPostBody);

    /*-----------------------------report----------------------*/
    @POST(POST_BLOCK_USER)
    Call<BlockUserResponse> postBlockUser(
            @Body BlockUserPostBody blockUserPostBody);

    /*-----------------------------report----------------------*/
    @POST(POST_UNBLOCK_USER)
    Call<BlockUserResponse> postUnBlockUser(
            @Body BlockUserPostBody blockUserPostBody);

    /*-----------------------------forum rate----------------------*/
    @POST(POST_FORUM_RATE)
    Single<Response<HashMap<String, String>>> postForumRate(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language,
            @Body RateForumBody rateBody);

    /*-----------------------------NGO rate----------------------*/
    @POST(POST_NGO_RATE)
    Single<Response<HashMap<String, String>>> postNGORate(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language,
            @Body RateServiceBody rateBody);

    /*-----------------------------Get report categories----------------------*/
    @GET(GET_CHECK_POLICE)
    Single<Response<CheckPoliceResponseBody>> getPolice(
            @Path(COUNTRY_PATH) String countryCode,
            @Path(LOCALE_PHAT) String language
    );
}

