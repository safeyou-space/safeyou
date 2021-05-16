<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class ForumDiscussions extends Model
{
    public function user(){
        return $this->hasOne(User::class,'id','user_id');
    }
    public function forum(){
        return $this->hasOne(Forums::class,'id','forum_id');
    }
    public function reply(){
        return $this->hasOne(ForumDiscussions::class,'id','reply_id');
    }
}
