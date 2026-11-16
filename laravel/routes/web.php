<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
Route::prefix('administrator')->group(function () {
    Route::group([
        'prefix' => '{country}',
        'where' => ['country' => '[a-zA-Z]{3}']
    ], function () {
        if(isset(request()->segments()[1])){
            Route::get('/{s1?}/{s2?}/{s3?}/{s4?}', function () {
                $country = request()->segments()[1];
                if(\App\Models\Country::where('short_code', $country)->exists()){
                    return response()->file(public_path() . '/dist/index.html',
                        ['Content-Type' => 'text/html; charset=UTF-8']);
                }
                return view('errors.404');
            });

        }
    });
});

Route::get('password/email', 'APIs\Auth\ForgotPassword@forgot_password');

Route::get('/help/{country}/{any}', function ($country,$any) {
    if(\App\Models\Sms::where('uri', $any)->exists()){
        return response()->file(public_path() . '/dist/index.html',
            ['Content-Type' => 'text/html; charset=UTF-8']);
    } return view('errors.404');
})->where(['country' => '[a-z]{3}','any' => '[a-zA-Z0-9]+']);
Route::get('/{any?}', function () {
    return response()->file(public_path() . '/dist/index.html',
        ['Content-Type' => 'text/html; charset=UTF-8']);
});
