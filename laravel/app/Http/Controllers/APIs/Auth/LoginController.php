<?php

namespace App\Http\Controllers\APIs\Auth;

use App\Http\Controllers\Controller;
use App\Models\Country;
use App\Models\HelpMessageTranslation;
use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Route;
use Illuminate\Validation\Rule;
use Laravel\Passport\Bridge\UserRepository;
use Laravel\Passport\Client;
use Laravel\Passport\Passport;
use Laravel\Passport\Token;
use Lcobucci\JWT\Parser;
use Lcobucci\JWT\Signer\Rsa\Sha256;
use Symfony\Component\Console\Descriptor\JsonDescriptor;
use function GuzzleHttp\json_decode;
use App\User;
use Illuminate\Support\Facades\Validator;


class LoginController extends Controller
{

    use IssueTokenTrait;

    private $client;

    public $role = [
        1 => 'admin',
        2 => 'moderator'
    ];

    public function __construct()
    {
        $this->client = Client::findOrFail(2);
    }

    public function login(Request $request)
    {
        $validation = Validator::make($request->all(), [
            'phone' => [
                'required',
                'phone',
                'min:9',
                'max:13'
            ],
            'password' => 'required'
        ]);

        if ($validation->fails()) {
            return response()->json(['message' => $validation->errors()->getMessages()], 400);
        }
        $user = User::where('phone', $request->get('phone'))
            ->where('role', ">", 3);
        if ($user->exists()) {
            $user = $user->first();
            if (Hash::check($request->get('password'), $user->password, [])) {
                if ($user->is_verifying_otp != 1) {
                    return response()->json(['message' => __("messages.verify_phone")], 202);
                }
                if ($user->status != 1) {
                    return response()->json(['message' => __("messages.inactive_user")], 403);
                }
            }
        } else {
            return response()->json(['message' => __("messages.credentials_incorrect")], 401);
        }
        $response = $this->issueToken($request, 'password');
        if ($response->status() == 200) {
            $content = $response->content();
            $content = json_decode($content);
            if (isset($user)) {
                if(DB::table('oauth_access_tokens')->where('user_id', $user->id)->count() > 1){
                    $accessToken = DB::table('oauth_access_tokens')->where('user_id', $user->id)
                        ->orderBy('created_at','desc')->limit(1)->get()[0]->id;
                    $userTokens = DB::table('oauth_access_tokens')->where('user_id', $user->id)
                    ->where('id', '!=', $accessToken);
                    if($userTokens->exists()) {
                        DB::table('oauth_refresh_tokens')
                            ->join('oauth_access_tokens', 'oauth_access_tokens.id', '=','oauth_refresh_tokens.access_token_id' )
                            ->where('oauth_access_tokens.user_id', $user->id)->where('oauth_access_tokens.id', '!=', $accessToken)
                            ->delete();
                        $userTokens->delete();
                    }
                }

                if($request->has('device_token') && strlen($request->get('device_token')) > 10 &&
                    strlen($request->get('device_token')) < 256){
                    $user->device_token = $request->get('device_token');
                    $user->device_type = $this->getDeviceType($request);
                    $user->save();
                }
                $content->id = $user->id;
                $content->first_name = $user->first_name;
                $content->last_name = $user->last_name;
                $content->nickname = $user->nickname;
                $content->email = $user->email;
                $content->phone = $user->phone;
                $content->check_police = $user->check_police;
                $content->birthday = $user->birthday;
                $content->help_message = HelpMessageTranslation::whereHas('language', function ($q){
                    $q->where('code', app()->getLocale());
                })
                    ->where('help_message_id', $user->help_message_id)->value('translation');;
                $content->image = $user->image->url;
                $contentJson = json_encode($content);
                $response->setContent($contentJson);
            }
        }
        return $response;
    }

    public function login_admin(Request $request)
    {
        $validation = Validator::make($request->all(), [
            'username' => 'required',
            'password' => 'required'
        ]);
        if ($validation->fails()) {
            return response()->json(['message' => $validation->errors()->getMessages()], 400);
        }
        if ($request->get('username') == env('SUPER_ADMIN_USER_NAME')
            && $request->get('password') == env('SUPER_ADMIN_USER_PASSWORD')) {
            return $this->super_admin_login($request);
        }
        $user = User::where('email', $request->get('username'))
            ->orWhere('phone', $request->get('username'))->where('role', '>', 0)->where('role', '<', 4);
        if ($user->exists()) {
            $user_status = $user->value('status');
            if ($user_status != 1) {
                return response()->json(['message' => 'This profile inactive'], 400);
            }
            $user = User::where('email', $request->get('username'))
                ->orWhere('phone', $request->get('username'))->where('role', '>', 0)->where('role', '<', 4);
            $user = $user->first();
        } else {
            return response()->json(['message' => 'The user credentials were incorrect.'], 400);
        }
        $response = $this->issueToken($request, 'password');
        if ($response->status() == 200) {
            $content = $response->content();
            $content = json_decode($content);
            if ($user) {
                $content->user_id = $user->id;
                $content->first_name = $user->first_name;
                $content->last_name = $user->last_name;
                $content->email = $user->email;
                $content->image = Image::where('id', $user->image_id)->value('url');
                $content->is_admin = $user->is_admin;
//                $content->nickname = $user->nickname;
//                $content->birthday = $user->birthday;
                $content->status = $user->status;
                if (array_key_exists(strtolower($user->role), User::ACCESS)) {
                    $content->access = User::getViewAccess($user->role);
                }
                $contentJson = json_encode($content);
                $response->setContent($contentJson);
            }
        }
        return $response;

    }

