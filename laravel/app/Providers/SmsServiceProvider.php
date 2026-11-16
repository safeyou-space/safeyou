<?php

namespace App\Providers;

use App\Contracts\SmsGateway;
use App\Services\Sms\SmsGatewayManager;
use Illuminate\Support\ServiceProvider;

class SmsServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(SmsGatewayManager::class, function ($app) {
            return new SmsGatewayManager($app['config']->get('sms', []));
        });

        $this->app->bind(SmsGateway::class, function ($app) {
            return $app->make(SmsGatewayManager::class)->gateway();
        });
    }
}
