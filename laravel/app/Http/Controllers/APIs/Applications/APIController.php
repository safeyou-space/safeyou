<?php

namespace App\Http\Controllers\APIs\Applications;

use App\Helpers\FileLib;
use App\Helpers\PseudoCrypt;
use App\Helpers\SendSMS;
use App\Mail\SendEmail;
use App\Models\ConsultantRequest;
use App\Models\Contents;
use App\Models\Country;
use App\Models\EmergencyService;
use App\Models\EmergencyServiceCategory;
use App\Models\Image;
use App\Models\Languages;
use App\Models\ProfessionConsultantServiceCategory;
use App\Models\Setting;
use App\Models\Sms;
use App\Models\UserEmergencyContacts;
use App\Models\UserEmergencyServiceContacts;
use App\Models\UserRecords;
use App\User;
use Illuminate\Support\Facades\App;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Validator;

class APIController extends Controller
{
    public function content(Request $request, $country_code, $language_code, $title)
    {
        $query = Contents::with(['translations'=>function($q)use($language_code){
            $q->whereHas('language',function($q) use($language_code){
                $q->where('code', $language_code);
            });
        }])->where('title', $title);

        if ($query->exists()) {
            $data = $query->first();
            return response()->json(['title'=>$data->title, 'content'=>$data->translations[0]->content], 200);
        }
        return response()->json(['message' => __("messages.content_not_found")], 200);
    }
    /** all supported countries by location and country **/
    public function supportedCountries(Request $request, $country_code, $language_code){
        Config(['database.default'=> 'mysql_arm']);
        $query = Country::with('image')->where('status', 1);
        if($query->exists()){
            return response($query->get(), 200);
        }
        return response()->json(['message'=>__('messages.invalid_request')], 404);
    }
    public function supportedLanguages(Request $request, $country_code, $language_code){
        $query = Languages::with('image')->where('status', 1);
        if($query->exists()){
            return response($query->get(), 200);
        }
        return response()->json(['message'=>__('messages.invalid_request')], 404);
    }

    public function language(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $language = Languages::where('code', $languageCode)->where('status', 1);
        if($language->exists()){
            $language = $language->first();
            $query = $query->first();
            if($query->language_id != $language->id){
                $query->language_id = $language->id;
               if(!$query->save()){
                   return response()->json(['message' => __('messages.something_error')], 400);
               }
            }
            return response()->json(['message' => __("messages.successful_changed_field")], 201);
        }
        return response()->json(['message'=>__('messages.invalid_request')], 400);
    }

