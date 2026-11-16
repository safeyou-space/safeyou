<?php
namespace Database\seeds;
use Illuminate\Database\Seeder;

class HelpMessageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();

        \App\Models\HelpMessage::insert([
            [
                'message' => 'Help me please ',
                "status" => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);

        \App\Models\HelpMessageTranslation::insert([
            [
                'help_message_id' => 1,
                'translation' => 'Please Help Me',
                'language_id' => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\HelpMessageTranslation::insert([
            [
                'help_message_id' => 1,
                'translation' => 'Խնդրում եմ օգնել ինձ',
                'language_id' => 2,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
//        \App\Models\HelpMessageTranslation::insert([
//            [
//                'help_message_id' => 1,
//                'translation' => 'გთხოვთ დამეხმაროთ',
//                'language_id' => 3,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
//        \App\Models\HelpMessageTranslation::insert([
//            [
//                'help_message_id' => 1,
//                'translation' => 'Mənə kömək edin',
//                'language_id' => 4,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
    }
}
