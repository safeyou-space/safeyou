<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSmsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('sms', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('user_id')->nullable();
            $table->integer('from_user_id')->nullable();
            $table->string('verifying_otp_code',6)->nullable();
            $table->string('phone');
            $table->string('verifying_otp_valid_datetime')->nullable();
            $table->text('message');
            $table->text('response_message')->nullable();
            $table->text('response_code')->nullable();
            $table->string('uri')->nullable();
            $table->string('service_sms_id')->nullable();
            $table->string('latitude')->nullable();
            $table->string('longitude')->nullable();
            $table->smallInteger('verifying_type')->default(1);
            $table->smallInteger('checked')->default(0);
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
        Schema::dropIfExists('sms');
    }
}
