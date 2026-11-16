<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\App;

class HelpMessage extends Model
{
    protected $appends = ['translation'];

    public function getTranslationAttribute()
    {
        return $this->translation()->value('translation');
    }
    public function translations(){
        return $this->hasMany(HelpMessageTranslation::class,'help_message_id','id');
    }
    public function translation(){
        return $this->hasOne(HelpMessageTranslation::class,'help_message_id','id')
            ->whereHas('language', function ($q){
                $q->where('code', App::getLocale());
            });
    }
}
