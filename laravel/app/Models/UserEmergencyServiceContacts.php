<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class UserEmergencyServiceContacts extends Model
{
    protected $table = 'user_emergency_service_contacts';

    public function users($type){
        $r_types = array_flip(EmergencyServiceCategory::orderBy('id', 'desc')->pluck('title', 'id'));
        $category = $r_types[$type];

        return $this->belongsToMany(User::class,'user_emergency_service_contacts', 'user_id','emergency_service_id')->where('emergency_service_category_id', $category);
    }
    public function getServiceTypeAttribute($value)
    {
        return EmergencyServiceCategory::orderBy('id', 'desc')->pluck('title', 'id')[$value];
    }
    public function setServiceTypeAttribute($value)
    {
        $types = array_flip(EmergencyServiceCategory::orderBy('id', 'desc')->pluck('title', 'id'));
        $this->attributes['emergency_service_type'] =  $types[$value];
    }
}
