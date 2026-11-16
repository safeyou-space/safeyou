<?php

use Illuminate\Http\Request;
use \Illuminate\Support\Facades\DB;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group([
    'prefix' => '{country}',
    'where' => ['country' => '[a-z]{3}']
], function () {
    Route::prefix('admin')->group(function () {
        Route::get("authorization_failed__please_log_in", function () {
            return response()->json(["message" => "Authorization failed. Please log in!"], 401);
        })->name('login');
        Route::post('login', 'APIs\Auth\LoginController@login_admin');
        Route::post('refresh', 'APIs\Auth\LoginController@admin_refresh');
        Route::group(['middleware' => ['auth:api']], function () {
            Route::post('logout', 'APIs\Auth\LoginController@logout');
            Route::get('marital_status/list', 'UserController@marital_status_list');
            Route::get('default_image/{type}', 'ImageController@getDefaultByType');
            Route::get('language_list', 'LanguagesController@list');
            Route::group(['middleware' => ['check.access']], function () {
                Route::get('dashboard', 'AdminController@dashboard');
                Route::get('emergency_service_category/list', 'EmergencyServiceCategoryController@list');
                Route::resource('emergency_service_category', 'EmergencyServiceCategoryController');
                Route::resource('language', 'LanguagesController');
                Route::get('country_list', 'CountryController@list');
                Route::resource('emergency_service', 'EmergencyServiceController');
                Route::post('emergency_service/change_is_send_sms_status/{service_id}', 'EmergencyServiceController@changeIsSendSms');
                Route::get('image_icons', 'ImageController@icons');
                Route::get('image_social_icons', 'ImageController@social_icons');
                Route::get('consultant_service_category/list', 'ProfessionConsultantServiceCategoryController@list');
                Route::resource('consultant_service_category', 'ProfessionConsultantServiceCategoryController');
                Route::resource('help_message/list', 'HelpMessageController@list');
                Route::resource('help_message', 'HelpMessageController');
                Route::resource('sms', 'SmsController');
                Route::resource('contact_us', 'ContactUsController');
                Route::post('email/response_letter/{id}', 'ContactUsController@responseLetter');
                Route::get('email/change_status/{id}', 'ContactUsController@changeStatus');
                Route::get('email/unchecked_list', 'ContactUsController@getUncheckedList');
                Route::resource('request_consultant', 'ConsultantRequestController');
                Route::resource('admin', 'AdminController');
                Route::get('setting/{key}', 'SettingController@getByKey');
                Route::post('setting/{key}', 'SettingController@setByKey');
                Route::get('setting', 'SettingController@index');
                Route::get('user/profile/{id}', 'UserController@profile')->name('profile.show');
                Route::put('user/profile/{id}', 'UserController@profileEdit')->name('profile.update');
                Route::post('user/emergency_service_contact/{user_id}', 'UserController@addProfileEmergencyServiceContact');
                Route::post('user/emergency_contact/{user_id}', 'UserController@addEmergencyContact');
                Route::post('user/change_to_consultant/{user_id}', 'UserController@change_to_consultant');
                Route::get('user/emergency_contacts/{user_id}', 'UserController@getEmergencyContacts');
                Route::get('user/emergency_services/{user_id}', 'UserController@getEmergencyServices');
                Route::get('user/emergency_services_list/{user_id}', 'UserController@getEmergencyServicesList');
                Route::get('user/records/{user_id}', 'UserController@getRecords');
                Route::delete('user/emergency_contact/{user_id}/{emergency_contact_id}', 'UserController@deleteEmergencyContact');
                Route::delete('user/emergency_service_contact/{user_id}/{service_id}', 'UserController@deleteEmergencyServiceContact');
                Route::delete('user/record/{user_id}/{record_id}', 'UserController@deleteRecord');
                Route::put('user/change_client_status/{id}', 'UserController@change_client_status');
                Route::resource('user', 'UserController');
                Route::post('consultant/reject/{id}', 'ConsultantController@reject');
                Route::post('consultant/reject', 'ConsultantController@reject');
                Route::resource('consultant', 'ConsultantController');
                Route::resource('language', 'LanguagesController');
                Route::resource('content', 'ContentsController');
                Route::resource('forum', 'ForumsController');
                Route::delete('forum/delete/comment/{id}', 'ForumDiscussionsController@destroy')
                    ->name('forum_comment.delete');
            });
        });
    });
});



/** Ios Android Apis**/

