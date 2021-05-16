<?php
namespace App\Http\Validator;

use Illuminate\Support\Facades\Request;

class CustomValidationRule extends \Illuminate\Validation\Validator
{

    public function validatePhone($attribute, $value, $parameters)
    {
        if(request()->segments()[1] == 'arm'){
             return preg_match("/(^\+?+374)([0-9]{2})([0-9]{6})/", $value);
        }
        if(request()->segments()[1] == 'geo'){
            return preg_match("/(^\+?+995)([0-9]{3})([0-9]{6,7})/", $value);
        }
    }

    public function validateMobile($attribute, $value, $parameters)
    {
        // Mobile number can start with plus sign and should start with number
        // and can have minus sign and should be between 9 to 12 character long.
        return preg_match("/^\+?\d[0-9-]{9,12}/", $value);
    }

    public function validateCsv($attribute, $value, $parameters)
    {
        // Valide comman separated value.
        return preg_match("/[A-Za-z0-9\s]+(,[A-Za-z0-9\s]+)*[A-Za-z0-9]$/", $value);
    }

    public function validateMonthYear($attribute, $value, $parameters)
    {
        // Can have 3 letter month name as string followed by 4 letter year
        // number.
        return preg_match("/^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sept|Oct|Nov|Dec)-[0-9]{4}$/i", $value);
    }
}
