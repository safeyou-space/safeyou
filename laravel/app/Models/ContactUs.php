<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class ContactUs extends Model
{
    protected $table = 'contact_us';
    protected $fillable = [
        'name', 'message','email', 'checked', 'reply_id'
    ];
    public function user(){
        return $this->belongsTo(User::class,'user_id','id')
            ->with('image')->where('is_admin', 1)->orWhere('is_super_admin',1);
    }
    public function reply(){
        return $this->hasMany(ContactUs::class,'reply_id','id')->with('user');
    }
}
