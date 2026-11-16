<?php

namespace App\Providers;

use App\Http\Validator\CustomValidationRule;
use Validator;
use Illuminate\Support\ServiceProvider;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
    private $availableCountries = [
        'arm',
        'geo'
    ];
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        if(isset(request()->segments()[0]) && isset(request()->segments()[1])){
            if (in_array(request()->segments()[1], $this->availableCountries)){
                if(isset(Config('database.connections')['mysql_'.request()->segments()[1]])){
                    Config(['database.default'=> 'mysql_'.request()->segments()[1]]);
                }else{
                    return abort(500, 'not currently configured database configuration ');
                }
            }else{
                return abort(403, 'this country is not supported');
            }
        }else{
           return redirect('/administrator/arm/');
        }
        Validator::resolver(function ($translator, $data, $rules, $messages) {
            return new CustomValidationRule($translator, $data, $rules, $messages);
        });
    }

}
