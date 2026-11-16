<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserRecords extends Model
{
    protected $table = 'user_records';
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
