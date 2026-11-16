<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProfessionConsultantServiceCategoryTranslationsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('profession_consultant_service_category_translations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('profession_consultant_service_category_id');
            $table->text('translation');
            $table->integer('language_id')->default(1);
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
        Schema::dropIfExists('profession_consultant_service_category_translations');
    }
}
