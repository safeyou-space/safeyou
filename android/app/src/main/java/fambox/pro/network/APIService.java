package fambox.pro.network;

import java.util.HashMap;
import java.util.List;

import fambox.pro.network.model.ChangePasswordBody;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.network.model.CreateNewPasswordBody;
import fambox.pro.network.model.DeviceConfigBody;
import fambox.pro.network.model.EmergencyContactBody;
import fambox.pro.network.model.ForgotVerifySmsResponse;
import fambox.pro.network.model.LoginBody;
import fambox.pro.network.model.LoginResponse;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.network.model.RefreshTokenResponse;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.network.model.UnityNetworkResponse;
import fambox.pro.network.model.VerifyPhoneBody;
import fambox.pro.network.model.VerifyPhoneResendBody;
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
import retrofit2.http.Path;
import retrofit2.http.Query;

import static fambox.pro.Constants.API_ADD_EMERGENCY_CONTACT;
import static fambox.pro.Constants.API_ADD_EMERGENCY_SERVICE;
import static fambox.pro.Constants.API_CHANGE_PASSWORD;
import static fambox.pro.Constants.API_CONSULTANT_REQUEST;
import static fambox.pro.Constants.API_EDIT_DELETE_EMERGENCY_CONTACT;
import static fambox.pro.Constants.API_EDIT_DELETE_EMERGENCY_SERVICE;
import static fambox.pro.Constants.API_EDIT_EMERGENCY_SERVICE;
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
import static fambox.pro.Constants.API_PROFILE_SINGLE;
import static fambox.pro.Constants.API_RECORD;
import static fambox.pro.Constants.API_REFRESH_TOKEN;
import static fambox.pro.Constants.API_REGISTRATION;
import static fambox.pro.Constants.API_REMOVE_PROFILE_IMAGE;
import static fambox.pro.Constants.API_RESEND_VERIFICATION_CODE;
import static fambox.pro.Constants.API_SEND_HELP_SMS;
import static fambox.pro.Constants.API_SEND_RECORD;
import static fambox.pro.Constants.API_SERVICES;
import static fambox.pro.Constants.API_TERMS_AND_CONDITIONS;
import static fambox.pro.Constants.API_VERIFY_CHANGED_PHONE_NUMBER;
import static fambox.pro.Constants.API_VERIFY_PHONE;
import static fambox.pro.Constants.API_VERIFY_PHONE_RESEND;
import static fambox.pro.Constants.API_VOLUNTEER;
import static fambox.pro.Constants.COUNTRY_PATH;
import static fambox.pro.Constants.GET_CONSULTANT_CATEGORIES;
import static fambox.pro.Constants.LOCALE_PHAT;

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

    /*-----------------------------Profile-----------------------------------*/
    @GET(API_PROFILE)
    Single<Response<ProfileResponse>> getProfile(@Path(COUNTRY_PATH) String countryCode,
                                                 @Path(LOCALE_PHAT) String language);

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
                                                 @Path("title") String title);

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

    /*-----------------------------Edit emergency service by service id-----------------------------------*/
    @GET(API_EDIT_EMERGENCY_SERVICE)
    Single<Response<ServicesResponseBody>> editServiceByServiceId(@Path(COUNTRY_PATH) String countryCode,
                                                                  @Path(LOCALE_PHAT) String locale,
                                                                  @Path("service_id") long currentServiceId,
                                                                  @Body HashMap<String, Integer> newServiceId);

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

    /*-----------------------------GET consultant categories----------------------------------*/
    @GET(GET_CONSULTANT_CATEGORIES)
    Single<Response<HashMap<Integer, String>>> getConsultantCategories(@Path(COUNTRY_PATH) String countryCode,
                                                                       @Path(LOCALE_PHAT) String language);
}

