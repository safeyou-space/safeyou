<?php

namespace App;
use App\Models\ConsultantRequest;
use App\Models\EmergencyService;
use App\Models\ForumDiscussions;
use App\Models\HelpMessage;
use App\Models\Image;
use App\Models\ProfessionConsultantServiceCategory;
use App\Models\Sms;
use App\Models\UserEmergencyContacts;
use App\Models\UserEmergencyServiceContacts;
use App\Models\UserRecords;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Request;
use Laravel\Passport\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
class User extends Authenticatable
{
    use HasApiTokens, Notifiable;
    public function get_oauth_client(){
        return $this->accessToken->client;
    }
    const MARITAL_STATUS = [
        -1 => 'marital_status_-1',
        0 => 'marital_status_0',
        1 => 'marital_status_1',
    ];
    const ROLES = [
        '0' => 'Super Admin',
        '1' => 'Admin',
        '2' => 'Moderator',
        '3' => 'Emergency',
        '4' => 'Consultant',
        '5' => 'User',
    ];
    const ACCESS = [
        'moderator'=>[
            'forum.index',
            'forum.store',
            'forum.show',
            'forum.update',
            'forum.destroy',
            'forum_comment.delete',
            'forum_comment.store',
            'forum_comment.reply',
            'profile.show',
            'profile.update',
        ],
        'emergency'=>[
            'forum.index',
            'forum.store',
            'forum.show',
            'forum.update',
            'forum_comment.store',
            'forum_comment.reply',
            'profile.show',
            'profile.update',
        ],
    ];

    protected $dates = ['birthday'];
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'first_name', 'last_name', 'phone','email', 'password', 'location','nickname', 'device_token'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    public static function getViewAccess($role)
    {
        $access = collect();
        foreach (self::ACCESS[strtolower($role)] as $key => $value){
            $page_method_array = explode('.', $value);
            $method = $page_method_array[1];
            switch ($page_method_array[1]) {
                case 'index':
                    $method = 'list';
                    break;
                case 'update':
                    $method = 'edit';break;
                case 'show':
                    $method = 'view';break;
                case 'destroy':
                    $method = 'delete';break;
                case 'store':
                    $method = 'create';break;
            }
            if(!$access->get($page_method_array[0])){
                $access->put($page_method_array[0], collect());
            }
            $access[$page_method_array[0]]->push($method);
        }
        return $access->all();
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
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
    public function help_message(){
        return $this->belongsTo(HelpMessage::class,'help_message_id','id');
    }


    public function consultant_category(){
        return $this->belongsTo(ProfessionConsultantServiceCategory::class,'consultant_category_id','id');
    }
    public function emergency_services(){
        return $this->belongsToMany(EmergencyService::class,'user_emergency_service_contacts',
            'user_id','emergency_service_id')
            ->withPivot('id as user_emergency_service_id');
    }
    public function emergencyContacts(){
        return $this->hasMany(UserEmergencyContacts::class,  'user_id','id');
    }
    public function emergencyServiceContacts(){
        return $this->hasMany(UserEmergencyServiceContacts::class,  'user_id','id');
    }
    public function records(){
        return $this->hasMany(UserRecords::class, 'id','user_id');
    }
    public function sms(){
        return $this->belongsTo(Sms::class, 'id','user_id');
    }
    public function help_sms(){
        return $this->belongsTo(Sms::class, 'id','from_user_id');
    }
    public function forum_comments(){
        return $this->hasMany(ForumDiscussions::class,  'user_id','id');
    }
    public function consultant_request(){
        return $this->hasMany(ConsultantRequest::class,  'user_id','id');
    }

    public function findForPassport($identifier) {
        return $this->where(function ($q) use ($identifier){
            $q->where('phone', $identifier)
                ->orWhere('email', $identifier);
        })->first();
    }
    public function getBirthdayAttribute($value)
    {
        return \Carbon\Carbon::parse($value)->format('m/d/Y');
    }
    public function setBirthdayAttribute($value)
    {
        $this->attributes['birthday'] = \Carbon\Carbon::createFromFormat('d/m/Y', $value)->toDateString();
    }

    public function getIsAdminAttribute($value)
    {
        if($value == 1){
            return "true";
        }else{
            return "false";
        }
    }
    public function getIsSuperAdminAttribute($value)
    {
        if($value == 1){
            return "true";
        }else{
            return "false";
        }
    }

    public function getMaritalStatusAttribute($value)
    {
        if ($value !== null)
            return __(sprintf('messages.marital_status_%d', $value));
    }

    public function getRoleAttribute($value)
    {
        if($value == 0){
            return "Super Admin";
        }
        if($value == 1){
            return "Administrator";
        }
        if($value == 2){
            return "Moderator";
        }
        if($value == 3){
            return "Emergency";
        }
        if($value == 4){
            return "Consultant";
        }
        if($value == 5){
            return "Client";
        }
    }
}

