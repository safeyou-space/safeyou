<?php

namespace App\Http\Controllers;

use App\Helpers\FileLib;
use App\Models\EmergencyService;
use App\Models\Image;
use App\Models\SocialLink;
use App\Models\UserEmergencyServiceContacts;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class EmergencyServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request, $code)
    {
        $query = EmergencyService::with('category', 'user_detail', 'used_user')
             ->whereHas('user_detail', function ($query)use($request){
                 $query->where('is_admin', 0);
                 $query->where('is_super_admin', 0);
                 $query->where('role', 3);
                 if($request->has('phone') && $request->get('phone') != '') {
                     $query->Like(['phone'], $request->get('phone'));
                 }
                 if($request->has('email') && $request->get('email') != ''){
                     $query->Like(['email'],$request->get('email'));
                 }
                 if($request->has('location') && $request->get('location') != ''){
                     $query->Like(['location'],$request->get('location'));
                 }
                 if($request->has('status') && $request->get('status') != ''){
                     $query->Like(['status'],(int)$request->get('status'));
                 }
             })
            ->orderBy('created_at', 'desc');
        if($request->has('emergency_service_category_id') && $request->get('emergency_service_category_id') != ''){
            $query->Like(['emergency_service_category_id'],(int)$request->get('emergency_service_category_id'));
        }
        if($request->has('address') && $request->get('address') != ''){
            $query->Like(['address'],$request->get('address'));
        }
        if($request->has('title') && $request->get('title') != ''){
            $query->Like(['title'],$request->get('title'));
        }
        if($request->has('description') && $request->get('description') != ''){
            $query->Like(['description'],$request->get('description'));
        }
        if($request->has('is_send_sms') && $request->get('is_send_sms') != ''){
            $query->Like(['is_send_sms'],(int)$request->get('is_send_sms'));
        }

        if($query->exists()){
            return response()->json($query->orderBy('created_at', 'desc')->paginate(10), 200);
        }
        return response()->json(['message' => "Emergency Service not found"], 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            "title" => "required|string|min:1",
            "description" => "required|string|min:3",
            "location" => "required|string|min:3",
            "latitude" => "required|string|min:6",
            "longitude" => "required|string|min:6",
            "email" => "required",
            'phone' => "required|phone|min:9|max:13|unique:users,phone",
            "emergency_service_category" => "required|numeric|exists:emergency_service_categories,id",
            "web_address" => "nullable|string|min:6",
            "address" => "nullable|string|min:3",
            "social_links" => "array",
            "social_links.*" => "array",
            "social_links.*." => [
                "name"=>"required|string|min:2",
                "title"=>"required|string|min:2",
                "url"=>"required|string|min:8|url",
                "icon"=>"required|string|in:".implode(',',array_keys(Image::ICONS)).'"',
            ],
            "image" => "mimes:jpeg,bmp,png,gif|max:5120",
            'password' => 'required|min:8',
            'confirm_password' => 'required|min:8|same:password',
            "status" => "numeric|in:1,0",
            "is_send_sms" => "numeric|in:1,0",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $image_id = 10;
        if(request()->hasFile('image')){
            $image_id = FileLib::uploadImage($request->file('image'), 'emergency_service_profile');
            if(!$image_id){
                return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
            }
        }

        if($request->has('email') && ($request->get('email') != '')){
            if(!filter_var($request->get('email'), FILTER_VALIDATE_EMAIL)){
                return response()->json(['message' => ["Invalid email address"]], 400);
            }
            if(User::where('email', $request->get('email'))->exists()){
                return response()->json(['message' => ["this email already taken"]], 400);
            }
        }
        $user = new User();
        $user->first_name = $request->get('title');
        $user->email = $request->has('email')? $request->get('email'): null;
        $user->phone = $request->get('phone');
        $user->image_id = $image_id;
        $user->role = 3;
        $user->is_admin = 0;
        $user->is_super_admin = 0;
        $user->password = bcrypt($request->get('password'));
        $user->status = $request->has('status')? $request->get('status'): 0;
        $user->location = $request->get('location');
        $user->status = $request->has('status') ? $request->get('status') : 0;
        if ($user->save()) {
            $query = new EmergencyService();
            $query->title = $request->get('title');
            $query->description = $request->get('description');
            $query->latitude = $request->get('latitude');
            $query->longitude = $request->get('longitude');
            $query->web_address = $request->has('web_address')? $request->get('web_address'): null;
            $query->user_id = $user->id;
            $query->status = $request->has('status')? $request->get('status'): 0;
            $query->is_send_sms = $request->has('is_send_sms')? $request->get('is_send_sms'): 0;
            $query->address = $request->has('address')? $request->get('address'): null;
            $query->emergency_service_category_id = $request->get('emergency_service_category');
            if($query->save()){
                $user->service_id = $query->id;
                $user->save();
                if($request->has('social_links') && $request->get('social_links')!=[]){
                    foreach ($request->get('social_links') as $key =>$value){
                        if($value['title'] != '' && $value['url'] != '' && $value['icon'] != '' ){
                            $social = new SocialLink();
                            $social->title =  $value['title'];
                            $social->name =  $value['name'];
                            $social->url =  $value['url'];
                            $social->icon =  $value['icon'];
                            $social->emergency_service_id =  $query->id;
                            if(!$social->save()){
                                return response()->json(['message' => ["This Emergency Service successfully created without
                                social link.". $value['title']." Please try edit this Emergency Service.","Something went  wrong!"]], 200);
                            }
                        }
                    }
                }
                return response()->json(['message' => "This Emergency Service successfully created"], 200);
            }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);

        }return response()->json(['message'=>__('messages.registration_error')], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\EmergencyService  $emergencyService
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = EmergencyService::with( 'category', 'user_detail','social_links', 'used_user')->where('id', $id);
        if($query->exists()){
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "this Emergency Service not found"], 400);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\EmergencyService  $emergencyService
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "title" => "required|string|min:1",
            "description" => "required|string|min:3",
            "location" => "required|string|min:3",
            "latitude" => "required|string|min:6",
            "longitude" => "required|string|min:6",
            "email" => "required",
            'phone' => 'required|phone|min:9|max:13',
            "emergency_service_category" => "required|numeric|exists:emergency_service_categories,id",
            "web_address" => "nullable|string|min:6",
            "address" => "nullable|string|min:3",
            "social_links" => "array",
            "social_links.*" => "array",
            "social_links.*." => [
                "name"=>"required|string|min:2",
                "title"=>"required|string|min:2",
                "url"=>"required|string|min:8|url",
                "icon"=>"required|string|in:".implode(',',array_keys(Image::ICONS)).'"',
            ],
            "image" => "mimes:jpeg,bmp,png,gif|max:5120",
            'password' => 'min:8',
            'confirm_password' => 'min:8|same:password',
            "status" => "numeric|in:1,0",
            "is_send_sms" => "numeric|in:1,0",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        if($request->has('email') && ($request->get('email') != '')){
            if(!filter_var($request->get('email'), FILTER_VALIDATE_EMAIL)){
                return response()->json(['message' => ["Invalid email address"]], 400);
            }
        }
        $q = EmergencyService::with( 'user_detail','social_links')->where('id', $id);
        if(!$q->exists()){
            return response()->json(['message' => "This Emergency Service Not Found"], 404);
        }
        $q = $q->first();
        $query = User::where('id', $q->user_id);
        $query = $query->first();
        if($request->has('email')){
            if(User::where('id','!=', $q->user_id)->where('email', $request->get('email'))->exists()) {
                return response()->json(['message' => "This Email Address already taken"], 400);
            }
        }
        if($request->has('phone')){
            if(User::where('id','!=', $q->user_id)->where('phone', $request->get('phone'))->exists()) {
                return response()->json(['message' => "This Phone Number Address already taken"], 400);
            }
        }
        $query->status = $request->has('status')? $request->get('status') : $query->status;
        if($query->status != 1){
            $usedUsers = UserEmergencyServiceContacts::where('emergency_service_id', $id);
            if($usedUsers->exists()) {
                $usedUsers->delete();
                $userTokens = DB::table('oauth_access_tokens')->where('user_id', $query->user_id);
                if($userTokens->exists()) {
                    DB::table('oauth_refresh_tokens')
                        ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                        ->where('oauth_access_tokens.user_id', $query->user_id)->delete();
                    $userTokens->delete();
                }
            }
        }
        if(request()->hasFile('image')){
            if($query->image_id == 10){
                $old_image_id = null;
            }else{
                $old_image_id = $query->image_id;
            }
            $image_id = FileLib::uploadImage($request->file('image'), 'emergency_service_profile', $old_image_id);
            if(!$image_id){
                return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
            }$query->image_id = $image_id;
        }
        $query->first_name = $request->has('first_name')? $request->get('first_name'): $query->first_name;
        $query->location = $request->has('location')? $request->get('location'): $query->location;
        $query->email = $request->has('email')? $request->get('email') : $query->email;
        $query->phone = $request->has('phone')? $request->get('phone') : $query->phone;
        if($request->has('password')){
            $query->password = bcrypt($request->get('password'));
        }
        $q->is_send_sms = $request->has('is_send_sms')? $request->get('is_send_sms') : $q->is_send_sms;
        if($request->has('is_send_sms')) {
            if ($request->get('is_send_sms') == 0) {
                if (UserEmergencyServiceContacts::where('emergency_service_id', $id)->exists()) {
                    UserEmergencyServiceContacts::where('emergency_service_id', $id)->delete();
                }
            }
        }
        $q->description =  $request->has('description')? $request->get('description') : $q->description;
        $q->title =  $request->has('title')? $request->get('title') : $q->title;
        $q->latitude = $request->has('latitude')? $request->get('latitude'): $q->latitude;
        $q->longitude = $request->has('longitude')? $request->get('longitude') : $q->longitude;
        $q->web_address = $request->has('web_address')? $request->get('web_address') : $q->web_address;
        $q->status = $request->has('status')? $request->get('status') : $q->status;
        $q->address = $request->has('address')? $request->get('address') : $q->address;
        $q->emergency_service_category_id = $request->has('emergency_service_category_id')? $request->get('emergency_service_category_id') : $q->emergency_service_category_id;
        SocialLink::where('emergency_service_id', $id)->delete();
        if($request->has('social_links') && $request->get('social_links')!=[]){
            foreach ($request->get('social_links') as $key =>$value){
                if($value['title'] != '' && $value['url'] != '' && $value['icon'] != '' ){
                    $social = new SocialLink();
                    $social->name =  $value['name'];
                    $social->title =  $value['title'];
                    $social->url =  $value['url'];
                    $social->icon =  $value['icon'];
                    $social->emergency_service_id =  $q->id;
                    if(!$social->save()){
                        return response()->json(['message' => ["This Emergency Service successfully created without
                            social link.". $value['title']." Please try edit this Emergency Service.","Something went  wrong!"]], 200);
                    }
                }
            }
        }
        if($query->save() && $q->save()){
            if($request->has('is_send_sms') && ($request->get('is_send_sms') == 0)){
                $UsedServices = UserEmergencyServiceContacts::where('emergency_service_id', $id);
                if($UsedServices->exists()){
                    $UsedServices->delete();
                }
            }
            if($query->status != 1){
                $userTokens = DB::table('oauth_access_tokens')->where('user_id', $query->id);
                if($userTokens->exists()) {
                    DB::table('oauth_refresh_tokens')
                        ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                        ->where('oauth_access_tokens.user_id', $query->id)->delete();
                    $userTokens->delete();
                }
            }
            try {
                // refresh profile info
                file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $q->user_id, env('APP_SOCKET_SECRET_KEY')));
            } catch (\Exception $ex) { }
            return response()->json(['message' => "This Emergency Service successfully updated"], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
       }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\EmergencyService  $emergencyService
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $query = EmergencyService::with( 'social_links', 'used_user','sms')
            ->where('id', $id);

        if(!$query->exists()){
            return response()->json(['message' => ["this emergency service not found"]], 404);
        }
        $query = $query->first();
        if (Auth::user()->is_admin  && Auth::user()->is_super_admin) {
            $user = User::with(['image', 'emergencyContacts','help_sms'=>function($q){
                    $q->where('verifying_type', 3);
                },'forum_comments'=>function($q){
                    $q->with(['forum'=>function($q){
                        $q->with(['translations'=>function($q){
                            $q->whereHas('language', function ($q){
                                $q->where('code', 'en');
                            });
                        }]);
                    }]);
                }])->where( 'id', $query->user_id);
            if($user->exists()){
                $user = $user->first();
                if($user->forum_comments()->exists()){
                    $forumTitles = Collect();
                    foreach ($user->forum_comments as $comment){
                        $forumTitles->push($comment->forum->translations[0]->title);
                    }
                    $forums = implode(', ',$forumTitles->toArray());
                    return response()->json(['message' => "You can not delete this service. He\She has comment(s) in ". $forums], 400);
                }
                if($query->sms()->exists()){
                    return response()->json(['message' => "You can not delete this service. He\She has sent help Sms."], 400);
                }
                if($query->social_links()->exists()){
                    $query->social_links()->delete();
                }
                if($query->used_user()->exists()){
                    $query->used_user()->delete();
                }

                if($user->image_id && $user->image_id > 12) {
                    $Image = Image::where('id', $user->image_id);
                    if ($Image->exists()) {
                        $Image = $Image->first();
                        if (file_exists(public_path($Image->url))) {
                            unlink(public_path($Image->url));
                        } $Image->delete();
                    }
                }
                $userTokens = DB::table('oauth_access_tokens')->where('user_id', $user->id);
                if($userTokens->exists()) {
                    DB::table('oauth_refresh_tokens')
                        ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                        ->where('oauth_access_tokens.user_id',  $user->id)->delete();
                    $userTokens->delete();
                }
                if($user->delete() && $query->delete()){
                    return response()->json(['message' => "Successfully deleted"], 200);
                }
                return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
            }
        }
        return response()->json(['message' => "Permission denied"], 403);
    }
    public function changeIsSendSms(Request $request, $code, $id) {
        $validator = Validator::make($request->all(), [
            "is_send_sms" => "required|in:1,0"
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $service = EmergencyService::where('id', $id);
        if($service->exists()){
            $service = $service->first();
            $service->is_send_sms = $request->get('is_send_sms');
            if($request->get('is_send_sms') == 0){
                if(UserEmergencyServiceContacts::where('emergency_service_id', $id)->exists()){
                    UserEmergencyServiceContacts::where('emergency_service_id', $id)->delete();
                }
            }
            if($service->save()){
                return response()->json(['message' => "Successfully updated Is send Sms"], 200);
            }
            return response()->json(['message' => "Error updated Is send Sms"], 400);
        }
        return response()->json(['message' => "This service not found."], 400);
    }
}
