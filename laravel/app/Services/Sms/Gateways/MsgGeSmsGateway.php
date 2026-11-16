<?php

namespace App\Services\Sms\Gateways;

use App\Contracts\SmsGateway;
use App\Services\Sms\SmsResult;
use Illuminate\Support\Facades\Log;

class MsgGeSmsGateway implements SmsGateway
{
    const SENT = "0000";
    const SERVER_ERROR = "5000";
    const REQUEST_STATUS = [
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

    private $settings;

    public function __construct(array $settings)
    {
        $this->settings = $settings + ['url' => null, 'service_id' => null, 'client_id' => null, 'password' => null, 'username' => null];
    }

    public function send($phone, $message)
    {
        $url = $this->settings['url'] . "?to="
            . urlencode(ltrim($phone, '+')) . "&text="
            . urlencode($message) . "&service_id="
            . urlencode($this->settings['service_id']) . "&client_id="
            . urlencode($this->settings['client_id']) . "&password="
            . urlencode($this->settings['password']) . "&username="
            . urlencode($this->settings['username']) . "&utf=1";
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
        $err = curl_error($curl);
        curl_close($curl);
        if ($err) {
            Log::error("GEORGIAN SMS SERVICE RETURNED ERROR : " . $err . "\n");

            return SmsResult::failed(self::SERVER_ERROR, null, self::REQUEST_STATUS[self::SERVER_ERROR]);
        }
        $parts = explode('-', (string) $response);
        $code = $parts[0];
        $providerMessageId = isset($parts[1]) ? $parts[1] : null;
        $description = isset(self::REQUEST_STATUS[$code]) ? self::REQUEST_STATUS[$code] : null;
        if ($code === self::SENT) {
            return SmsResult::sent($code, $providerMessageId, $description);
        }
        Log::error("GEORGIAN SMS SERVICE RETURNED ERROR : " . $response . "\n");

        return SmsResult::failed($code, $providerMessageId, $description);
    }
}