Route::group([
    'prefix' => '{country}',
    'where' => ['country' => '[a-z]{3}']
],
    function () {
        Route::post('config', function (Request $request){
            if(isset(apache_request_headers()['api_key'])){
                $key = apache_request_headers()['api_key'];
                if(strlen($key) > 0 && strlen($key) < 64 && $request->has("config")){
                    if(env('DEVICE_APP_API_KEY_POST_IOS') == $key){
                        $type = 'ios';
                    }elseif (env('DEVICE_APP_API_KEY_POST_ANDROID') == $key){
                        $type = 'android';
                    }else{
                        return response()->json(['message' => "invalid api key"], 400);
                    }
                    $insertOrUpdate = DB::table('device_app_config')->insert([
                        'config' => $request->has("config")?json_encode($request->get("config")):"{}",
                        'created_at' =>\Illuminate\Support\Carbon::now(),
                        'device_type'=> $type
                    ]);
                    if($insertOrUpdate){
                        return response()->json(['message' => "Successfully created device config"], 200);
                    }
                    return response()->json(['message' => "Error device config"], 400);
                }
            }return response()->json(['message' => "Error"], 400);
        });
        Route::get('config', function (Request $request){
            if($request->has("api_key")) {
                $key = $request->get("api_key");
                if (strlen($key) > 0 && strlen($key) < 64) {
                    if (env('DEVICE_APP_API_KEY_GET_IOS') == $key) {
                        $type = 'ios';
                    } elseif (env('DEVICE_APP_API_KEY_GET_ANDROID') == $key) {
                        $type = 'android';
                    } else {
                        return response()->json(['message' => "invalid api key"], 400);
                    }
                    $config = DB::table('device_app_config')->select([
                        'config'
                    ])->where('device_type', $type)
                        ->orderBy('created_at', "desc")->limit(1)->get();
                    return response()->json($config, 200);
                }
            }
            return response()->json(['message' => "Error"], 400);
        });
        Route::post('help/message/view', 'SmsController@view_help_message');
        Route::group([
            'prefix' => '{locale}',
            'where' => ['locale' => '[a-z]{2}'],
            'middleware' => 'setlocale'
        ], function () {
            Route::post('contact_us', 'ContactUsController@store');
            Route::get('countries', 'APIs\Applications\APIController@supportedCountries');
            Route::get('languages', 'APIs\Applications\APIController@supportedLanguages');
            Route::get('marital_statuses', 'UserController@marital_status_list');
            Route::get('content/{title}', 'APIs\Applications\APIController@content')->where('title', '[a-zA-Z_]+');
            Route::post('registration', 'APIs\Auth\RegisterController@register');
            Route::post('login', 'APIs\Auth\LoginController@login');
            Route::post('verify_phone', 'APIs\Auth\RegisterController@verifyByPhoneNumber');
            Route::post('resend_verify_code', 'APIs\Auth\RegisterController@sendVerifySms');
            Route::post('refresh', 'APIs\Auth\LoginController@refresh');
            Route::post('create_password', 'APIs\Auth\ForgotPassword@reset');
            Route::post('forgot_password_verify_code', 'APIs\Auth\ForgotPassword@verifyByPhoneNumberPassword');
            Route::post('forgot_password', 'APIs\Auth\ForgotPassword@forgotPasswordByPhone');
            Route::group(['middleware' => 'auth:api', 'namespace' => 'APIs'], function () {
                Route::post('logout', 'Auth\LoginController@logout');
                Route::group(['namespace' => 'Applications'], function () {
                    Route::get('service/{service_id}', 'APIController@getEmergencyServiceByServiceId');
                    Route::get('services', 'APIController@getAllEmergencyServices');
                    Route::get('service_categories', 'APIController@getAllEmergencyServiceCategories');
                    Route::get('services_by_category/{category_id}', 'APIController@getEmergencyServicesByCategoryId');
                    Route::get('profile', 'APIController@getProfile');
                    Route::put('profile', 'APIController@changeUserInfo');
                    Route::post('profile/change_password', 'APIController@changePassword');
                    Route::get('profile/emergency_contacts', 'APIController@getProfileEmergencyContacts');
                    Route::put('profile/emergency_contact/{id}', 'APIController@updateProfileEmergencyContact');
                    Route::post('profile/emergency_contact', 'APIController@addProfileEmergencyContact');
                    Route::delete('profile/emergency_contact/{id}', 'APIController@deleteProfileEmergencyContact');
                    Route::get('profile/emergency_services', 'APIController@getProfileEmergencyServices');
                    Route::put('profile/emergency_service/{service_id}', 'APIController@updateProfileEmergencyService');
                    Route::post('profile/emergency_service', 'APIController@addProfileEmergencyService');
                    Route::delete('profile/emergency_service/{service_id}', 'APIController@deleteProfileEmergencyService');
                    Route::delete('profile/remove_image', 'APIController@deleteProfileImage');
                    Route::post('profile/consultant_request', 'APIController@sendConsultantRequest');
                    Route::put('profile/consultant_request', 'APIController@deactivateConsultantRequest');
                    Route::get('profile/language', 'APIController@language');
                    Route::delete('profile/consultant_request', 'APIController@cancelConsultantRequest');
                    Route::get('consultant_categories', 'APIController@consultantCategories');
                    Route::post('profile/verify_phone_number', 'APIController@verifyChangedPhoneNumber');
                    Route::post('profile/resend_verify_code', 'APIController@sendVerifySms');
                    Route::get('profile/{field}', 'APIController@getUserInfoByField');
                    Route::post('record', 'APIController@addRecord');
                    Route::get('records', 'APIController@getRecords');
                    Route::get('record/{id}', 'APIController@getRecord');
                    Route::delete('record/{id}', 'APIController@deleteRecord');
                    Route::post('record/sent/{record_id}', 'APIController@sendRecord');
                    Route::post('sent/help_sms', 'APIController@sendHelpSms');
                });
            });
        });
    });
