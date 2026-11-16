<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 22.04.2019
 * Time: 11:53
 */

namespace App\Http\Controllers\APIs\Auth;

use App\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Passport\Client;

class ResetPassword extends Controller
{
    use IssueTokenTrait;
    private $client;

    public function __construct()
    {
        $this->client = Client::find(2);
    }

    public function reset(Request $request, $countryCode)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'old_password' => 'required|min:6',
            'password' => 'required|min:6',
            'confirm_password' => 'required|min:6|same:password',
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $user = User::where('email', $request->get('email'));
        if ($user->exists()) {
            $user = $user->first();
            if (Hash::check($request->get('old_password'), $user->password)) {
                $user->password = bcrypt($request->get('password'));
                if ($user->save()) {
                    $response = $this->issueToken($request, 'password');

                    if ($response->status() == 200) {
                        $content = $response->content();
                        $content = json_decode($content);
                        $content->id = $user->id;
                        $contentJson = json_encode($content);
                        $response->setContent($contentJson);


                    }
                    return $response;
                }
            }
        }
        return response()->json(['message' => 'Your email or password is incorrect. Please try again'], 400);
    }


}
