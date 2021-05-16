<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEmergencyServicesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('emergency_services', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('title');
            $table->text('description');
            $table->string('latitude');
            $table->string('longitude');
            $table->string('address')->nullable();
            $table->string('web_address')->nullable();
            $table->integer('emergency_service_category_id');
            $table->integer('user_id');
            $table->smallInteger('status')->default(1);
            $table->smallInteger('is_send_sms')->default(1);
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
        Schema::dropIfExists('emergency_services');
    }
}