    private function super_admin_login(Request $request)
    {
        $user = User::where('email', $request->get('username'))->where('is_super_admin', 1);
        if ($user->exists()) {
            $user_status = $user->value('status');
            if ($user_status != 1) {
                return response()->json(['message' => 'This profile inactive'], 400);
            }
            $user = $user->first();
        } else {
            return response()->json(['message' => 'The user credentials were incorrect.'], 400);
        }
        $response = $this->issueToken($request, 'password');
        if ($response->status() == 200) {
            $content = $response->content();
            $content = json_decode($content);
            if ($user) {
                $this->loginSuperAdminToAvailableDB($user->id);
                $content->user_id = $user->id;
                $content->first_name = $user->first_name;
                $content->last_name = $user->last_name;
                $content->email = $user->email;
                $content->image = Image::where('id', $user->image_id)->value('url');
                $content->countries = Country::where('status', 1)->pluck('name', 'short_code');
                $content->used_country_code = $request->segments()[1];
                $content->is_super_admin = $user->is_super_admin;
                $content->status = $user->status;
                $content->role = $user->role;
                $contentJson = json_encode($content);
                $response->setContent($contentJson);
            }
        }
        return $response;

    }

    public function loginSuperAdminToAvailableDB($user_id)
    {
        $oauth_access_tokens = DB::table('oauth_access_tokens')->where('user_id', $user_id)
            ->orderBy('created_at', 'desc')->limit(1)->first();
        $oauth_refresh_tokens = DB::table('oauth_refresh_tokens')
            ->where('access_token_id', $oauth_access_tokens->id)->limit(1)->first();
        $countries = Country::where('status', 1)->pluck('short_code');
        foreach ($countries as $country) {
            if (Config('database.default') != 'mysql_' . $country) {
                if (config('database.connections.mysql_' . $country)) {
                    DB::connection('mysql_' . $country)->table('oauth_access_tokens')
                        ->insert((array)$oauth_access_tokens);
                    DB::connection('mysql_' . $country)->table('oauth_refresh_tokens')
                        ->insert((array)$oauth_refresh_tokens);
                }
            }
        }
    }

    public function logoutSuperAdminToAvailableDB($user_id)
    {
        $oauth_access_tokens = DB::table('oauth_access_tokens')->where('user_id', $user_id)
            ->orderBy('created_at', 'desc')->limit(1)->first();
        $countries = Country::where('status', 1)->pluck('short_code');
        foreach ($countries as $country) {
            if (config('database.connections.mysql_' . $country)) {
                DB::connection('mysql_' . $country)->table('oauth_refresh_tokens')
                    ->where('access_token_id', $oauth_access_tokens->id)
                    ->delete();

                DB::connection('mysql_' . $country)->table('oauth_access_tokens')
                    ->where('user_id', $user_id)
                    ->delete();

            }
        }
    }

