<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateForumNotificationsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('forum_notifications', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('forum_id');
            $table->integer('user_id');
            $table->timestamp('datetime');
            $table->unique(['forum_id', 'user_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('forum_notifications');
    }
}
