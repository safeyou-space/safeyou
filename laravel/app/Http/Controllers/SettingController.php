<?php

namespace App\Http\Controllers;

use App\Models\HelpMessage;
use App\Models\Languages;
use App\Models\Setting;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SettingController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $default_support_language = Setting::where('key', 'default_support_language');
        $default_help_message = Setting::where('key', 'default_help_message');
        $police_phone_number = Setting::where('key', 'police_phone_number');
        $responseData = [];
        if($default_support_language->exists()){
            $responseData['default_support_language'] = $default_support_language->get();
        }
        if($default_help_message->exists()){
            $responseData['default_help_message'] = $default_help_message->get();
        }
        if($police_phone_number->exists()){
            $responseData['police_phone_number'] = $police_phone_number->get();
        }
        if($responseData == []){
            return response()->json(['message' => 'Empty not found setting'], 200);
        }
        return  response()->json($responseData, 200);
    }


    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function getByKey(Request $request, $code, $key)
    {
        $setting = Setting::where('key',$key);
        if($setting->exists()){
            $setting = $setting->first();
            if($key == 'default_support_language'){
                $Languages = Languages::where('status', 1);
                if(!$Languages->exists()){
                    return response()->json(['message' => 'not found Active Language please activate'], 400);
                }
                return response()->json(["setting"=>$setting, 'languages'=>$Languages->get()], 200);
            }
            if($key == 'police_phone_number'){
                return response()->json(["setting"=>$setting], 200);
            }
            if($key == 'default_help_message'){
                $help_messag = HelpMessage::where('status', 1);
                if(!$help_messag->exists()){
                    return response()->json(['message' => 'not found Active Help Message please activate'], 400);
                }
                return response()->json(["setting"=>$setting, 'help_messages'=>$help_messag->get()], 200);
            }
        }
        return response()->json(['message' => 'not found this setting'], 400);
    }

    public function setByKey(Request $request, $code, $key)
    {
        $setting = Setting::where('key',$key);
        if($setting->exists()){
            $setting = $setting->first();
            if($key == 'default_support_language'){
                $Languages = Languages::where('status', 1)->where('id', $request->get('value'));
                if(!$Languages->exists()){
                    return response()->json(['message' => 'Not found or not  Active Language please activate'], 400);
                }
                $setting->title_value = $Languages->value('title');
                $setting->value = $request->get('value');
                $setting->description = $request->get('description');
                $setting->status = $request->has('status')?$request->get('status'):$setting->status;
                if($setting->save()){
                    return response()->json(['message' => 'Setting '.$setting->title_key .' successfully updated'], 200);
                }
                return response()->json([$setting, 'languages'=>$Languages->get()], 200);
            }
            if($key == 'default_help_message'){
                $help_message = HelpMessage::where('status', 1)->where('id', $request->get('value'));
                if(!$help_message->exists()){
                    return response()->json(['message' => 'Not found or not Active Help Message please activate'], 400);
                }
                $setting->title_value = $help_message->first()->message;
                $setting->value = $request->get('value');
                $setting->description = $request->get('description');
                $setting->status = $request->has('status')?$request->get('status'):$setting->status;
                if($setting->save()){
                    User::whereNotNull('help_message_id')->update(['help_message_id'=>$setting->value]);
                    return response()->json(['message' => 'Setting '.$setting->title_key .' successfully updated'], 200);
                }
            }
            if($key == 'police_phone_number'){
                $validator = Validator::make($request->all(), [
                    'value' => 'required|phone|min:12|max:13',
                ]);
                if ($validator->fails()) {
                    return response()->json(['message' => $validator->errors()], 422);
                }
                $setting->title_value = "Phone Number of Police : ". $request->get('value');
                $setting->value = $request->get('value');
                $setting->description = $request->get('description');
                $setting->status = $request->has('status')?$request->get('status'):$setting->status;
                if($setting->save()){
                    return response()->json(['message' => 'Setting '.$setting->title_key .' successfully updated'], 200);
                }
            }
            return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
        }
        return response()->json(['message' => 'not found this setting'], 400);
    }
}
