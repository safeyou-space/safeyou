<?php

namespace App\Http\Controllers;

use App\Models\HelpMessage;
use App\Models\HelpMessageTranslation;
use App\Models\Languages;
use App\Models\Setting;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class HelpMessageController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return response()->json(HelpMessage::with(['translations'=>function($q){
            $q->with('language');
        }])->paginate(10), 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            "translations.*" => "required|min:1|max:255",
            "translations" => "required|array",
            "message" => "required|min:1|max:50|unique:help_messages,message",
        ]);
        $languages = Languages::all();

        if($request->has("translations")){
            if($languages->count() == count($request->get("translations"))) {
                foreach ($request->get("translations") as $key => $value) {
                    if (!$languages->firstWhere('code', '==', $key)) {
                        return response()->json(['message' => $key . ' code not found in languages'], 422);
                    }
                }
            }else{
                return response()->json(['message' => "did not written translations for all languages"], 422);
            }
        }
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = new HelpMessage();
        $query->message = $request->get("message");
        $query->status = $request->has("status")?$request->get("status"):0;
        if($query->save()){
            $helpMessageId = $query->id;
            foreach ($request->get("translations") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = new HelpMessageTranslation();
                    $query->help_message_id = $helpMessageId;
                    $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    $query->translation = $value;
                    $query->save();
                }
            }
            return response()->json(['message' => $request->get("message") .' Help Message successfully created'], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);

    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\HelpMessage  $helpMessage
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = HelpMessage::with(['translations'=>function($q){
            $q->with('language');
        }])->where("id", $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This Help Message not found"], 404);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\HelpMessage  $helpMessage
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "translations.*" => "required|min:1",
            "message" => "required|min:1",
            "status" => "numeric|in:0,1",
        ]);
        $languages = Languages::all();
        if ($request->has("title")) {
            $HelpMessage = HelpMessage::where('id', '!=', $id)->where('message', $request->get("message"));
            if ($HelpMessage->exists()) {
                return response()->json(['message' => $HelpMessage->value('message') . ' help message already taken'], 400);
            }
        }
        if ($request->has("translations")) {
            if ($languages->count() == count($request->get("translations"))) {
                foreach ($request->get("translations") as $key => $value) {
                    if (!$languages->firstWhere('code', '==', $key)) {
                        return response()->json(['message' => $key . ' code not found in languages'], 422);
                    }
                }
            } else {
                return response()->json(['message' => "did not written translations for all languages"], 422);
            }
        }
        $Setting = Setting::where('key', 'default_help_message');
        if($Setting->exists()){
            if($request->has("status") && $request->get("status") == 0){
                $Setting_value = $Setting->value('value');
                if($Setting_value == $id){
                    return response()->json(['message' => "You can not disactivate this help message it is used default setting"], 400);
                }
            }
        }
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = HelpMessage::where('id', $id);
        if (!$query->exists()) {
            return response()->json(['message' => "Not found this Hep message"], 400);
        }
        $query = $query->first();
        $query->message = $request->get("message");
        $query->status = $request->has("status") ? $request->get("status") : $query->status;
        if ($query->save()) {
            $helpMessageId = $query->id;
            foreach ($request->get("translations") as $key => $value) {
                if ($languages->firstWhere('code', '==', $key)) {
                    $query = HelpMessageTranslation::where('help_message_id', $helpMessageId)
                        ->where('language_id', $languages->firstWhere('code', '==', $key)->id);
                    if (!$query->exists()) {
                        $query = new HelpMessageTranslation();
                        $query->help_message_id = $helpMessageId;
                        $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    } else {
                        $query = $query->first();
                    }
                    $query->translation = $value;
                    $query->save();
                }
            }
            $Setting = Setting::where('key', 'default_help_message')->where('value', $id);
            if($Setting->exists()){
                $Setting = $Setting->first();
                $Setting->title_value = $request->get("message");
                $Setting->save();
            }
            return response()->json(['message' => 'HelpMessage ' . $request->get("message") . ' successfully updated'], 200);
        }
        return response()->json(['message' => ["Please try again.", "Something went  wrong!"]], 400);
    }
        /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\HelpMessage  $helpMessage
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $query = HelpMessage::with(['translations'=>function($q){
            $q->with('language');
        }])->where("id", $id);
        if ($query->exists()) {
            $SettingHelpMessageId = Setting::where('key', 'default_help_message');
            if($SettingHelpMessageId->exists()){
                if($SettingHelpMessageId->value('value') == $id){
                    return response()->json(['message' => 'This Help message supported by default in settings'], 400);
                }
            }

            if(User::where('help_message_id', $id)->exists()){
                return response()->json(['message' => "This Help message used by "
                    . implode(', ',User::where('help_message_id', 1)->pluck('first_name')->toArray()) . ' user(s).'], 400);
            }
            $query = $query->first();
            $translations = HelpMessageTranslation::where('help_message_id', $id);
            if($translations->delete() && $query->delete()){
                return response()->json(['message' => 'Help message successfully deleted'],200);
            }
            return response()->json(['message' => 'This Help message not deleted'], 404);
        }
        return response()->json(['message' => "This Help message not found"], 404);
    }
    public function list(Request $request)
    {
        return response()->json(HelpMessage::pluck('message','id'), 200);
    }
}
