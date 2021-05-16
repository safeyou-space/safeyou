<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class Sms extends Model
{
    protected $table = 'sms';
    public function user(){
        return $this->belongsTo(User::class,'user_id','id');
    }
    Const TYPE = [
        'verify_phone_number'=>1,
        'forgot_password'=>2,
        'help_message'=>3,
    ];
    protected $hidden = [
        //'verifying_otp_code', 'verifying_otp_valid_datetime',
    ];
    protected $fillable = [
        'name', 'verifying_otp_code','verifying_otp_valid_datetime', 'verifying_type',
        'checked','response_message', 'response_code', 'uri'
    ];
    public function from_user(){
        return $this->belongsTo(User::class,'from_user_id','id');
    }


}
