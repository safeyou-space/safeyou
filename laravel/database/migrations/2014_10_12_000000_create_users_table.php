<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->text('first_name');
            $table->text('last_name')->nullable();
            $table->string('nickname',188)->nullable();
            $table->string('email',188)->nullable();
            $table->smallInteger('marital_status')->default(-1);
            $table->string('phone',188)->nullable();
            $table->string('change_phone',188)->nullable();
            $table->smallInteger('is_verifying_otp')->default(0);
            $table->smallInteger('check_police')->default(0);
            $table->date('birthday')->nullable();
            $table->string('location')->nullable();
            $table->string('password');
            $table->smallInteger('is_super_admin')->default(0);
            $table->smallInteger('is_admin')->default(0);
            $table->smallInteger('is_consultant')->default(0);
            $table->smallInteger('consultant_category_id')->nullable();
            $table->smallInteger('role')->default(5);
            $table->smallInteger('help_message_id')->nullable();
            $table->integer('image_id')->default(1);
            $table->integer('service_id')->nullable();
            $table->string('device_token')->nullable();
            $table->smallInteger('device_type')->nullable();
            $table->smallInteger('status')->default(0);
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
