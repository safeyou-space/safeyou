<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Country extends Model
{
    protected $appends = ['image_url'];
    public function getImageUrlAttribute()
    {
        return $this->image->url;
    }
    public function translations(){
        return $this->hasMany(CountryTranslation::class,'country_id','id');
    }
    public function image(){
        return $this->belongsTo(Image::class,'image_id','id');
    }
}