    public function parseToken($accessToken)
    {
        $key_path = Passport::keyPath('oauth-public.key');
        $parseTokenKey = file_get_contents($key_path);

        $token = (new Parser())->parse((string) $accessToken);

        $signer = new Sha256();

        if ($token->verify($signer, $parseTokenKey)) {
            $userId = $token->getClaim('sub');
            return User::find($userId);
        } else {
            return false;
        }
    }
    public function parseTokenGetTokenId($accessToken)
    {
        $key_path = Passport::keyPath('oauth-public.key');
        $parseTokenKey = file_get_contents($key_path);

        $token = (new Parser())->parse((string) $accessToken);

        $signer = new Sha256();

        if ($token->verify($signer, $parseTokenKey)) {
            return $token->getClaim('jti');
        } else {
            return false;
        }
    }
    public function refresh(Request $request)
    {
        $this->validate($request, [
            'refresh_token' => 'required'
        ]);
        $response = $this->issueToken($request, 'refresh_token');
        if ($response->status() == 200) {
            $content = $response->content();
            $content = json_decode($content);
            $user = $this->parseToken($content->access_token);
            if ($user) {
                if($user->is_super_admin === false){
                    if(array_search($user->role, User::ROLES) > 3){
                        if($user->is_verifying_otp != 1){
                            $accessTokenId = $this->parseTokenGetTokenId($content->access_token);
                            if($accessTokenId){
                                DB::table('oauth_refresh_tokens')
                                    ->where('access_token_id', $accessTokenId)
                                    ->update(['revoked' => true]);
                                DB::table('oauth_access_tokens')->where('id', $accessTokenId)->delete();
                            }
                            return response()->json(['message' => __("messages.verify_phone")], 202);
                        }
                    }
                    if($user->status != 1){
                        $accessTokenId = $this->parseTokenGetTokenId($content->access_token);
                        if($accessTokenId){
                            DB::table('oauth_refresh_tokens')
                                ->where('access_token_id', $accessTokenId)
                                ->update(['revoked' => true]);

                            DB::table('oauth_access_tokens')->where('id', $accessTokenId)->delete();
                        }
                        return response()->json(['message' => __("messages.inactive_user")], 403);
                    }
                }
                $content->id = $user->id;
                $content->first_name = $user->first_name;
                $content->last_name = $user->last_name;
                $content->nickname = $user->nickname;
                $content->email = $user->email;
                $content->phone = $user->phone;
                $content->check_police = $user->check_police;
                $content->birthday = $user->birthday;
                $content->help_message = HelpMessageTranslation::whereHas('language', function ($q){
                    $q->where('code', app()->getLocale());
                })
                    ->where('help_message_id', $user->help_message_id)->value('translation');;
                $content->image = Image::where('id', $user->image_id)->value('url');
                $contentJson = json_encode($content);
                $response->setContent($contentJson);
            }else{
                return response()->json(['message' => __("messages.not_found")], 400);
            }
        }
        return $response;
    }
    public function admin_refresh(Request $request)
    {
        $this->validate($request, [
            'refresh_token' => 'required'
        ]);
        $response = $this->issueToken($request, 'refresh_token');
        if ($response->status() == 200) {
            $content = $response->content();
            $content = json_decode($content);
            $user = $this->parseToken($content->access_token);
            if ($user) {
                if($user->is_super_admin === false){
                    if(array_search($user->role, User::ROLES) < 3){
                        if($user->status != 1){
                            $accessTokenId = $this->parseTokenGetTokenId($content->access_token);
                            if($accessTokenId){
                                DB::table('oauth_refresh_tokens')
                                    ->where('access_token_id', $accessTokenId)
                                    ->update(['revoked' => true]);

                                DB::table('oauth_access_tokens')->where('id', $accessTokenId)->delete();
                            }
                            return response()->json(['message' => __("messages.inactive_user")], 403);
                        }
                    }
                }
                $content->id = $user->id;
                $content->first_name = $user->first_name;
                $content->last_name = $user->last_name;
                $content->nickname = $user->nickname;
                $content->email = $user->email;
                $content->phone = $user->phone;
                $content->image = Image::where('id', $user->image_id)->value('url');
                $content->countries = Country::where('status', 1)->pluck('name', 'short_code');
                $content->used_country_code = $request->segments()[1];
                $content->is_super_admin = $user->is_super_admin;
                $content->status = $user->status;
                $content->role = $user->role;
                $content->is_admin = $user->is_admin;
                $content->status = $user->status;
                if (array_key_exists(strtolower($user->role), User::ACCESS)) {
                    $content->access = User::getViewAccess($user->role);
                }
                $contentJson = json_encode($content);
                $response->setContent($contentJson);
            }else{
                return response()->json(['message' => __("messages.not_found")], 400);
            }
        }
        return $response;
    }
    public function logout(Request $request)
    {
        if (Auth::user()->is_super_admin === true) {
            $this->logoutSuperAdminToAvailableDB(Auth::user()->id);
            return response()->json(['message' => __('messages.successful_logout')], 200);
        }
        if(User::where('id', Auth::user()->id)->where('status', 1)->where('role', '<', '4')->exists()){
            $this->admin_panel_logout($request);
            return response()->json(['message' => __('messages.successful_logout')], 200);
        }
        $accessToken = Auth::user()->token();
        DB::table('oauth_refresh_tokens')
            ->where('access_token_id', $accessToken->id)
            ->update(['revoked' => true]);

        DB::table('oauth_access_tokens')->where('id', $accessToken->id)->delete();
        $accessToken->revoke();
        $user = User::where('id', Auth::user()->id)->whereNotNull('device_token');
        if($user->exists()){
            $user = $user->first();
            $user-> device_token = null;
            $user->save();
        }
        return response()->json(['message' => __('messages.successful_logout')], 200);
    }
    public function admin_panel_logout(Request $request)
    {
        $accessToken = Auth::user()->token();
        DB::table('oauth_refresh_tokens')
            ->where('access_token_id', $accessToken->id)
            ->update(['revoked' => true]);
        $accessToken->revoke();
    }
    public function getDeviceType(Request $request)
    {
        if($request->has('device_type')){
            if($request->get('device_type') == 'android'){
                return 1;
            }
            if($request->get('device_type') == 'ios'){
                return 2;
            }
        }
        return null;
    }
}
