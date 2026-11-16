<?php

namespace Database\seeds;

use App\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();

        User::insert([
            [
                'first_name' => 'Super',
                'last_name' => 'Admin',
                'nickname' => 'Super Admin',
                "is_verifying_otp" => 1,
                "birthday" => null,
                "check_police" => 0,
                "is_super_admin" => 1,
                "is_admin" => 0,
                "role" => 0,
                "status" => 1,
                'phone' => null,
                'email' => env('SUPER_ADMIN_USER_NAME'),
                'password' => bcrypt(env('SUPER_ADMIN_USER_PASSWORD')),
                'image_id' => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        User::insert([
            [
                'first_name' => 'Administrator',
                'last_name' => '',
                'nickname' => 'Admin',
                "is_verifying_otp" => 1,
                "birthday" => null,
                "check_police" => 0,
                "is_super_admin" => 0,
                "is_admin" => 1,
                "role" => 1,
                "status" => 1,
                'phone' => null,
                'email' => 'administrator@safeyou.org',
                'password' => bcrypt('armadmin12345!'),
                'image_id' => 2,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        DB::table('oauth_clients')->where('id', 1)->update(['personal_access_client' => 0],['password_client' => 1]);
    }
}
