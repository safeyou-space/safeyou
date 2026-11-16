<?php
namespace Database\seeds;
namespace Database\seeds;

use App\Models\Languages;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class LanguageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();

        Languages::insert([
            [
                'title' => 'English',
                'code' => 'en',
                "status" => 1,
                'image_id' => 4,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        Languages::insert([
            [
                'title' => 'Հայերեն',
                'code' => 'hy',
                "status" => 1,
                'image_id' => 5,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
//        Languages::insert([
//            [
//                'title' => 'ქართული',
//                'code' => 'ka',
//                "status" => 1,
//                'image_id' => 6,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
//        Languages::insert([
//            [
//                'title' => 'Azərbaycan',
//                'code' => 'az',
//                "status" => 1,
//                'image_id' => 7,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
    }
}
