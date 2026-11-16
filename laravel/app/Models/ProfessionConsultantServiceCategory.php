<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\App;

class ProfessionConsultantServiceCategory extends Model
{
    protected $appends = ['translation'];
    public function getTranslationAttribute()
    {
        return $this->translations()->with('language')->whereHas('language', function ($q){
            $q->where('code', App::getLocale());
        })->value('translation');
    }
    public function translations(){
        return $this->hasMany(ProfessionConsultantServiceCategoryTranslation::class,'profession_consultant_service_category_id','id');
    }
}
