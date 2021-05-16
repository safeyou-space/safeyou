<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 22.04.2019
 * Time: 12:57
 */

namespace App\Http\Controllers\APIs\Auth;


use App\Helpers\SendSMS;
use App\Http\Controllers\Controller;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;

class ForgotPassword extends Controller
{


    public function forgotPasswordByPhone(Request $request, $countryCode, $languageCode)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|phone|min:9|max:13|exists:users,phone',
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        try {
            $user = User::where('phone', $request->get('phone'))
                ->where('role','>', 3)
                ->where('is_verifying_otp', 1)
                ->where('status', 1);
            if ($user->exists()) {
                $user = $user->first();
                if($user->is_verifying_otp == 1 && $user->status == 0){
                    return response()->json(['message' => __('messages.inactive_user')], 401);
                }
                if (DB::table('password_resets')->where('phone', $request->get('phone'))->exists()) {
                    DB::table('password_resets')->where('phone', $request->get('phone'))->delete();
                }
                $hash = hash('sha256', mktime(true) . env('HASH_SALT'));
                DB::table('password_resets')->insert(
                    ['phone' => $request->get('phone'), 'token' => $hash,
                        'created_at' => Carbon::now()->addHours(2)->toDateTimeString()]
                );
                $SMS = new SendSMS($countryCode,'forgot_password');
                if($SMS->send($user, 'forgot_password' )){
                    return response()->json(['message'=>__('messages.verify_phone')], 201);
                }return response()->json(['message'=>__('messages.something_error')], 444);
            }
            return response()->json(['message' => __('messages.invalid_phone_number')], 400);

        } catch (\Exception $e) {
            return response()->json(['message' => __('messages.invalid_request')], 404);

        }
    }
    public function verifyByPhoneNumberPassword(Request $request){
        if($request->has('phone') && $request->has('code')){
            $validator = validator($request->all(), [
                'phone' => 'required|phone|min:9|max:13|exists:users,phone|exists:sms,phone',
                'code' => 'required|min:6|exists:sms,verifying_otp_code'
            ]);
            if($validator->fails()){
                return response()->json(['message'=>__('messages.invalid_code')], 400);
            }
            $user = User::where('phone', $request->get('phone'))
                ->where('status', 1)
                ->where('role', '>',3);
            $code = $request->get('code');
            $resetPassword = DB::table('password_resets')->where('phone', $request->get('phone'));
            if($user->exists() && $resetPassword->exists()){
                $user = $user->first();
                if($user->status == 0 && $user->is_verifying_otp == 1){
                    return response()->json(['message'=>__('messages.inactive_user')], 401);
                }
                $check = SendSMS::check($code,$user, 'forgot_password');
                if($check === true || $check === 1) {
                    return response()->json(['message' => __('messages.verify_success'), 'token' => $resetPassword->value('token')], 200);
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


    public function reset(Request $request)
    {
        $access = DB::table('password_resets')
            ->where(['phone' => $request->get('phone'), 'token' => $request->get('token')]);
        if ($access->exists()) {
            $access = $access->first();
            if (Carbon::now()->timestamp - strtotime($access->created_at)  > 7200 ) {
                DB::table('password_resets')->where(
                    ['phone' => $request->get('phone'), 'token' => $request->get('token')]
                )->delete();
                return response()->json(['message' => __('messages.created_password_error_time_out')], 202);
            }
                $validator = Validator::make($request->all(), [
                    'password' => 'required|min:8',
                    'confirm_password' => 'required|min:8|same:password',
                    'token' => 'required|min:64',
                ]);
                if ($validator->fails()) {
                    return response()->json(['message' => $validator->errors()], 422);
                }
                $user = User::where('phone', $request->get('phone'))
                    ->where('status', 1)
                    ->where('role', ">", 3)->first();
                if ($user) {
                    $user->password = bcrypt($request->get('password'));
                    if ($user->save()) {
                        DB::table('password_resets')->where(
                            ['phone' => $request->get('phone'), 'token' => $request->get('token')]
                        )->delete();
                        return response()->json(['message' => __('messages.created_password_success')], 201);
                    }
                }
        }
        return response()->json(['message' => __('messages.invalid_request')], 400);
    }
}
