<?php
/**
 * Created by PhpStorm.
 * User: User-PC
 * Date: 8/20/2019
 * Time: 7:18 PM
 */

namespace App\Helpers;

use Exception;
use Illuminate\Support\Carbon;
use App\Models\Sms;
use App\Services\Sms\SmsGatewayManager;
use App\Services\Sms\SmsResult;
use Illuminate\Support\Facades\Log;

class SendSMS
{
    const VERIFICATION_MESSAGE = "Verification Code - ";

    private $code = "123456";
    private $type;
    private $countryCode;
    private $short_code;

    public function __construct($countryCode = "arm", $type = 'verify_phone_number')
    {
        $this->type = $type;
        $this->countryCode = $countryCode;
        $this->code = $this->generateCode();
    }

    public function generateCode()
    {
        $code = rand(100000, 999999);
        if (!Sms::where('verifying_otp_code', $code)->exists()) {
            return $code;
        }
        $this->generateCode();
    }

    public static function check($code, $user, $type = 'verify_phone_number')
    {
        if (strlen($code) != 6 || !$user->id) {
            return false;
        }
        $SMS = Sms::where('verifying_otp_code', $code)
            ->where('user_id', $user->id)
            ->where('verifying_type', '<', 3)
            ->where('checked', 0)
            ->where('verifying_type', Sms::TYPE[$type]);
        if ($SMS->exists()) {
            $SMS = $SMS->first();
            $SMS->checked = 1;
            if ($type == 'verify_phone_number') {
                if (Carbon::now()->timestamp - $SMS->verifying_otp_valid_datetime <= 60) {
                    return $SMS->save();
                }
                return ['message' => 'verify_timeout'];
            } elseif ($type == 'forgot_password') {
                if (Carbon::now()->timestamp - $SMS->verifying_otp_valid_datetime <= 1800) {
                    return $SMS->save();
                }
                return ['message' => 'verify_timeout'];
            }
        }
        return ['message' => 'invalid_code'];
    }

    public function send($user, $type = 'verify_phone_number', $message = 'Verification Code - ', $from_user_id = null)
    {
        if ($user && $user->phone) {
            $result = $this->deliver($user->phone, $message);
            if ($result->sent) {
                if (Sms::where('verifying_otp_code', $this->code)->where('phone', $user->phone)
                    ->where('verifying_type', '<', 3)
                    ->where('user_id', $user->id)
                    ->where('checked', 0)
                    ->exists()) {
                    $this->code = $this->generateCode();
                }
                $SMS = new Sms();
                $SMS->verifying_otp_code = $this->code;
                $SMS->verifying_otp_valid_datetime = null;
                $SMS->from_user_id = null;
                $SMS->phone = $user->phone;
                $SMS->user_id = $user->id;
                $SMS->message = $message;
                $SMS->verifying_type = Sms::TYPE[$this->type];
                $SMS->checked = 0;
                $this->recordGatewayResponse($SMS, $result);
                if ($type == 'verify_phone_number') {
                    $SMS->verifying_otp_valid_datetime = Carbon::now()->addMinute()->timestamp;
                    $SMS->message = $message . $this->code;
                }
                if ($type == 'forgot_password') {
                    $SMS->message = 'forgot password request : ' . $message . $this->code;
                    $SMS->verifying_otp_valid_datetime = Carbon::now()->addMinute(20)->timestamp;
                }
                if ($from_user_id) {
                    $SMS->from_user_id = $from_user_id;
                }
                return $SMS->save();
            }
        }
        return false;
    }

    public function sendHelpSMS($phone, $message, $from_user_id, $user_id = null, $lat = null, $lng = null)
    {
        $result = $this->deliver($phone, $message);
        if ($result->sent) {
            $SMS = new Sms();
            $SMS->verifying_otp_code = null;
            $SMS->verifying_otp_valid_datetime = null;
            $SMS->from_user_id = $from_user_id;
            $SMS->phone = $phone;
            $SMS->user_id = $user_id;
            $SMS->verifying_type = 3;
            if ($lat && $lng) {
                $message .= ' <br/>Geolocation : <a href="' . e(MapLink::to($lat, $lng)) . '" target="_blank">click here </a>';
                $SMS->latitude = $lat;
                $SMS->longitude = $lng;
            }
            $SMS->message = $message;
            $SMS->checked = 1;
            $this->recordGatewayResponse($SMS, $result);
            if($SMS->save()){
                $hash = PseudoCrypt::hash((int)($SMS->id . str_replace('+', '',$SMS->phone)), 8);
                $this->short_code = $hash;
                $SMS->uri = $hash;
                return $SMS->save();
            }
        }
        return false;
    }

    private function deliver($phone, $message)
    {
        $nextId = (int) Sms::max('id') + 1;
        $this->short_code = PseudoCrypt::hash((int) ($nextId . str_replace('+', '', $phone)), 8);
        if ($message == self::VERIFICATION_MESSAGE) {
            $message .= $this->code;
        } else {
            $message .= ' ' . env('APP_URL') . "/help/" . $this->countryCode . "/" . $this->short_code;
        }
        try {
            return app(SmsGatewayManager::class)->forCountry($this->countryCode)->send($phone, $message);
        } catch (Exception $exception) {
            Log::error('SMS gateway error: ' . $exception->getMessage() . "\n");

            return SmsResult::failed();
        }
    }

    private function recordGatewayResponse(Sms $SMS, SmsResult $result)
    {
        if ($result->code !== null) {
            $SMS->response_message = $result->description;
            $SMS->response_code = $result->code;
            $SMS->service_sms_id = $result->providerMessageId;
        }
    }
}
