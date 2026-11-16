<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EmergencyServiceCategoryTranslation extends Model
{
    public function language(){
        return $this->belongsTo(Languages::class,'language_id','id');
    }
}
