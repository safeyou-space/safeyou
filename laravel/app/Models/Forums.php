<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class Forums extends Model
{
    protected $table = 'forums';
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
    public function image(){
        return $this->belongsTo(Image::class,'image_id','id');
    }
    public function creator(){
        return $this->belongsTo(User::class,'creator_id','id');
    }
    public function discussions(){
        return $this->hasMany(ForumDiscussions::class,'forum_id','id');
    }
    public function translations(){
        return $this->hasMany(ForumTranslations::class,'forum_id','id');
    }


}
