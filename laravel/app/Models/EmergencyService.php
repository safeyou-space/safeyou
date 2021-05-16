<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class EmergencyService extends Model
{
    protected $table = 'emergency_services';
    protected $appends = ['icons', 'category', 'category_translation'];

    public function getIconsAttribute()
    {
        return Image::ICONS;
    }
    public function getCategoryTranslationAttribute()
    {
        return $this->category_trans->translation;
    }

    public  function scopeLike($query, $field, $value){
        if(is_array($field) && count($field)>0){
            $query->where(function ($query) use($field, $value){
                foreach ($field as $k => $f) {
                    $query = $query->orWhere($f, 'LIKE', "%".$value."%");
                }
            });
            return $query;
        }
        return $query->where($field, 'LIKE', "%".$value."%");
    }
    public function getCategoryAttribute()
    {
        return $this->category()->value('title');
    }
    public function used_user(){
        return $this->belongsToMany(User::class,'user_emergency_service_contacts',
            'emergency_service_id', 'user_id');

    }
    public function sms(){
        return $this->hasMany(Sms::class,'sms',
            'user_id', 'user_id');

    }
    public function social_links(){
        return $this->hasMany(SocialLink::class,
            'emergency_service_id', 'id');

    }
    protected $hidden = [
        'created_at', 'updated_at',
    ];
    public function user_detail(){
        return $this->belongsTo(User::class,'user_id','id')
            ->with('image')->where('role', 3);
    }
    public function user_service(){
        return $this->belongsToMany(User::class,'user_emergency_service_contacts','emergency_service_id', 'user_id')
            ->addSelect('user_emergency_service_contacts.id as user_service_id');
    }
    public function category(){
        return $this->belongsTo(EmergencyServiceCategory::class,'emergency_service_category_id','id');
    }
    public function service_category(){
        return $this->hasOne(EmergencyServiceCategory::class,'id','emergency_service_category_id');
    }
    public function category_trans(){
        return $this->belongsTo(EmergencyServiceCategory::class,'emergency_service_category_id','id');
    }

}
