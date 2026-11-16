<?php

namespace App\Services\Sms\Gateways;

use App\Contracts\SmsGateway;
use App\Services\Sms\SmsResult;
use Illuminate\Support\Facades\Log;

class LogSmsGateway implements SmsGateway
{
    public function __construct(array $settings = [])
    {
    }

    public function send($phone, $message)
    {
        Log::info('SMS to ' . $phone . ': ' . $message);

        return SmsResult::sent();
    }
}
