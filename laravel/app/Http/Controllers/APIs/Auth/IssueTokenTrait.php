<?php 

namespace App\Http\Controllers\APIs\Auth;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

trait IssueTokenTrait{

	public function issueToken(Request $request, $grantType, $scope = "") {

		$params = [
    		'grant_type' => $grantType,
    		'client_id' => $this->client->id,
    		'client_secret' => $this->client->secret,    		
    		'scope' => $scope,
            'username' => $request->phone
    	];

        if($grantType !== 'social'){
            $params['username'] = $request->username ?: $request->email;

        }
        if($grantType == 'password'){
            $params['username'] = $request->username ?: $request->phone;

        }

    	$request->request->add($params);

		$proxy = Request::create('oauth/token', 'POST');

    	return Route::dispatch($proxy);

	}

}