    public function getAllEmergencyServices(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = EmergencyService::whereHas('user_detail', function ($query)use($request){
            $query->where('is_admin', 0);
            $query->where('is_super_admin', 0);
            $query->where('role', 3);
            $query->where('status', 1);
        });
        if($request->has('is_send_sms') && $request->get('is_send_sms') == "true"){
            $query->where('is_send_sms', 1);
        }
        $query->with(['user_detail'=>function($q){
            $q->with('image');
        }])->whereHas('category', function ($q){
            $q->where('status', 1);
        })->whereHas('user_detail', function ($q){
            $q->where('status', 1);
        })->where('status', 1);
        $query->orderBy('created_at', 'desc');
        if($request->has('search_string') && strlen($request->get('search_string')) > 0){
            $SearchString = $request->get('search_string');
            if($SearchString){
                $query->Like(['title'],$SearchString);
            }
            if ($query->exists()) {
                $query = $query->get();
                $response = collect();
                $query->each(function ($i) use ($response){
                    $response->push(['id'=>$i->id, 'name' => $i->title,
                        'category'=>$i->category_translation , 'category_id'=>$i->emergency_service_category_id]);
                });
                return response()->json($response, 200);
            }
            return response()->json(['message' => __("messages.content_not_found")], 202);
        }else{
            $query->with(['user_service'=>function($q)use($user_id){
                $q->where('user_id', $user_id);
            }
            ]);
        }
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => __("messages.content_not_found")], 202);
    }
    public function getAllEmergencyServiceCategories(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = EmergencyService::whereHas('user_detail', function ($query)use($request){
            $query->where('is_admin', 0);
            $query->where('is_super_admin', 0);
            $query->where('role', 3);
            $query->where('status', 1);
        });
        if($request->has('is_send_sms')){
            if($request->get('is_send_sms') == 'true'){
                $query->where('is_send_sms', 1);
            }
        }
        $query->with(['user_detail'=>function($q){
            $q->with('image');
        }])->whereHas('category', function ($q){
            $q->where('status', 1);
        })->whereHas('user_detail', function ($q){
            $q->where('status', 1);
        })->where('status', 1);
        $query->orderBy('created_at', 'desc');
        if ($query->exists()) {
            $query = $query->get();
            $response = collect();
            $query->each(function ($i) use ($response){
                $response->put($i->emergency_service_category_id,$i->category_translation);
            });
            return response()->json($response, 200);
        }
        return response()->json(['message' => __("messages.content_not_found")], 202);
    }
    public function getEmergencyServicesByCategoryId(Request $request, $countryCode, $languageCode,  $categoryId){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $category = EmergencyServiceCategory::where('id', $categoryId)->where('status', 1);
        if(!$category->exists()){
            return response()->json(['message'=>__('messages.invalid_request')], 404);
        }
        $query = EmergencyService::with(['user_detail'=>function($q){
            $q->with('image');
        }])->whereHas('user_detail', function ($q){
            $q->where('status', 1);
            $q->where('role', 3);
        })->where('emergency_service_category_id', $categoryId);
        if($request->has('is_send_sms')){
            if($request->get('is_send_sms') == 'true'){
                $query->where('is_send_sms', 1);
            }
        }
        $query->orderBy('created_at', 'desc');
        if($request->has('search_string') && strlen($request->get('search_string')) > 0){
            $SearchString = $request->get('search_string');
            if($SearchString){
                $query->Like(['title'],$SearchString);
            }
            if ($query->exists()) {
                $query = $query->get();
                $response = collect();
                $query->each(function ($i) use ($response){
                    $response->push(['id'=>$i->id, 'name' => $i->title,
                        'category'=>$i->category_translation , 'category_id'=>$i->emergency_service_category_id]);
                });
                return response()->json($response, 200);
            }
            return response()->json(['message' => __("messages.content_not_found")], 202);
        }else{
            $query->with(['user_service'=>function($q)use($user_id){
                $q->where('user_id', $user_id);
            }
            ]);
        }
        if($query->exists()){
            return response()->json($query->get(), 200);
        }return response()->json(['message'=>__('messages.invalid_request')], 404);
    }
    public function getEmergencyServiceByServiceId(Request $request, $countryCode, $languageCode,  $serviceId){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $response = EmergencyService::with(['social_links','user_service'=>function($q)use($user_id){
            $q->where('user_id', $user_id);
        }, 'user_detail'=>function($q){
            $q->with('image');
        }])->whereHas('user_detail', function ($q){
            $q->where('status', 1);
            $q->where('role', 3);
        })->where('id', $serviceId);
        if($response->exists()){
            return response()->json($response->first(), 200);
        }return response()->json(['message'=>__('messages.invalid_request')], 404);
    }
    public function getProfile(Request $request, $countryCode, $languageCode){
        $id = Auth::user()->id;
        $query = User::with('image')->where('id', $id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if (!$query->exists()) {
            $proxy = Request::create('api/' . $countryCode . '/' . $languageCode . '/logout', 'POST', ['Authorization' => "Bearer " . Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message' => __('messages.invalid_request')], 401);
        }
        $query = User::with([
            'image', 'records', 'emergencyContacts',
            'consultant_request'=>function($q){
            $q->with('category');
            },
            'help_message'=>function($q){
                $q->where('status', 1);
                $q->with(['translations'=>function($q){
                    $q->with('language')->whereHas('language', function ($q){
                        $q->where('status', 1);
                    }) ->whereHas('language', function ($q){
                        $q->where('code', App::getLocale());
                    });
                }]);
            }, 'consultant_category'=>function($q){
                $q->where('status', 1);
                $q->with(['translations'=>function($q){
                    $q->with('language')->whereHas('language', function ($q){
                        $q->where('status', 1);
                    })  ->whereHas('language', function ($q){
                        $q->where('code', App::getLocale());
                    });
                }]);
            },
            'emergency_services'=>function($q){
                $q->with(['user_detail'=>function($q){
                    $q->where('role', 3);
                    $q->where('status', 1);
                    $q->with('image');
                }])->where('status', 1);
            }])->where('id', Auth::user()->id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if($query->exists()){
            $data = $query->first();
            $data->country = Country::with('image')->where('short_code', $countryCode)->first();
            return response()->json($data, 200);
        }return response()->json(['message' => __("messages.invalid_request")], 404);
    }
    public function changeUserInfo(Request $request, $countryCode, $languageCode)
    {
        $id = Auth::user()->id;
        $query = User::with('image')->where('id', $id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if (!$query->exists()) {
            $proxy = Request::create('api/' . $countryCode . '/' . $languageCode . '/logout', 'POST', ['Authorization' => "Bearer " . Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message' => __('messages.invalid_request')], 401);
        }
        $query = $query->first();
        $field = $request->get('field_name');
        $rule = 'required';
        switch ($field) {
            case 'first_name':
                $rule .= '|min:3';
                $query->first_name = $request->get('field_value');
                break;
            case 'device_token':
                $rule = 'nullable|min:12|max:255';
                if($request->get('field_value') == ''){
                    $query->device_token = null;
                }else{
                    $query->device_token = $request->get('field_value');
                }
                break;
            case 'last_name':
                $rule .= '|min:3';
                $query->last_name = $request->get('field_value');
                break;
            case 'nickname':
                if($request->get('field_value') !=''){
                    if (User::where('id', '!=', $id)->where($field, $request->get('field_value'))->exists()) {
                        return response()->json(['message' => __("messages.".$field."_already_taken")], 400);
                    }
                    $rule = 'min:2';
                    $query->nickname = $request->get('field_value');
                }else{
                    $rule = '';
                    $query->nickname = null;
                }
                break;
            case 'email':
                if($request->get('field_value') != ''){
                    if(!filter_var($request->get('email'), FILTER_VALIDATE_EMAIL)){
                        return response()->json(['message' => ["Invalid email address"]], 400);
                    }
                    if (User::where('id', '!=', $id)->where($field, $request->get('field_value'))->exists()) {
                        return response()->json(['message' => __("messages.".$field."_already_taken")], 400);
                    }
                    $query->email = $request->get('field_value');
                }
                $rule = '';
                $query->email = null;
                break;
            case 'marital_status':
                $rule .= '|nullable|numeric|in:1,0,-1';
                $query->marital_status = $request->has('field_value') ? $request->get('field_value') : -1;
                break;
            case 'phone':
                if (User::where('id', '!=', $id)->where($field, $request->get('field_value'))->exists()) {
                    return response()->json(['message' => __("messages.".$field."_already_taken")], 400);
                }
                if(User::where('id', $id)->where($field, $request->get('field_value'))->exists()){
                    return response()->json(['message' => __("messages.".$field."_already_taken")], 400);
                }
                $rule .= '|min:9|max:13';
                $query->change_phone = $request->get('field_value');
                break;
            case 'help_message':
                $rule .= 'integer|exists:help_messages.id';
                $query->help_messages_id = $request->get('field_value');
                break;
            case 'check_police':
                $rule .= '|numeric|in:1,0';
                $query->check_police = $request->get('field_value');
                break;
            case 'birthday':
                $rule .= '|date_format:d/m/Y';
                $query->birthday = $request->get('field_value');
                break;
            case 'location':
                $rule = 'nullable|max:150';
                $query->location = $request->get('field_value');
                break;
            case 'image':
                $rule .= '|mimes:jpeg,bmp,png,gif|max:5120';
                break;
            default :
                return response()->json(['message' => __("messages.invalid_request")], 404);
                break;
        }
        if($field == 'image'){
            $validator = validator($request->all(), [ 'field_value' => $rule ]);
        }else{
            $validator = validator([$field =>$request->get('field_value')], [ $field => $rule ]);
        }
        if($validator->fails()){
            return response()->json(['message'=>__('messages.invalid_request')], 400);
        }
        if($request->get('field_name') == 'image'){
            if(request()->hasFile('field_value')){
                $img_id = null;
                if($query->image_id != 3 && $query->image_id != 11){
                    $img_id = $query->image_id;
                }
                $image_id = FileLib::uploadImage($request->file('field_value'), 'user_profile', $img_id);
                if(!$image_id){
                    return response()->json(['message'=>__('messages.invalid_request')], 400);
                }$query->image_id = $image_id;
            }else{
                return response()->json(['message' => __("messages.invalid_request")], 404);
            }
        }
        if($query->save()){
            if($request->get('field_name') == 'phone'){
                $query->phone = $query->change_phone;
                $sms = new SendSMS($countryCode, 'verify_phone_number');
                $sms ->send($query, 'verify_phone_number');
                return response()->json(['message' => __("messages.verify_phone")], 202);
            }
            try {
                // refresh profile info
                file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($countryCode)), $id, env('APP_SOCKET_SECRET_KEY')));
            } catch (\Exception $ex) { }
            return response()->json(['message' => __("messages.successful_changed_field")], 201);
        }return response()->json(['message' => __("messages.invalid_request")], 404);
    }

    public function verifyChangedPhoneNumber(Request $request, $countryCode, $languageCode){
        if($request->has('phone') && $request->has('code')){
            $validator = validator($request->all(), [
                'phone' => 'required|min:9|exists:users,change_phone',
                'code' => 'required|min:6|exists:sms,verifying_otp_code'
            ]);
            if($validator->fails()){
                return response()->json(['message'=>__('messages.invalid_code')], 400);
            }
            $check_user = User::where('phone', $request->get('phone'));
            if($check_user->exists()){
                return response()->json(['message'=>__('messages.phone_already_taken')], 400);
            }
            $user = User::where('change_phone', $request->get('phone'))
                ->where('is_verifying_otp', 1)
                ->where('id', Auth::user()->id)
                ->where('status', 1);
            $code = $request->get('code');
            if($user->exists()){
                $user = $user->first();
                $check = SendSMS::check($code,$user, 'verify_phone_number');
                if($check === true || $check === 1){
                    $user->phone = $request->get('phone');
                    $user->change_phone = NULL;
                    if($user->save()){
                        return response()->json(['message'=>__('messages.verify_success')], 200);
                    }
                }elseif($check === false || $check === 0){
                    return response()->json(['message'=>__('messages.server_error')], 502);
                }
                elseif(is_array($check) && array_key_exists('message', $check)){
                    if($check['message'] === "verify_timeout"){
                        return response()->json(['message'=>__('messages.verify_timeout')], 202);
                    }
                    if($check['message'] === "invalid_code"){
                        return response()->json(['message'=>__('messages.server_error')], 400);
                    }

                }else{
                    return response()->json(['message'=>__('messages.server_error')], 502);
                }
            }
            return response()->json(['message'=>__('messages.invalid_phone_number')], 400);
        }return response()->json(['message'=>__('messages.invalid_request')], 404);
    }

    public function sendVerifySms(Request $request, $countryCode, $languageCode){
        if($request->has('phone')){
            $validator = validator($request->all(), [
                'phone' => 'required|phone|min:9|max:13|exists:users,change_phone'
            ]);
            if($validator->fails()){
                return response()->json(['message'=>__('messages.invalid_phone_number')], 400);
            }
            $check_user = User::where('phone', $request->get('phone'));
            if($check_user->exists()){
                return response()->json(['message'=>__('messages.phone_already_taken')], 400);
            }
            $user = User::where('change_phone', $request->get('phone'));
            if($user->exists()){
                $user = $user->first();
                $user->phone = $request->get('phone');
                $SMS = new SendSMS($countryCode,'verify_phone_number');
                if($SMS->send($user, 'verify_phone_number')){
                    return response()->json(['message'=>__('messages.verify_phone')], 201);
                }
            }return response()->json(['message'=>__('messages.invalid_phone_number')], 400);
        }
    }
    public function changePassword(Request $request, $countryCode, $languageCode)
    {
        $id = Auth::user()->id;
        $user = User::with('image')->where('id', $id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if (!$user->exists()) {
            $proxy = Request::create('api/' . $countryCode . '/' . $languageCode . '/logout', 'POST', ['Authorization' => "Bearer " . Request()->bearerToken()]);
            Route::dispatch($user);
            return response()->json(['message' => __('messages.invalid_request')], 401);
        }
        $validator = Validator::make($request->all(), [
            'old_password' => 'required|min:8',
            'password' => 'required|min:8',
            'confirm_password' => 'required|min:8|same:password',
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $user = $user->first();
        if (Hash::check($request->get('old_password'), $user->password, [])) {
            if($user->is_verifying_otp != 1){
                return response()->json(['message' => __("messages.is_not_verify_phone")], 403);
            }
            if($user->status != 1){
                return response()->json(['message' => __("messages.inactive_user")], 403);
            }
            $user->password = bcrypt($request->get('password'));
            if($user->save()){
                return response()->json(['message' => __("messages.change_password_success")], 201);
            }return response()->json(['message' => __("messages.invalid_request")], 404);
        }
        return response()->json(['message' => __("messages.incorrect_old_password")], 400);
    }
    public function getProfileEmergencyContacts(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = UserEmergencyContacts::where('user_id', $user_id);
        if($query->exists()){
            return response()->json($query->get(), 200);
        }
        return response()->json(['message'=>__('messages.content_not_found')], 202);
    }
    public function addProfileEmergencyContact(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        if(UserEmergencyContacts::where('user_id', $user_id)->count() == 3){
            return response()->json(['message'=>__('messages.limited_emergence_contacts')], 400);
        }
        $validator = Validator::make($request->all(), [
            "name" => "required|min:1|max:150",
            "phone" => "required|phone|min:9|max:13",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = UserEmergencyContacts::where('user_id', $user_id)
            ->where('name', $request->get('name'))
            ->where('phone', $request->get('phone'));
        if(!$query->exists()){
            if(UserEmergencyContacts::where('user_id', $user_id)->count() >= 3){
                return response()->json(['message' => __("messages.limited_emergence_contacts")], 400);
            }
            $query = new UserEmergencyContacts();
            $query->user_id = $user_id;
            $query->name = $request->get('name');
            $query->phone = $request->get('phone');
            if($query->save()){
                return response()->json(['message' => __("messages.successfully_added")], 200);
            }
        } return response()->json(['message'=>__('messages.already_added')], 400);
    }
    public function updateProfileEmergencyContact(Request $request,  $countryCode, $languageCode, $id){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $validator = Validator::make($request->all(), [
            "name" => "required|min:1|max:150",
            "phone" => "required|phone|min:9|max:13",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = UserEmergencyContacts::where('user_id', $user_id)
            ->where('id', '!=', $id)
            ->where('name', $request->get('name'))
            ->where('phone', $request->get('phone'));
        if(!$query->exists()){
            $query = UserEmergencyContacts::where('id', $id)->where('user_id', $user_id)->first();
            $query ->name = $request->get('name');
            $query ->phone = $request->get('phone');
            if($query->save()){
                return response()->json(['message' => __("messages.successfully_updated")], 200);
            }
        } return response()->json(['message'=>__('messages.already_added')], 400);
    }
    public function deleteProfileEmergencyContact(Request $request, $countryCode, $languageCode, $id){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = UserEmergencyContacts::where('user_id', $user_id)
            ->where('id', $id);
        if($query->exists()){
            if($query->delete()){
                return response()->json(['message' => __("messages.successfully_deleted")], 200);
            }
        } return response()->json(['message' =>__('messages.invalid_request')], 400);
    }
    public function getProfileEmergencyServices(Request $request, $countryCode, $languageCode)
    {
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = User::with(['emergency_services' => function ($q) {
            $q->with('category');
            $q->whereHas('category', function ($q) {
                $q->where('status', 1);
            });
            $q->whereHas('user_detail', function ($q) {
                $q->where('status', 1)
                    ->where('is_admin', 0)
                    ->where('is_super_admin', 0)
                    ->where('role', 3);
            })->where('status', 1);
        }
        ])->where('id', Auth::user()->id);
        if ($query->exists()) {
            $data = collect();
            $query->first()->emergency_services->each(function ($i) use ($data) {
                $data->push([
                    'user_emergency_service_id' => $i->user_emergency_service_id,
                    'service_id' => $i->id,
                    'category' => $i->category_translation,
                    'title' => $i->title,
                ]);
            });
            if($data->isNotEmpty()){
                return response()->json($data, 200);
            }
            return response()->json(['message' => __('messages.content_not_found')], 202);
        }
    }
    public function updateProfileEmergencyService(Request $request, $countryCode, $languageCode, $service_id){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $validator = Validator::make($request->all(), [
            "emergency_service_id" => "required|numeric|exists:emergency_services,id",
        ]);
        if ($validator->fails()) {
            return response()->json(['message'=>__('messages.invalid_request')], 400);
        }
        $emergency_service_id = $request->get('emergency_service_id');
        $emergency_service_category_id = EmergencyService::where('id', $request->get('emergency_service_id'))
            ->value('emergency_service_category_id');
        $query = EmergencyService::where('id', $request->get('emergency_service_id'))
            ->where('status', 1)->where('is_send_sms', 1);
        if(!$query->exists()){
            return response()->json(['message'=>__('messages.invalid_request')], 400);
        }
        $query = UserEmergencyServiceContacts::where('user_id', $user_id)
            ->where('id', $service_id)
            ->where('emergency_service_id', $emergency_service_id)
            ->where('emergency_service_category_id', $emergency_service_category_id);
        if(!$query->exists()){
            $query = UserEmergencyServiceContacts::where('user_id', $user_id)
                ->where('id',  $service_id);
            if($query->exists()){
                $query = $query ->first();
                $query ->emergency_service_id = $emergency_service_id;
                $query ->emergency_service_category_id = $emergency_service_category_id;
                $query ->user_id = $user_id;
                if($query->save()){
                    return response()->json(['message' => __("messages.successfully_updated")], 200);
                }
            } return response()->json(['message'=>__('messages.invalid_request')], 400);
        } return response()->json(['message'=>__('messages.already_added')], 400);
    }
    public function addProfileEmergencyService(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $s_c_count = UserEmergencyServiceContacts::where('user_id', $user_id)
            ->count();
        if($s_c_count == 3){
            return response()->json(['message'=>__('messages.limited_emergence_service_contacts')], 400);
        }
        $validator = Validator::make($request->all(), [
            "emergency_service_id" => "required|numeric|exists:emergency_services,id",
        ]);
        if ($validator->fails()) {
            return response()->json(['message'=>__('messages.invalid_request')], 400);
        }
        $emergency_service_id = $request->get('emergency_service_id');
        $emergency_service_category_id = EmergencyService::where('id', $request->get('emergency_service_id'))->where('is_send_sms', 1)
            ->value('emergency_service_category_id');
        $query = EmergencyService::where('id', $request->get('emergency_service_id'))
            ->where('status', 1);
        if(!$query->exists()){
            return response()->json(['message'=>__('messages.invalid_request')], 400);
        }
        $query = UserEmergencyServiceContacts::where('user_id', $user_id)
            ->where('emergency_service_id', $emergency_service_id)
            ->where('emergency_service_category_id', $emergency_service_category_id);
        if($query->exists()){
            return response()->json(['message'=>__('messages.already_added')], 400);
        }
        $query = new UserEmergencyServiceContacts();
        $query ->emergency_service_id = $emergency_service_id;
        $query ->emergency_service_category_id = $emergency_service_category_id;
        $query ->user_id = $user_id;
        if($query->save()){
            return response()->json(['message' => __("messages.successfully_added")], 200);
        }return response()->json(['message'=>__('messages.invalid_request')], 400);
    }
    public function deleteProfileEmergencyService(Request $request, $countryCode, $languageCode, $service_id){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = UserEmergencyServiceContacts::where('user_id', $user_id)
            ->where('id', $service_id);
        if($query->exists()){
            if($query->delete()){
                return response()->json(['message' => __("messages.successfully_deleted")], 200);
            }
        } return response()->json(['message'=>__('messages.invalid_request')], 400);
    }
    public function deleteProfileImage(Request $request,  $countryCode, $languageCode)
    {
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $user = $query->first();
        if( $user->image_id >12){
            if(FileLib::deleteImage($user->image_id))
            {
                $user->image_id = 3;
                if($user->is_consultant == 1){
                    $user->image_id = 11;
                }
                if($user->save()){
                    try {
                        // refresh profile info
                        file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($countryCode)), $user_id, env('APP_SOCKET_SECRET_KEY')));
                    } catch (\Exception $ex) { }
                    return response()->json(['message' => __("messages.successfully_deleted")], 200);
                }
            }
        }  return response()->json(['message' => __("messages.invalid_request")], 400);
    }
    public function getUserInfoByField(Request $request, $countryCode, $languageCode, $field)
    {
        $user_id = Auth::user()->id;
        $query = User::with('image')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        switch ($field) {
            case 'first_name':
                break;
            case 'last_name':
                break;
            case 'nickname':
                break;
            case 'email':
                break;
            case 'marital_status':
                break;
            case 'phone':
                break;
            case 'emergency_message':
                break;
            case 'check_police':
                break;
            case 'birthday':
                break;
            case 'location':
                break;
            case 'image':
                break;
            default :
                return response()->json(['message' => __("messages.invalid_request")], 404);
                break;
        }
        if($field == 'image'){
            return response()->json([$field=>Image::where('id',$query->value('image_id'))->value('url')], 200);
        }
        $data = $query->value($field);
        return response()->json([$field=>$data], 200);
        return response()->json(['message' => __("messages.content_not_found")], 202);
    }
    public function addRecord(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::with('image')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $validator = Validator::make($request->all(), [
            "name" => "required|min:9|max:150",
            "location" => "required|max:250",
            "latitude" => "required|max:250",
            "longitude" => "required|max:250",
            "duration" => "required|integer|max:250",
            "date" => "required|date_format:Y-m-d",
            "time" => "required|date_format:H:i:s",
        ]);
        if ($validator->fails()) {
            return response()->json(['message'=>__('messages.invalid_request')], 422);
        }
        if($request->hasFile('audio')) {
            $query = UserRecords::where('user_id', $user_id)
                ->where('name', $request->get('name'));
            if (!$query->exists()) {
                $file = FileLib::UploadAudioFile($request->file('audio'));
                if ($file) {
                    $query = new UserRecords();
                    $query->name = $request->get('name');
                    $query->location = $request->get('location');
                    $query->date = $request->get('date');
                    $query->time = $request->get('time');
                    $query->latitude = $request->get('latitude');
                    $query->longitude = $request->get('longitude');
                    $query->is_sent = 0;
                    $query->user_id = $user_id;
                    $query->duration = $request->get('duration');
                    $query->url = $file;
                    if ($query->save()) {
                        if ($request->has('send') && $request->get('send') == 'true') {
                            $user_id = Auth::user()->id;
                            $file = $query->value('url');
                            $emails = collect();
                            EmergencyService::with(['user_service', 'user_detail' => function ($q) {
                            }])->whereHas('user_service', function ($q) use ($user_id) {
                                $q->where('user_id', $user_id);
                            })->whereHas("user_detail", function ($q) {
                                $q->where('status', 1);
                            })->where('status', 1)
                                ->where('is_send_sms', 1)
                                ->get()->each(function ($item) use ($emails) {
                                    $emails->push($item->user_detail->email);
                                });
                            $emails = $emails->toArray();
                            if ($emails) {
                                $query = UserRecords::where('user_id', $user_id)
                                    ->where('id', $query->id)->first();
                                $query->is_sent = 1;
                                $query->save();
                                $user = User::with('help_message')->where('id', $user_id)->first();
                                $user->lng = $request->get('longitude');
                                $user->lat = $request->get('latitude');
                                Mail::to($emails)->send(new SendEmail($user, $emails, $file));
                                return response()->json(['message' => __("messages.successfully_added") .
                                    ' ' . __('messages.successfully_sent')], 200);
                            }
                            return response()->json(['message' => __("messages.successfully_added") . ' '
                                . __('messages.not_found_joined_service_contact')], 201);
                        }
                    }
                    return response()->json(['message' => __("messages.successfully_added")], 200);
                }
                return response()->json(['message' => __('messages.invalid_request')], 400);
            }
            return response()->json(['message' => __('messages.already_added')], 400);
        }return response()->json(['message'=>__('messages.invalid_request')], 400);
    }
    public function getRecords(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::with('image')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = UserRecords::where('user_id', $user_id);
        if($request->has('sent')){
            if($request->get('sent') == 'true'){
                $query = $query ->where('is_sent', 1);
            }
            if($request->get('sent') == 'false'){
                $query = $query ->where('is_sent', 0);
            }
        }
        if($request->has('search_string') && strlen($request->get('search_string')) > 0){
            $query->like(['name', 'location', 'date', 'time'], $request->get('search_string'));
//                $data = $query->pluck('location', 'id');
//                $query->orLike('location', $request->get('search_string'));
            $data = $query->selectRaw('id, CONCAT(location, " date: ", date, "  time: ", time) AS location_with_date_time')
                ->get('location_with_date_time', 'id');
            return response()->json($data, 200);
        }
        if($query->exists()){
            return response()->json($query->orderBy('id', 'DESC')->get(), 200);
        }return response()->json(['message'=>__('messages.content_not_found')], 202);
    }
    public function deleteRecord(Request $request, $countryCode, $languageCode, $record_id){
        $user_id = Auth::user()->id;
        $query = User::with('image')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = UserRecords::where('user_id', $user_id)->where('id',$record_id);
        if($query->exists()){
            $query = $query->first();
            $path = $query->url;
            if(FileLib::deleteAudio($path) && $query->delete()){
                return response()->json(['message'=>__('messages.successfully_deleted')], 200);
            }
        }return response()->json(['message'=>__('messages.invalid_request')], 404);
    }
    public function getRecord(Request $request, $countryCode, $languageCode, $record_id){
        $user_id = Auth::user()->id;
        $query = User::with('image')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $query = UserRecords::where('user_id', $user_id)->where('id',$record_id);
        if($query->exists()){
            return response()->json($query->first(), 200);
        }return response()->json(['message'=>__('messages.invalid_request')], 404);
    }
    public function sendRecord(Request $request, $countryCode, $languageCode, $record_id){
        $user_id = Auth::user()->id;
        $user = User::with('help_message')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$user->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        /***send mail***/
        $validator = Validator::make($request->all(), [
            "latitude" => "required|max:250",
            "longitude" => "required|max:250",
        ]);
        if ($validator->fails()) {
            return response()->json(['message'=>__('messages.invalid_request')], 422);
        }
        $query = UserRecords::where('user_id', $user_id)->where('id',$record_id);
        if($query->exists()){
            $file = $query->value('url');
//                if($user->records()->exists()){
            $emails = collect();
            EmergencyService::with([ 'user_service', 'user_detail'=>function($q){
            }])->whereHas('user_service', function ($q) use($user_id){
                $q->where('user_id', $user_id);
            })->whereHas("user_detail", function ($q){
                $q->where('status', 1);
            })->where('is_send_sms', 1)->get()->each(function($item) use($emails){
                $emails->push($item->user_detail->email);
            });
            $emails = $emails->toArray();
            if($emails){
                $query = UserRecords::where('user_id', $user_id)->where('id',$record_id)->first();
                if($query->is_sent == 0){
                    $query->is_sent = 1;
                    $query->save();
                }
                $user = $user->first();
                $user -> lng = $request->get('longitude');
                $user -> lat = $request->get('latitude');
                Mail::to($emails)->send(new SendEmail($user, $emails, $file));
                return response()->json(['message'=>__('messages.successfully_sent')], 200);
            }
            return response()->json(['message'=>__('messages.not_found_joined_service_contact')], 400);

        }return response()->json(['message'=>__('messages.invalid_request')], 404);
    }
    public function sendHelpSms(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::with('help_message')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $validator = Validator::make($request->all(), [
            "latitude" => "required|max:250",
            "longitude" => "required|max:250",
            "location" => "required|min:1|max:100",
        ]);
        if ($validator->fails()) {
            return response()->json(['message'=>__('messages.invalid_request')], 422);
        }
        $servicePhones = collect();
        $phones = [];
        $policePhones = [];

        if(User::where('id', $user_id)->where('check_police', 1)->where('status', 1)->exists()){
            $policePhoneNumber = Setting::where('key', 'police_phone_number')->where('status', 1);
            if($policePhoneNumber->exists()){
                $policePhones = [$policePhoneNumber->value('value')];
            }
        }

        $emergencyService = EmergencyService::with([ 'user_service', 'user_detail'=>function($q){
        }])->whereHas('user_service', function ($q) use($user_id){
            $q->where('user_id', $user_id);
        })->where('is_send_sms',1)
            ->whereHas("user_detail", function ($q){
                $q->where('status', 1);
            })->where('status', 1);
        $ids = [];
        $servicePhonesArray = [];
        if($emergencyService->exists()){
            $ids = collect();
            $emergencyService->get()
                ->each(function($item) use($servicePhones, $ids){
                    $servicePhones->push($item->user_detail->phone);
                    $ids->push($item->user_id);
                });
            $ids = $ids->toArray();
            $servicePhonesArray = $servicePhones->toArray();
        }
        $emergencyContactPhonesArray = [];
        $emergencyContactPhones = UserEmergencyContacts::where('user_id', $user_id);
        if($emergencyContactPhones->exists()){
            $emergencyContactPhones = $emergencyContactPhones->pluck('phone');
            $emergencyContactPhonesArray = $emergencyContactPhones->toArray();
        }
        $phones = array_merge($servicePhonesArray, $emergencyContactPhonesArray);
        $phones = array_merge($phones, $policePhones);
        if($phones != []){
            $user = $query ->first();
            $user_name = $user->first_name . ' ' . $user->last_name;
            $user_phone = $user->phone;
            $user_emergency_message =  $user->help_message->translation;
            $lat = $request->get('latitude');
            $lng = $request->get('longitude');
            $user_location = $request->get('location');
            $message = $user_name . "\n" . $user_phone . "\n" . $user_emergency_message . "\n" . $user_location;
            if($policePhones!=[]){
                foreach ($policePhones as $k=> $phone){
                    $sms = new SendSMS($countryCode,'help');
                    if(!$sms->sendHelpSMS($phone, $message,$user->id, null, $lat, $lng)){
                        return response()->json(['message'=>"SEND SMS SERVICE ERROR"], 502);
                    }
                }
            }
            if($servicePhonesArray!=[]){
                foreach ($servicePhonesArray as $k=> $phone){
                    $sms = new SendSMS($countryCode,'help');
                    if(!$sms->sendHelpSMS($phone, $message,$user->id, $ids[$k], $lat, $lng)){
                        return response()->json(['message'=>"SEND SMS SERVICE ERROR"], 502);
                    }
                }
            }
            if($emergencyContactPhonesArray){
                foreach ($emergencyContactPhonesArray as $k=> $phone){
                    $sms = new SendSMS($countryCode,'help');
                    if(!$sms->sendHelpSMS($phone, $message,$user->id, null, $lat, $lng)){
                        return response()->json(['message'=>"SEND SMS SERVICE ERROR"], 502);
                    }
                }
            }
            return response()->json(['message'=>__('messages.successfully_sent')], 200);
        }
        return response()->json(['message'=>__('messages.not_found_joined_service_contact')], 400);
    }

    public function deactivateConsultantRequest(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
        $user = User::where('id', $user_id)->where('is_consultant', 1);
        if($user->exists()){
            $req = ConsultantRequest::where('user_id', $user_id);
            if($req->exists()){
                if(!$req->delete()){
                    return response()->json(['message' => __('messages.something_error')], 400);
                }
            }
            $user = $user->first();
            $user->is_consultant = 0;
            $user->role = 5;
            $user->consultant_category_id = null;
            if($user->save()){
                return response()->json(['message'=>__('messages.consultant_request_deactivated')], 201);
            }
        }
        return response()->json(['message' => __('messages.something_error')], 400);
    }

    public function cancelConsultantRequest(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }
            $req = ConsultantRequest::where('user_id', $user_id)->where('status', 0);
            if($req->exists()){
                $req = $req->first();
                if(!$req->delete()){
                    return response()->json(['message' => __('messages.something_error')], 400);
                }
                return response()->json(['message'=>__('messages.consultant_request_canceled')], 201);
            }
        return response()->json(['message' => __('messages.invalid_request')], 400);
    }
    public function sendConsultantRequest(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }

        $validator = Validator::make($request->all(), [
            "message" => "nullable|min:1|max:255",
            "suggested_category" => "nullable|min:1|max:255",
            'email' => 'required|unique:users,email',
            "category_id" => "exists:profession_consultant_service_categories,id",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        if($request->has("category_id")) {
            $category = ProfessionConsultantServiceCategory::where('id', $request->get('category_id'));
            if (!$category->exists() || $category->value('status') == 0) {
                return response()->json(['message' => __('messages.invalid_request')], 404);
            }
        }
        $req = ConsultantRequest::where('user_id', $user_id);
        if($req->exists()) {
            $req->delete();
        }
        if($request->has("suggested_category")){
            $query = new ConsultantRequest();
            $query->message = $request->has("message")?$request->get("message"):null;
            $query->user_id = $user_id;
            $query->email = $request->get("email");
            $query->profession_consultant_service_category_id = null;
            $query->suggested_category = $request->get("suggested_category");
            $query->status = 0;
            if($query->save()){
                return response()->json(['message'=>__('messages.consultant_request_created')], 201);
            }return response()->json(['message' => __('messages.something_error')], 400);
        }
        $query = new ConsultantRequest();
        $query->message = $request->has("message")?$request->get("message"):null;
        $query->user_id = $user_id;
        $query->email = $request->get("email");
        $query->profession_consultant_service_category_id = $request->get("category_id");
        $query->status = 0;
        if($query->save()){
            return response()->json(['message'=>__('messages.consultant_request_created')], 201);
        }return response()->json(['message' => __('messages.something_error')], 400);
    }
    public function consultantCategories(Request $request, $countryCode, $languageCode){
        $user_id = Auth::user()->id;
        $query = User::with('help_message')->where('id', $user_id)
            ->where('status', 1)
            ->whereIn('role', [5,4])
            ->where('is_verifying_otp', 1);
        if(!$query->exists()) {
            $proxy = Request::create('api/'.$countryCode .'/' .$languageCode .'/logout', 'POST', ['Authorization'=>"Bearer ".Request()->bearerToken()]);
            Route::dispatch($proxy);
            return response()->json(['message'=>__('messages.invalid_request')], 401);
        }

        $category = ProfessionConsultantServiceCategory::where('status', 1);
        if($category->exists()){
            return response()->json($category->get()->pluck('translation','id'), 200);
        }return response()->json(['message' => __("messages.content_not_found")], 202);
    }
}
