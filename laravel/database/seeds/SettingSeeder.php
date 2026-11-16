<?php
namespace Database\seeds;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();

        \App\Models\Setting::insert([
            [
                'key' => 'default_support_language',
                'title_key' => 'default language',
                'value' => '1',
                'title_value' => 'English',
                'description' => 'Application Default language',
                "status" => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ],
            [
                'key' => 'default_help_message',
                'title_key' => 'default message help',
                'value' => '1',
                'title_value' => 'Help me please',
                'description' => 'Application Send Sms Help Message text',
                "status" => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
    }
}
