<?php

namespace App\Http\Middleware;

use App\Models\Country;
use Illuminate\Auth\Middleware\Authenticate as Middleware;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return string
     */
    protected function redirectTo($request)
    {
        if(Country::where('short_code', $request->segments()[1])->exists()){
            $country = $request->segments()[1];
        }else{
            $country = 'arm';
        }
        if (! $request->expectsJson()) {
            return route('login', ['country'=>$country]);
        }
    }
}
