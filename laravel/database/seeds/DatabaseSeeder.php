<?php

use Illuminate\Database\Seeder;
use \Database\seeds\UserSeeder;
use \Database\seeds\ImageSeeder;
use \Database\seeds\LanguageSeeder;
use \Database\seeds\CountrySeeder;
use \Database\seeds\HelpMessageSeeder;
use \Database\seeds\SettingSeeder;
use \Database\seeds\ContentSeeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call(ImageSeeder::class);
        $this->call(LanguageSeeder::class);
        $this->call(UserSeeder::class);
        $this->call(CountrySeeder::class);
        $this->call(HelpMessageSeeder::class);
        $this->call(SettingSeeder::class);
        $this->call(ContentSeeder::class);

        \Illuminate\Support\Facades\Artisan::call('passport:install');
        \Illuminate\Support\Facades\DB::table('oauth_clients')->where('id', 2)->update(['user_id' => 1]);
    }
}
