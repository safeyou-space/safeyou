<?php

namespace App\Http\Middleware;

use App\User;
use Closure;
use Illuminate\Support\Facades\Auth;

class CheckAccess
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    private $access;
    public function handle($request, Closure $next)
    {
        $this->access = User::ACCESS;
        if(Auth::check()){
            if(Auth::user()->is_super_admin == "true" ||  Auth::user()->is_admin == "true"){
                return $next($request);
            }
            preg_match('/([a-z]*)@/i', $request->route()->getActionName(), $matches);
            $controllerName = $matches[1];
            $routeName = $request->route()->getName();
            $method = $request->route()->getActionMethod();
            if($routeName && $controllerName && $method &&
                array_key_exists(strtolower(Auth::user()->role),$this->access)){

                if(in_array($routeName, $this->access[strtolower(Auth::user()->role)])){
                    return $next($request);
                }else{
                    return response()->json(['message'=>"You don't have permission."], 403);
                }
            }
            return response()->json(['message'=>"Access denied"], 403);
        }
        return response()->json(['message'=>"Unauthenticated"], 401);
    }
}
