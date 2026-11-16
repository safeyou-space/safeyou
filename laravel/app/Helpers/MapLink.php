<?php

namespace App\Helpers;

class MapLink
{
    public static function to($latitude, $longitude)
    {
        return str_replace(
            ['{lat}', '{lng}'],
            [rawurlencode(trim((string) $latitude)), rawurlencode(trim((string) $longitude))],
            config('map.link_template')
        );
    }
}
