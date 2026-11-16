<?php

namespace App\Services\Sms;

class SmsResult
{
    public $sent;
    public $code;
    public $providerMessageId;
    public $description;

    public function __construct($sent, $code = null, $providerMessageId = null, $description = null)
    {
        $this->sent = (bool) $sent;
        $this->code = $code;
        $this->providerMessageId = $providerMessageId;
        $this->description = $description;
    }

    public static function sent($code = null, $providerMessageId = null, $description = null)
    {
        return new self(true, $code, $providerMessageId, $description);
    }

    public static function failed($code = null, $providerMessageId = null, $description = null)
    {
        return new self(false, $code, $providerMessageId, $description);
    }
}
