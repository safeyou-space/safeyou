<?php

namespace App\Http\Controllers\APIs\Auth;

use App\Helpers\SendSMS;
use App\Http\Controllers\Controller;
use App\Models\HelpMessage;
use App\Models\Languages;
use App\Models\Setting;
use App\User;
use Illuminate\Http\Request;
use Laravel\Passport\Client;

class RegisterController extends Controller
{
    use IssueTokenTrait;

    private $client;

    public function __construct()
    {
        $this->client = Client::find(2);
    }

    public function register(Request $request, $countryCode, $languageCode)
    {
        $this->validate($request, [
            'first_name' => 'required|min:3',
            'last_name' => 'required|min:3',
            'nickname' => 'nullable|min:2',
            'marital_status' => 'nullable|numeric|in:1,0,-1',
            'phone' => 'required|phone|min:9|max:13',
            'birthday' => 'required|date_format:d/m/Y',
            'password' => 'required|min:8',
            'confirm_password' => 'required|min:8|same:password',
        ]);
        if($request->has('nickname')){
            if(User::where('nickname', $request->get('nickname'))->exists()){
                return response()->json(['message'=>__('messages.nickname_already_taken')], 400);
            }
        }
        if(User::where('phone', $request->get('phone'))->exists()){
            return response()->json(['message'=>__('messages.phone_already_taken')], 400);
        }
        $user = new User();
        $user->first_name = $request->get('first_name');
        $user->last_name = $request->get('last_name');
        $user->nickname = $request->has('nickname')?$request->get('nickname'):null;
        $user->marital_status = $request->has('marital_status') ? $request->get('marital_status') : -1;
        $user->phone = $request->get('phone');
        $user->image_id = 3;
        $user->role = 5;
        $help_message = Setting::where('key', 'default_help_message')->where('status', 1);
        $user->help_message_id = $help_message->exists()? $help_message->value('value'):
            (HelpMessage::where('status', 1)->exists() ? HelpMessage::where('status', 1)->first()->id:1);
        $user->birthday = $request->get('birthday');
        $user->password = bcrypt($request->get('password'));
        $user->is_verifying_otp = 0;
        $user->status = 0;
        if ($user->save()) {
            $language = Languages::where('code', $languageCode)->where('status', 1);
            if($language->exists()){
                $language = $language->first();
                if( 1 != $language->id){
                    $user->language_id = $language->id;
                    if(!$user->save()){
                        return response()->json(['message' => __('messages.something_error')], 400);
                    }
                }
            }
            $SMS = new SendSMS($countryCode,'verify_phone_number');
            if($SMS->send($user,'verify_phone_number')){
                return response()->json(['message'=>__('messages.registration_success') . __("messages.verify_phone")], 201);
            }
//            return response()->json(['message'=>__('messages.verify_phone')], 400);
        }return response()->json(['message'=>__('messages.registration_error')], 400);
    }

    public function sendVerifySms(Request $request, $countryCode){
        if($request->has('phone')){
            $validator = validator($request->all(), [
                'phone' => 'required|phone|min:9|max:13|exists:users,phone'
            ]);
            if($validator->fails()){
                return response()->json(['message'=>__('messages.invalid_phone_number')], 400);
            }
            $user = User::where('phone', $request->get('phone'));
            if($user->exists()){
                $user = $user->first();
                $SMS = new SendSMS($countryCode,'verify_phone_number');
                if($SMS->send($user, 'verify_phone_number')){
                    return response()->json(['message'=>__('messages.verify_phone')], 201);
                }
            }return response()->json(['message'=>__('messages.invalid_phone_number')], 400);
        }
    }
    public function verifyByPhoneNumber(Request $request){
        if($request->has('phone') && $request->has('code')){
            $validator = validator($request->all(), [
                'phone' => 'required|min:9|exists:users,phone',
                'code' => 'required|min:6|exists:sms,verifying_otp_code'
            ]);
            if($validator->fails()){
                return response()->json(['message'=>__('messages.invalid_code')], 400);
            }
            $user = User::where('phone', $request->get('phone'))
                ->where('is_verifying_otp', 0)//->where('status', 0)
                ->where('status', 0);//->where('status', 0)
            $code = $request->get('code');
            if($user->exists()){
                $user = $user->first();
                $check = SendSMS::check($code,$user, 'verify_phone_number');
                if($check === true || $check === 1){
                    $user->is_verifying_otp = 1;
                    $user->status = 1;
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
}


