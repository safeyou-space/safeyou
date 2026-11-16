<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Image extends Model
{
    protected $table = 'images';
    const TYPES = [
        'admin_profile' => 1,
        'user_profile' => 2,
        'language_flag' => 3,
        'country_flag' => 4,
        'emergency_service_profile' => 5,
        'consultant_service_profile' => 6,
        'forum' => 7,
        'social_media' => 8
    ];
    const ICONS = [
        'facebook' => "/upload/images/icons/icon_facebook.png",
        'instagram' =>  "/upload/images/icons/icon_instagram.png",
        'address' => "/upload/images/icons/icon_location.png",
        'phone' => "/upload/images/icons/icon_phone.png",
        'email' => "/upload/images/icons/icon_email.png",
        'web_address' => "/upload/images/icons/icon_web_site.png",
    ];


    public $timestamps = false;
}
