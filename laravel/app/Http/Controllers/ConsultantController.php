<?php

namespace App\Http\Controllers;

use App\Models\ConsultantRequest;
use App\Models\Image;
use App\Models\Setting;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Helpers\FileLib;
use Illuminate\Validation\Rule;

class ConsultantController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request, $code)
    {
        $query = User::with('image', 'consultant_category')
            ->where('is_consultant', 1)
            ->where('role',4)
            ->where('is_admin',0)
            ->where('is_super_admin',0)
            ->orderBy('created_at', 'desc');
        if($request->has('consultant_category_id') && $request->get('consultant_category_id') != ''){
            $query->Like(['consultant_category_id'],(int)$request->get('consultant_category_id'));
        }
        if($request->has('first_name') && $request->get('first_name') != ''){
            $query->Like(['first_name'],$request->get('first_name'));
        }
        if($request->has('last_name') && $request->get('last_name') != ''){
            $query->Like(['last_name'],$request->get('last_name'));
        }
        if($request->has('phone') && $request->get('phone') != ''){
            $query->Like(['phone'],$request->get('phone'));
        }
        if($request->has('location') && $request->get('location') != ''){
            $query->Like(['location'],$request->get('location'));
        }
        if($request->has('nickname') && $request->get('nickname') != ''){
            $query->Like(['nickname'],$request->get('nickname'));
        }
        if($request->has('status') && $request->get('status') != ''){
            $query->Like(['status'],(int)$request->get('status'));
        }
        if($request->has('is_verifying_otp') && $request->get('is_verifying_otp') != ''){
            $query->Like(['is_verifying_otp'],(int)$request->get('is_verifying_otp'));
        }

        if ($query->exists()) {$query=$query->paginate(10);
            return response()->json($query, 200);
        }
        return response()->json(['message' => "Empty Not Created"], 200);
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
            "first_name" => "required|min:3|max:250",
            "last_name" => "required|min:3|max:250",
            'nickname' => 'min:2',
            'location' => 'nullable|max:150',
            'phone' => 'required|phone|min:9|max:13|unique:users,phone',
            'birthday' => 'required|date_format:d/m/Y',
            'marital_status'=> Rule::in(['-1','0', '1']),
            'password' => 'min:8',
            'confirm_password' => 'min:8|same:password',
            "status" => "numeric|in:1,0",
            "is_verifying_otp" => "numeric|in:1,0",
            "consultant_category_id" => "required|exists:profession_consultant_service_categories,id",
            "check_police" => "numeric|in:1,0",
            "image" => "mimes:jpeg,bmp,png,ico,icon,gif,tga|max:5120",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        if ($request->has('nickname') && $request->has('nickname') != '') {
            if(User::where('nickname', $request->get('nickname'))->exists()){
                return response()->json(['message' => "this nickname already taken"], 400);
            }
        }
        if ($request->has('phone') && User::where('phone', $request->get('phone'))->exists()) {
            return response()->json(['message' => "this phone address already taken"], 400);
        }
        $user = new User();
        $user->first_name = $request->get('first_name');
        $user->last_name = $request->get('last_name');
        $user->nickname = $request->has('nickname')?$request->get('nickname'):NULL;
        $user->password = bcrypt($request->get('password'));
        $user->status = $request->has('status') ? $request->get('status') : 0;
        $user->is_admin = 0;
        $user->is_super_admin = 0;
        $user->role = 4;
        $user->phone = $request->get('phone');
        $user->birthday = $request->get('birthday');
        $user->marital_status = $request->has('marital_status')?$request->get('marital_status'):-1;
        $user->is_verifying_otp = $request->has('is_verifying_otp') ? $request->get('is_verifying_otp') : 0;
        $user->check_police = $request->has('check_police') ? $request->get('check_police') : 0;
        $SettingHelpMessageId = Setting::where('status', 1)->where('key', 'default_help_message');
        $user->help_message_id = $SettingHelpMessageId->exists()?$SettingHelpMessageId->value('value'): NULL;
        $user->location = $request->has('location') ? $request->get('location') : NULL;
        $user->is_consultant = 1;
        $user->consultant_category_id = $request->get('consultant_category_id');
        if ($request->hasFile('image')) {
            $image_id = FileLib::uploadImage($request->file('image'), 'user_profile');
            if(!$image_id){
                return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
            }$user->image_id = $image_id;
        } else {
            $user->image_id = 11;
        }
        if ($user->save()) {
            return response()->json(['message' => $request->get('first_name') .
                " " . $request->get('last_name'). " Successfully created as a consultant"], 200);
        }
        return response()->json(['message' => "Error created"], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = User::with('image', 'consultant_category')->where('is_consultant',1)
            ->where('id', $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "Not found"], 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "first_name" => "required|min:3|max:250",
            "last_name" => "required|min:3|max:250",
            'nickname' => 'min:2',
            'location' => 'nullable|max:150',
            'birthday' => 'required|date_format:d/m/Y',
            'marital_status'=> Rule::in(['-1','0', '1']),
            'password' => 'min:8',
            'confirm_password' => 'min:8|same:password',
            "status" => Rule::in(['2','0', '1']),
            "is_verifying_otp" => "numeric|in:1,0",
            "check_police" => "numeric|in:1,0",
            "consultant_category_id" => "required|exists:profession_consultant_service_categories,id",
            "image" => "mimes:jpeg,bmp,png,ico,icon,gif,tga|max:5120",
        ]);
        $query = User::where('id', $id)->where('is_consultant',1);
        if ($query->exists()) {
            if ($validator->fails()) {
                return response()->json(['message' => $validator->errors()], 422);
            }
            if($request->get('status') == 1 || $request->get('status') == 0){
                $validatorPhone = Validator::make($request->all(), [
                    'phone' => 'required|phone|min:9|max:13',
                ]);
                if ($validatorPhone->fails()) {
                    return response()->json(['message' => $validator->errors()], 422);
                }
            }
            if($request->get('status') == 1 && $request->get('is_verifying_otp') != 1){
                return response()->json(['message' => "this user can not be active without otp verify"], 400);
            }
            if ($request->has('nickname') && $request->get('nickname') != '') {
                if(User::where('id', '!=', $id)->where('nickname', $request->get('nickname'))->exists()){
                    return response()->json(['message' => "this nickname already taken"], 400);
                }
            }
            if ($request->has('phone') &&
                User::where('id', '!=', $id)->where('phone', $request->get('phone'))->exists()) {
                return response()->json(['message' => "this phone address already taken"], 400);
            }
            $query = $query->first();
            $status = $request->get('status');
            if ($query->status != 2 && $status == 2) {
                $query->status = $status;
                $query->phone = md5(mktime(true)) . $query->phone;
            }else{
                $query->phone = $request->get('phone');
            }
            $query->first_name = $request->get('first_name');
            $query->last_name = $request->get('last_name');
            $query->nickname = $request->has('nickname')?$request->get('nickname'):$query->nickname ;
            $query->birthday = $request->get('birthday');
            $query->marital_status = $request->has('marital_status')?$request->get('marital_status'):-1;
            if ($request->has('password')) {
                $query->password = bcrypt($request->get('password'));
            }
            if($query->image_id == 3){
                if(request()->hasFile('image')){
                    $image_id = FileLib::uploadImage($request->file('image'), 'user_profile');
                    if(!$image_id){
                        return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
                    }$query->image_id = $image_id;
                }
            }else{
                if(request()->hasFile('image')){
                    if($query->image_id == 11){
                        $old_image_id = null;
                    }else{
                        $old_image_id = $query->image_id;
                    }
                    $image_id = FileLib::uploadImage($request->file('image'), 'user_profile', $old_image_id);
                    if(!$image_id){
                        return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
                    }$query->image_id = $image_id;
                }
            }
            $query->status = $request->has('status') ? $request->get('status') : $query->status;
            $query->is_verifying_otp = $request->has('is_verifying_otp') ? $request->get('is_verifying_otp') : $query->is_verifying_otp;
            $query->check_police = $request->has('check_police') ? $request->get('check_police') : $query->check_police;
            $query->consultant_category_id = $request->get('consultant_category_id');
            $query->help_message_id = $request->has('help_message_id') ? $request->get('help_message_id') : $query->help_message_id;
            $query->location = $request->has('location') ? $request->get('location') : $query->location;
            if ($query->save()) {
                try {
                    if($query->status != 1){
                        $userTokens = DB::table('oauth_access_tokens')->where('user_id', $id);
                        if($userTokens->exists()) {
                            DB::table('oauth_refresh_tokens')
                                ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                                ->where('oauth_access_tokens.user_id', $id)->delete();
                            $userTokens->delete();
                        }
                        $userResetPassword = DB::table('password_resets')->where('phone', $query->phone);
                        if($userResetPassword->exists()) {
                            $userResetPassword->delete();
                        }
                    }
                } catch (\Exception $ex) { }
                try {
                    // refresh profile info
                    file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $id, env('APP_SOCKET_SECRET_KEY')),
                        false,
                        stream_context_create(self::arrContextOptions));
                } catch (\Exception $ex) { }
                return response()->json(['message' => $request->get('first_name') .
                    " " . $request->get('last_name'). " Successfully updated"], 200);
            }return response()->json(['message' => "Error updated"], 400);
        }
        return response()->json(['message' => "This user not found"], 404);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        if (Auth::user()->is_admin  && Auth::user()->is_super_admin) {
            $user = User::with(['records', 'consultant_request','emergencyServiceContacts',
                'sms', 'emergencyContacts','help_sms'=>function($q){
                    $q->where('verifying_type', 3);
                },'forum_comments'=>function($q){
                    $q->with(['forum'=>function($q){
                        $q->with(['translations'=>function($q){
                            $q->whereHas('language', function ($q){
                                $q->where('code', 'en');
                            });
                        }]);
                    }]);
                }])->where( 'id', $id);
            if($user->exists()){
                $user = $user->first();
                if($user->forum_comments()->exists()){
                    $forumTitles = Collect();
                    foreach ($user->forum_comments as $comment){
                        $forumTitles->push($comment->forum->translations[0]->title);
                    }
                    $forums = implode(', ',$forumTitles->toArray());
                    return response()->json(['message' => "You can not delete this user. He\She has comment(s) in ". $forums], 400);
                }
                if($user->help_sms()->exists()){
                    return response()->json(['message' => "You can not delete this user. He\She have help sms "], 400);
                }
                if($user->emergencyServiceContacts()->exists()){
                    $user->emergencyServiceContacts()->delete();
                }
                if($user->emergencyContacts()->exists()){
                    $user->emergencyContacts()->delete();
                }
                if($user->sms()->exists()){
                    $user->sms()->delete();
                }
                if($user->records()->exists()){
                    foreach ($user->records as $record){
                        $path = $record->url;
                        FileLib::deleteAudio($path);
                    }
                    $user->records()->delete();
                }
                if($user->consultant_request()->exists()){
                    $user->consultant_request()->delete();
                }
                $userTokens = DB::table('oauth_access_tokens')->where('user_id', $id);
                if($userTokens->exists()) {
                    DB::table('oauth_refresh_tokens')
                        ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                        ->where('oauth_access_tokens.user_id', $id)->delete();
                    $userTokens->delete();
                }
                $userResetPassword = DB::table('password_resets')->where('phone', $user->phone);
                if($userResetPassword->exists()) {
                    $userResetPassword->delete();
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

                if($user->delete()){
                    return response()->json(['message' => "Successfully deleted"], 200);
                }
                return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
            }
        }
        return response()->json(['message' => "Permission denied"], 403);
    }
    public function reject(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "status" => "required|in:2"
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $user = User::where('id', $id)
            ->where('is_consultant',1)
            ->where('role',4);
        if(!$user->exists()){
            return response()->json(['message' => "this Consultant not Found"], 400);
        }
        $user = $user->first();
        $consultant_category_id = $user->consultant_category_id;
        $user->is_consultant = 0;
        $user->role = 5;
        $user->email = null;
        $user->consultant_category_id = null;
        if($user->save()){
            $consultantRequest = ConsultantRequest::where('status', 1)
                ->where("user_id", $user->id)
                ->where("profession_consultant_service_category_id", $consultant_category_id);
        if($consultantRequest->exists()){
            $consultantRequest = $consultantRequest->first();
            $consultantRequest->status = 2;
            $consultantRequest->save();
        }
            try {
                // refresh profile info
                file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $id, env('APP_SOCKET_SECRET_KEY')));
            } catch (\Exception $ex) { }
            return response()->json(['message' => $user->first_name . " " . $user->first_name
                . "was successfully User"], 200);
        }
        return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }
}
