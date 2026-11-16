<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class ConsultantRequest extends Model
{
    public function category(){
        return $this->belongsTo(ProfessionConsultantServiceCategory::class,'profession_consultant_service_category_id','id')->with('translations');
    }
    public function user(){
        return $this->belongsTo(User::class,'user_id','id');
    }
    public function getUpdatedAtAttribute($value)
    {
        return \Carbon\Carbon::parse($value)->format('m/d/Y');
    }
}
