<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Languages extends Model
{
    protected $table = 'languages';
    public function image(){
        return $this->belongsTo(Image::class,'image_id','id');
    }
}
