<?php
namespace Database\seeds;
use Illuminate\Database\Seeder;

class ImageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        \App\Models\Image::insert([
            [
                "id" => 1,
                "name" => "admin_avatar.png",
                "path" => "/upload/images/users/profiles/admins/",
                "url" => "/upload/images/users/profiles/admins/admin_avatar.png",
                "type" => 1
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 2,
                "name" => "avatar.png",
                "path" => "/upload/images/users/profiles/admins/",
                "url" => "/upload/images/users/profiles/admins/avatar.png",
                "type" => 1
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 3,
                "name" => "profile.png",
                "path" => "/upload/images/users/profiles/users/",
                "url" => "/upload/images/users/profiles/users/default_profile.png",
                "type" => 2
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 4,
                "name" => "en.png",
                "path" => "/upload/images/languages/flags/",
                "url" => "/upload/images/languages/flags/en.png",
                "type" => 3
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 5,
                "name" => "hy.png",
                "path" => "/upload/images/languages/flags/",
                "url" => "/upload/images/languages/flags/hy.png",
                "type" => 3
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 6,
                "name" => "ka.png",
                "path" => "/upload/images/languages/flags/",
                "url" => "/upload/images/languages/flags/ka.png",
                "type" => 3
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 7,
                "name" => "az.png",
                "path" => "/upload/images/languages/flags/",
                "url" => "/upload/images/languages/flags/az.png",
                "type" => 3
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 8,
                "name" => "arm.png",
                "path" => "/upload/images/countries/flags/",
                "url" => "/upload/images/countries/flags/arm.png",
                "type" => 4
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 9,
                "name" => "geo.png",
                "path" => "/upload/images/countries/flags/",
                "url" => "/upload/images/countries/flags/geo.png",
                "type" => 4
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 10,
                "name" => "default_emergency_service.png",
                "path" => '/upload/images/users/profiles/emergency/',
                "url" => "/upload/images/users/profiles/emergency/default_emergency_service.png",
                "type" => 5
            ]
        ]);
        \App\Models\Image::insert([
            [
                "id" => 11,
                "name" => "default_consultant_service.png",
                "path" => '/upload/images/users/profiles/consultant/',
                "url" => "/upload/images/users/profiles/consultant/default_consultant_service.png",
                "type" => 6
            ]
        ]);

        \App\Models\Image::insert([
            [
                "id" => 12,
                "name" => "image-not-default_forum.jpg",
                "path" => env('UPLOAD_FORUM_IMAGE'),
                "url" => env('UPLOAD_FORUM_IMAGE') . "default_forum.jpg",
                "type" => 7
            ]
        ]);


    }
}
