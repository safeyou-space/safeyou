<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\App;

class EmergencyServiceCategory extends Model
{
    protected $appends = ['translation'];
    public function getTranslationAttribute()
    {
        return $this->translation()->value('translation');
    }
    public function translations(){
        return $this->hasMany(EmergencyServiceCategoryTranslation::class,'emergency_service_category_id','id');
    }
    public function translation(){
        return $this->hasOne(EmergencyServiceCategoryTranslation::class,'emergency_service_category_id','id')
            ->whereHas('language', function ($q){
                $q->where('code', App::getLocale());
            });
    }
}
