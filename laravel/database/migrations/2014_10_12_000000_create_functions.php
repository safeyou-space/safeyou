<?php

use Illuminate\Database\Migrations\Migration;
use \Illuminate\Support\Facades\DB;

class CreateFunctions extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
//        DB::unprepared("DROP FUNCTION IF EXISTS get_top_commented_users");
//        DB::unprepared("
//            CREATE FUNCTION `get_top_commented_users`(forumId INT(10)) RETURNS TEXT
//                DETERMINISTIC
//            RETURN (SELECT CONCAT('[', GROUP_CONCAT(top.top_commented_users), ']') AS top_commented_users FROM (
//                SELECT CONCAT('{\"nickname\":\"', CASE WHEN nickname IS NULL THEN CONCAT(last_name, '_', first_name) ELSE users.nickname END, '\",\"user_id\":', user_id, ',\"image_path\":\"', CASE WHEN images.url IS NULL THEN (SELECT url FROM images WHERE TYPE = 1) ELSE images.url END, '\"}') AS top_commented_users FROM forum_discussions
//                JOIN users ON users.id = user_id
//                LEFT JOIN images ON images.id = users.image_id
//                WHERE forum_id = forumId
//                GROUP BY user_id
//                ORDER BY COUNT(user_id) DESC
//                LIMIT 3
//            ) AS top)
//        ");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared("DROP FUNCTION IF EXISTS get_top_commented_users");
    }
}
