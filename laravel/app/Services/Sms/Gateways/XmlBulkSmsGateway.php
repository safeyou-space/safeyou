<?php

namespace App\Services\Sms\Gateways;

use App\Contracts\SmsGateway;
use App\Services\Sms\SmsResult;
use Illuminate\Support\Facades\Log;

class XmlBulkSmsGateway implements SmsGateway
{
    const REFERENCE_ID = '2015-01-22 17:12:55';
    const DEFER_DATE = '2019-08-26 12:14:29';
    const REQUEST = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<bulk-request login=\"%s\" password=\"%s\" ref-id=\"%s\" delivery-notification-requested=\"true\" version=\"1.0\">
  <message id=\"1\" msisdn=\"%s\" service-number=\"%s\" defer-date=\"%s\" validity-period=\"3\" priority=\"1\">
   <content type=\"text/plain\">%s</content>
</message>
</bulk-request>";

    private $settings;

    public function __construct(array $settings)
    {
        $this->settings = $settings + ['url' => null, 'login' => null, 'password' => null, 'service_number' => null];
    }

    public function send($phone, $message)
    {
        $data = sprintf(
            self::REQUEST,
            $this->settings['login'],
            $this->settings['password'],
            self::REFERENCE_ID,
            $phone,
            $this->settings['service_number'],
            self::DEFER_DATE,
            mb_convert_encoding($message, 'HTML-ENTITIES', 'UTF-8')
        );
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_PORT => "",
            CURLOPT_URL => $this->settings['url'],
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

        curl_exec($curl);
        $sent = false;
        $err = curl_error($curl);
        if (!curl_errno($curl)) {
            $http_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
            if ($http_code == 200) {
                $sent = true;
            } else {
                Log::emergency('Unexpected HTTP code: ' . $http_code . "\n");
            }
        }
        curl_close($curl);
        if ($sent === false) {
            Log::error($err . "\n");
        }

        return $sent ? SmsResult::sent() : SmsResult::failed();
    }
}
