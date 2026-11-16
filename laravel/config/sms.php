<?php

return [

    /*
     * Gateway used when a country has no gateway of its own.
     * "log" writes the message to the application log and sends nothing,
     * so the project runs without an account at any SMS provider.
     */
    'default' => env('SMS_GATEWAY', 'log'),

    /*
     * Gateway per country code. An empty value means the default gateway.
     */
    'countries' => [
        'arm' => env('SMS_GATEWAY_ARM'),
        'geo' => env('SMS_GATEWAY_GEO'),
    ],

    /*
     * Configured gateways. "driver" names an entry of the drivers list below,
     * or is the name of a class that implements App\Contracts\SmsGateway.
     */
    'gateways' => [

        'log' => [
            'driver' => 'log',
        ],

        'xml_bulk' => [
            'driver' => 'xml_bulk',
            'url' => env('SMS_HOST'),
            'login' => env('SMS_LOGIN'),
            'password' => env('SMS_PASSWORD'),
            'service_number' => env('SMS_SERVICE_NUMBER'),
        ],

        'msg_ge' => [
            'driver' => 'msg_ge',
            'url' => env('GEORGIA_SMS_URL', 'http://bi.msg.ge/sendsms.php'),
            'service_id' => env('GEORGIA_SMS_SERVICE_ID'),
            'client_id' => env('GEORGIA_SMS_CLIENT_ID'),
            'password' => env('GEORGIA_SMS_PASSWORD'),
            'username' => env('GEORGIA_SMS_USERNAME'),
        ],

    ],

    'drivers' => [
        'log' => App\Services\Sms\Gateways\LogSmsGateway::class,
        'xml_bulk' => App\Services\Sms\Gateways\XmlBulkSmsGateway::class,
        'msg_ge' => App\Services\Sms\Gateways\MsgGeSmsGateway::class,
    ],

];
