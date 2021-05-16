<?php

namespace Database\seeds;
use Illuminate\Database\Seeder;

class CountrySeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();

        \App\Models\Country::insert([
            [
                'name' => 'Armenia',
                'short_code' => 'arm',
                'code' => 'am',
                'image_id' => 8,
                "status" => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\Country::insert([
            [
                'name' => 'Georgia',
                'short_code' => 'geo',
                'code' => 'ge',
                'image_id' => 9,
                "status" => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\CountryTranslation::insert([
            [
                'country_id' => 1,
                'translation' => 'Armenia',
                'language_id' => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\CountryTranslation::insert([
            [
                'country_id' => 1,
                'translation' => 'Հայաստան',
                'language_id' => 2,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
//        \App\Models\CountryTranslation::insert([
//            [
//                'country_id' => 1,
//                'translation' => 'სომხეთი',
//                'language_id' => 3,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
//        \App\Models\CountryTranslation::insert([
//            [
//                'country_id' => 1,
//                'translation' => 'Ermənistan',
//                'language_id' => 4,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);


        \App\Models\CountryTranslation::insert([
            [
                'country_id' => 2,
                'translation' => 'Georgia',
                'language_id' => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\CountryTranslation::insert([
            [
                'country_id' => 2,
                'translation' => 'Վրաստան',
                'language_id' => 2,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\CountryTranslation::insert([
            [
                'country_id' => 2,
                'translation' => 'საქართველო',
                'language_id' => 3,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\CountryTranslation::insert([
            [
                'country_id' => 2,
                'translation' => 'Gürcüstan',
                'language_id' => 4,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
    }
}
