<?php

namespace App\Services\Sms;

use App\Contracts\SmsGateway;
use InvalidArgumentException;

class SmsGatewayManager
{
    private $config;
    private $gateways = [];

    public function __construct(array $config)
    {
        $this->config = $config;
    }

    public function forCountry($countryCode)
    {
        $countries = isset($this->config['countries']) ? $this->config['countries'] : [];
        $name = empty($countries[$countryCode]) ? $this->defaultName() : $countries[$countryCode];

        return $this->gateway($name);
    }

    public function gateway($name = null)
    {
        $name = $name ?: $this->defaultName();
        if (!isset($this->gateways[$name])) {
            $this->gateways[$name] = $this->make($name);
        }

        return $this->gateways[$name];
    }

    private function defaultName()
    {
        if (empty($this->config['default'])) {
            throw new InvalidArgumentException('No default SMS gateway is configured.');
        }

        return $this->config['default'];
    }

    private function make($name)
    {
        if (!isset($this->config['gateways'][$name])) {
            throw new InvalidArgumentException('SMS gateway [' . $name . '] is not configured.');
        }
        $settings = $this->config['gateways'][$name];
        $driver = isset($settings['driver']) ? $settings['driver'] : $name;
        $class = isset($this->config['drivers'][$driver]) ? $this->config['drivers'][$driver] : $driver;
        if (!class_exists($class)) {
            throw new InvalidArgumentException('SMS driver [' . $driver . '] is not supported.');
        }
        $gateway = new $class($settings);
        if (!$gateway instanceof SmsGateway) {
            throw new InvalidArgumentException('SMS driver [' . $driver . '] must implement ' . SmsGateway::class . '.');
        }

        return $gateway;
    }
}
