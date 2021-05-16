<?php
/**
 * Created by PhpStorm.
 * User: User-PC
 * Date: 8/20/2019
 * Time: 7:18 PM
 */

namespace App\Helpers;

use Illuminate\Support\Carbon;
use App\Models\Sms;
use Illuminate\Support\Facades\Log;

class SendSMS
{
    private $georgian_sms_status_codes = [
        0 => "Pending",
        1 => "Was sent to a subscriber",
        2 => "Failed to sent to a subscriber",
        4 => "Status pending",
        8 => "Submitted to the SMS Center",
        16 => "Rejected by SMS Center",
        64 => "Incorrect password or nickname or restricted IP address"
    ];

    private $georgian_send_sms_request_status_codes = [
        "0000" => "Message sent successfully. Second parameter is message unique identifier in the system",
        "0001" => "Invalid password or nickname or restricted IP address",
        "0003" => "Required fields are empty (username, password, client_id, service_id)",
        "0005" => "Blank message body",
        "0007" => "Invalid phone number",
        "0008" => "Insufficient balance",
        "0009" => "Invalid sender ID",
        "0010" => "The message contains banned word",
        "5000" => "Server Error"
    ];
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
            $country = ucfirst($this->countryCode);
            $sendSms = call_user_func_array(
                [$this, "sendMessageRequest" . $country],
                [$user->phone, $message]
            );
            if ($sendSms['status']) {
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
                if ($this->countryCode == 'geo') {
                    $SMS->response_message = $this->georgian_send_sms_request_status_codes[$sendSms['code']];
                    $SMS->response_code = $sendSms['code'];
                    $SMS->service_sms_id = $sendSms['service_sms_id'];
                }
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
        $country = ucfirst($this->countryCode);
        $sendSms = call_user_func_array(
            [$this, "sendMessageRequest" . $country],
            [$phone, $message]
        );
        if ($sendSms['status']) {
            $SMS = new Sms();
            $SMS->verifying_otp_code = null;
            $SMS->verifying_otp_valid_datetime = null;
            $SMS->from_user_id = $from_user_id;
            $SMS->phone = $phone;
            $SMS->user_id = $user_id;
            $SMS->verifying_type = 3;
            if ($lat && $lng) {
                $user_geo_location = "https://www.google.com/maps/search/?api=1&query=" . $lat . "," . $lng;
                $message .= ' <br/>Geolocation : <a href=' . $user_geo_location . ' target="_blank">click here </a>';
                $SMS->latitude = $lat;
                $SMS->longitude = $lng;
            }
            $SMS->message = $message;
            $SMS->checked = 1;
            if ($this->countryCode == 'geo') {
                $SMS->response_message = $this->georgian_send_sms_request_status_codes[$sendSms['code']];
                $SMS->response_code = $sendSms['code'];
                $SMS->service_sms_id = $sendSms['service_sms_id'];
            }
            if($SMS->save()){
                $hash = PseudoCrypt::hash((int)($SMS->id . str_replace('+', '',$SMS->phone)), 8);
                $this->short_code = $hash;
                $SMS->uri = $hash;
                return $SMS->save();
            }
        }
        return false;
    }

    public function sendMessageRequestArm($phone, $message = "Verification Code - ")
    {
        $maxId = Sms::max('id');
        if(!$maxId){
            $maxId = 0;
        }
        $phoneWithoutPlus = str_replace('+', '',$phone);
        $hash = $maxId + 1 .$phoneWithoutPlus;
        $this->short_code = PseudoCrypt::hash((int)$hash, 8);
        $res['code'] = null;
        $res['service_sms_id'] = null;
        $res['status'] = false;
        /*** send sms functionality (CURL)***/
        if ($message == "Verification Code - ") {
            $message .= $this->code;
        } else {
            $message .= ' '.env('APP_URL') ."/help/" .$this->countryCode. "/". $this->short_code;
            $message = mb_convert_encoding($message, 'HTML-ENTITIES', 'UTF-8');
        }
        $data = sprintf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<bulk-request login=\"%s\" password=\"%s\" ref-id=\"%s\" delivery-notification-requested=\"true\" version=\"1.0\">
  <message id=\"1\" msisdn=\"%s\" service-number=\"%s\" defer-date=\"%s\" validity-period=\"3\" priority=\"1\">
   <content type=\"text/plain\">%s</content>
</message>
</bulk-request>", env('SMS_LOGIN'), env('SMS_PASSWORD'), '2015-01-22 17:12:55', $phone, env('SMS_SERVICE_NUMBER'), '2019-08-26 12:14:29', $message);
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_PORT => "",
            CURLOPT_URL => env('SMS_HOST'),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 20,
            CURLOPT_TIMEOUT => 60,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => $data,
            CURLOPT_HTTPHEADER => array(
                "Accept: application/json",
                "Cache-Control: no-cache",
                "Content-Type: application/xml"
            ),
        ));

        $response = curl_exec($curl);
        $sent = false;
        $err = curl_error($curl);
        if (!curl_errno($curl)) {
            switch ($http_code = curl_getinfo($curl, CURLINFO_HTTP_CODE)) {
                case 200:  # OK
                    $sent = true;
                    break;
                default:
                    Log::emergency('Unexpected HTTP code: ' . $http_code . "\n");
            }
        }
        curl_close($curl);
        if ($sent === false) {
            Log::error($err . "\n");
        }
        $res['status'] = $sent;
        return $res;
    }

    public function sendMessageRequestGeo($phone, $message = "Verification Code - ")
    {
        $maxId = Sms::max('id');
        if(!$maxId){
            $maxId = 0;
        }

        $phoneStrArray = explode('+', $phone);
        $phone = (count($phoneStrArray)>1 )?$phoneStrArray[1]:$phone;
        $hash = $maxId + 1 .$phone;
        $this->short_code = PseudoCrypt::hash((int)$hash, 8);
        $res['code'] = null;
        $res['service_sms_id'] = null;
        $res['status'] = false;
        if ($message == "Verification Code - ") {
            $message .= $this->code;
        }else{
            $message .= ' '.env('APP_URL') ."/help/" .$this->countryCode. "/". $this->short_code;
        }
        ///**by file get content**///
        $url = "http://bi.msg.ge/sendsms.php?to="
            . urlencode($phone) . "&text="
            . urlencode($message) . "&service_id="
            . urlencode(env("GEORGIA_SMS_SERVICE_ID")) . "&client_id="
            . urlencode(env("GEORGIA_SMS_CLIENT_ID")) . "&password="
            . urlencode(env("GEORGIA_SMS_PASSWORD")) . "&username="
            . urlencode(env("GEORGIA_SMS_USERNAME")) . "&utf=1";
        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
        ));
        $response = curl_exec($curl);
        $sent = false;
        $err = curl_error($curl);
        if ($err) {
            $sent = false;
            $responseArray = explode('-', $response);
            if(count($responseArray) > 0){
                $res['code'] = $responseArray[0];
                $res['service_sms_id'] = $responseArray[1];
            }else{
                $res['code'] = "5000";
            }
            Log::error("GEORGIAN SMS SERVICE RETURNED ERROR : ". $err. "\n");
        }else{
            $sent = true;
        }
        curl_close($curl);
        if ($sent) {
            $responseArray = explode('-', $response);
            $res['code'] = $responseArray[0];
            $res['service_sms_id'] = $responseArray[1];
            if ($responseArray[0] == "0000") {
                $res['status'] = true;
            }else{
                $res['status'] = false;
                Log::error("GEORGIAN SMS SERVICE RETURNED ERROR : ". $response. "\n");
            }
        }
        return $res;
    }
}
