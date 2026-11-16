<?php

namespace App\Contracts;

interface SmsGateway
{
    /**
     * Send one text message.
     *
     * @param string $phone   Recipient number in international format.
     * @param string $message Text of the message.
     * @return \App\Services\Sms\SmsResult
     */
    public function send($phone, $message);
}
