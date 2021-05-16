<?php
namespace App\Http\Controllers;

use App\Models\EmergencyService;
use App\Models\EmergencyServiceCategory;
use App\Models\Forums;
use App\Models\Image;
use App\Models\ProfessionConsultantServiceCategory;
use App\Models\Sms;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Helpers\FileLib;
class AdminController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $query = User::with('image')
            ->orderBy('created_at', 'desc')->whereIn('role',[1,2]);

        if ($query->exists()) {
            $query = $query->paginate(10);
            return response()->json($query, 200);
        }
        return response()->json(['message' => "Not found"], 200);
    }

    public function test(Request $request)
    {
        $validator = Validator::make($request->all(), [
//            'email' => 'required',
            'phone' => 'required|phone|min:12|max:13',
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        dd("afds");
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        if (User::where('email', $request->get('email'))->exists()) {
            return response()->json(['message' => "this Email Address already taken"], 400);
        }
        $validator = Validator::make($request->all(), [
            "first_name" => "required|min:3|max:250",
            "last_name" => "required|min:3|max:250",
            'email' => 'required|unique:users,email',
            'phone' => 'required|phone|min:9|max:13|unique:users,phone',
            'password' => 'required|min:8|confirmed',
            "status" => "numeric|in:1,0",
            "image" => "mimes:jpeg,bmp,png,gif|max:5120",
            "role" => "required|in:administrator,moderator",
        ]);
        if($request->has('email') && ($request->get('email') != '')){
            if(!filter_var($request->get('email'), FILTER_VALIDATE_EMAIL)){
                return response()->json(['message' => ["Invalid email address"]], 400);
            }
        }
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $user = new User();
        $user->first_name = $request->get('first_name');
        $user->last_name = $request->get('last_name');
        $user->email = $request->get('email');
        $user->phone = $request->get('phone');
        $user->password = bcrypt($request->get('password'));
        $user->status = $request->has('status') ? $request->get('status') : 0;
        $user->role = self::access_type[$request->get('role')];
        $user->is_admin = ($request->get('role') == "administrator")? 1 : 0;
        if(request()->hasFile('image')){
            $image_id = FileLib::uploadImage($request->file('image'), 'admin_profile');
            if(!$image_id){
                return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
            }
        } else {
            $image_id = 1;
        }
        $user->image_id = $image_id;
        if ($user->save()) {
            return response()->json(['message' => "Successfully created"], 200);
        }
        return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = User::with('image')->where('id', $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This User Not found"], 200);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
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
        if (!Auth::user()->is_admin || !Auth::user()->is_super_admin ) {
            return response()->json(['message' => "Access denied"], 403);
        }elseif (Auth::user()->id == $id && $request->get('status') == 0) {
            return response()->json(['message' => "You Cannot deactivate yourself"], 400);
        }
        $validator = Validator::make($request->all(), [
            "first_name" => "required|min:3|max:250",
            "last_name" => "required|min:3|max:250",
            'email' => 'required',
            'phone' => 'required|phone|min:9|max:13',
            'password' => 'min:8|confirmed',
            "status" => "numeric|in:1,0",
            "image" => "mimes:jpeg,bmp,png,gif|max:5120",
            "role" => "required|in:administrator,moderator"
        ]);
        $user = User::where('id', $id);
        if ($user->exists()) {
            if ($validator->fails()) {
                return response()->json(['message' => $validator->errors()], 422);
            }

            if ($request->has('email') && User::where('id', '!=', $id)->where('email', $request->get('email'))->exists()) {
                return response()->json(['message' => "This Email Address already Taken"], 400);
            }
            if ($request->has('phone') && User::where('id', '!=', $id)->where('phone', $request->get('phone'))->exists()) {
                return response()->json(['message' => "this phone address already taken"], 400);
            }

            $user = $user->first();
            $user->first_name = $request->get('first_name');
            $user->last_name = $request->get('last_name');
            $user->email = $request->get('email');
            $user->is_admin = $user->is_admin = ($request->get('role') == "administrator")? 1 : 0;;
            $user->phone = $request->get('phone');
            $user->role = self::access_type[$request->get('role')];
            if ($request->has('password')) {
                $user->password = bcrypt($request->get('password'));
            }
            if(request()->hasFile('image')){
                $image_id = FileLib::uploadImage($request->file('image'), 'admin_profile');
                if(!$image_id){
                    return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
                }
                $user->image_id = $image_id;
            }
            $user->status = $request->has('status') ? $request->get('status') : $user->status;
            if ($user->save()) {
                try {
                    // refresh profile info
                    file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $id, env('APP_SOCKET_SECRET_KEY')));
                } catch (\Exception $ex) { }
                if($user->status != 1){
                    $userTokens = DB::table('oauth_access_tokens')->where('user_id', $id);
                    if($userTokens->exists()) {
                        DB::table('oauth_refresh_tokens')
                            ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                            ->where('oauth_access_tokens.user_id', $id)->delete();
                        $userTokens->delete();
                    }
                }
                return response()->json(['message' => "This User Successfully updated"], 200);
            }
        }
        return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        if ((Auth::user()->is_admin  && Auth::user()->is_super_admin) && $id != 1
            && (User::where('id', Auth::user()->id)->value('id') != $id)) {
            $user = User::with(['forum_comments'=>function($q){
                $q->with(['forum'=>function($q){
                    $q->with(['translations'=>function($q){
                        $q->whereHas('language', function ($q){
                            $q->where('code', 'en');
                    });
                    }]);
                    }]);
            }])
                ->where( 'id', $id);
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
                if($user->image_id) {
                    $Image = Image::where('id', $user->image_id);
                    if ($Image->exists()) {
                        $Image = $Image->first();
                        if ($Image->id != 1) {
                            if (file_exists(public_path($Image->url))) {
                                unlink(public_path($Image->url));
                            }
                            $Image->delete();
                        }
                    }
                }
                if($user->delete()){
                    $userTokens = DB::table('oauth_access_tokens')->where('user_id', $id);
                    if($userTokens->exists()) {
                        DB::table('oauth_refresh_tokens')
                            ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                            ->where('oauth_access_tokens.user_id', $id)->delete();
                        $userTokens->delete();
                    }
                    return response()->json(['message' => "Successfully deleted"], 200);
                }
                return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
            }
        }
        return response()->json(['message' => "Permission denied"], 403);
    }
    public function dashboard(Request $request, $code){
        if($request->has('year')){
            $year = (int)$request->get('year');
        }else{
            $year = date("Y");
        }
        $sms = Sms::select('id', 'created_at')
            ->where('verifying_type', 3)
            ->whereYear('created_at', $year)
            ->get()
            ->groupBy(function($date) {
                //return Carbon::parse($date->created_at)->format('Y'); // grouping by years
                return Carbon::parse($date->created_at)->format('m'); // grouping by months
            });
        $users = User::select('id', 'created_at')
            ->whereYear('created_at', $year)
            ->get()
            ->groupBy(function($date) {
                //return Carbon::parse($date->created_at)->format('Y'); // grouping by years
                return Carbon::parse($date->created_at)->format('m'); // grouping by months
            });

        $usermcount = [];
        $smsmcount = [];
        $smsArr = [];
        $userArr = [];

        foreach ($sms as $key => $value) {
            $smsmcount[(int)$key] = count($value);
        }

        for($i = 1; $i <= 12; $i++){
            if(!empty($smsmcount[$i])){
                $smsArr[$i] = $smsmcount[$i];
            }else{
                $smsArr[$i] = 0;
            }
        }
        foreach ($users as $key => $value) {
            $usermcount[(int)$key] = count($value);
        }

        for($i = 1; $i <= 12; $i++){
            if(!empty($usermcount[$i])){
                $userArr[$i] = $usermcount[$i];
            }else{
                $userArr[$i] = 0;
            }
        }
       return response()->json(
           [
           'users'=>[
                'active'=>User::where('status', 1)->where('role', 5)->count(),
                'inactive'=>User::where('status', 0)->where('role', 5)->count(),
                'blocked'=>User::where('status', 2)->where('role', 5)->count(),
                ],

                'emergencies'=>[
                'active'=>EmergencyService::where('status', 1)->count(),
                'inactive'=>EmergencyService::where('status', 0)->count(),
            ],
               'forums'=>[
                   'active'=>Forums::where('status', 1)->count(),
                   'inactive'=>Forums::where('status', 0)->count(),
               ],
                'network_categories'=>[
                'active'=>EmergencyServiceCategory::where('status', 1)->count(),
                'inactive'=>EmergencyServiceCategory::where('status', 0)->count(),
            ],
                'consultants'=>[
                'active'=>User::where('status', 1)->where('role', 4)->count(),
                'inactive'=>User::where('status', 0)->where('role', 4)->count(),
            ],
                'consultant_categories'=>
                    [
                'active'=>ProfessionConsultantServiceCategory::where('status', 1)->count(),
                'inactive'=>ProfessionConsultantServiceCategory::where('status', 0)->count(),
            ],
                'sms'=>[
                'verifies'=>Sms::whereIn('verifying_type', [1,2])->count(),
                'help'=>Sms::where('verifying_type', 3)->count(),
            ],
               'reg_users_by_month'=>$userArr,
               'help_messages'=>$smsArr
        ], 200);
    }
}
