<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ForumTranslations extends Model
{
    public function language(){
        return $this->belongsTo(Languages::class,'language_id','id');
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
}
