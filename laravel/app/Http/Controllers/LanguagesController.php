<?php

namespace App\Http\Controllers;

use App\Helpers\FileLib;
use App\Models\Contents;
use App\Models\ContentTranslations;
use App\Models\EmergencyServiceCategory;
use App\Models\Forums;
use App\Models\HelpMessage;
use App\Models\Languages;
use App\Models\ProfessionConsultantServiceCategory;
use App\Models\ProfessionConsultantServiceCategoryTranslation;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LanguagesController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return response()->json(Languages::with('image')->paginate(10), 200);
    }
    public function list()
    {
        return response()->json(Languages::with('image')->get(), 200);
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
            "title" => "required|min:2|unique:languages,title",
            "code" => "required|min:2|max:3|unique:languages,code",
            "image" => "required|mimes:jpeg,bmp,png,ico,icon,gif,tga|max:5120",
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = new Languages();
        $query->title = $request->get('title');
        $query->code = $request->get('code');
        $image_id = NULL;
        if(request()->hasFile('image')){
            $image_id = FileLib::uploadImage($request->file('image'), 'language_flag');
            if(!$image_id){
                return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
            }
        }
        $query->image_id = $image_id;
        $query->status = 0;
        if($query->save()){
            return response()->json(['message' => "This Language successfully created"], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Languages  $languages
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = Languages::with('image')->where("id", $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This Language not found"], 404);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Languages  $languages
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "title" => "required|min:2",
            "code" => "required|min:2|max:3",
            "image" => "mimes:jpeg,bmp,png,ico,icon,gif,tga|max:5120",
            "status" => "numeric|in:1,0",
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $Setting = Setting::where('key', 'default_support_language');
        if($Setting->exists()){
            if($request->has("status") && $request->get("status") == 0){
                $Setting_value = $Setting->value('value');
                if($Setting_value == $id){
                    return response()->json(['message' => "You can not disactivate this language"], 400);
                }
            }
        }
        $query = Languages::where("id", $id);
        if ($query->exists()) {
            $query = $query->first();
            if ($request->has('code')) {
                if (Languages::where('code', $request->get('code'))->where('id', '!=', $id)->exists()) {
                    return response()->json(['message' => "this code already exist"], 422);
                } else {
                    $query->code = $request->get('code');
                }
            }
            if ($request->has('title')) {
                if (Languages::where('title', $request->get('title'))->where('id', '!=', $id)->exists()) {
                    return response()->json(['message' => "this title already exist"], 422);
                } else {
                    $query->title = $request->get('title');
                }
            }
            if(request()->hasFile('image')){
                $image_id = FileLib::uploadImage($request->file('image'), 'language_flag');
                if(!$image_id){
                    return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
                }$query->image_id = $image_id;
            }
            if($request->has("status")) {
                if ($request->get("status") == 1) {

                    $contents = Contents::with('translations')->whereDoesntHave('translations', function ($q)use ($id){
                        $q->where('language_id', $id);
                    });
                    if($contents->exists()){
                        return response()->json(['message' => "You can not activate this language status,
                         because Content By " . implode(', ', $contents->pluck('title')->toArray()). " Title(s)"], 400);
                    }
                    $helpMessage = HelpMessage::with('translations')->whereDoesntHave('translations', function ($q)use ($id){
                        $q->where('language_id', $id);
                    })->where('status', 1);
                    if($helpMessage->exists()){
                        return response()->json(['message' => "You can not activate this language status,
                         because Help Message(s) By " . implode(', ', $helpMessage->pluck('message')->toArray()). " Message(s)"], 400);
                    }
                    $consultantServiceCategory = ProfessionConsultantServiceCategory::with('translations')->whereDoesntHave('translations', function ($q)use ($id){
                        $q->where('language_id',  $id);
                    })->where('status', 1);
                    if($consultantServiceCategory->exists()){
                        return response()->json(['message' => "You can not activate this language status,
                         because consultant category(ies) By " . implode(', ', $consultantServiceCategory->pluck('profession')->toArray()). " profession(s)"], 400);
                    }
                    $emergencyServiceCategory = EmergencyServiceCategory::with('translations')->whereDoesntHave('translations', function ($q)use ($id){
                        $q->where('language_id',  $id);
                    })->where('status', 1);
                    if($emergencyServiceCategory->exists()){
                        return response()->json(['message' => "You can not activate this language status,
                         because Emergency Service category(ies) By " .
                            implode(', ', $emergencyServiceCategory->pluck('title')->toArray()). " Title(s)"], 400);
                    }

                    $forums = Forums::with('translations')->whereDoesntHave('translations', function ($q)use ($id){
                        $q->where('language_id',  $id);
                    })->where('status', 1);
                    if($forums->exists()){
                        return response()->json(['message' => "You can not activate this language status,
                         because forum(s) By " . implode(', ', $forums->pluck('id')->toArray()). " id(s)"], 400);
                    }
                }
            }
            $query->status = $request->get('status');
            if ($query->save()) {
                $Setting = Setting::where('key', 'default_support_language')->where('value', $id);
                if($Setting->exists()){
                    $Setting = $Setting->first();
                    $Setting->title_value = $request->get("title");
                    $Setting->save();
                }
                return response()->json(['message' => "This Language successfully updated"], 200);
            }
        }
        return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Languages  $languages
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $query = Languages::where("id", $id);
        $Setting = Setting::where('key', 'default_support_language');
        if($Setting->exists()){
            $Setting = $Setting->first();
           if($Setting->value = $id){
               return response()->json(['message' => "This Language default supported Language,
                you can not delete this language"], 400);
           }
        }

        if ($query->exists()) {
            $query = $query->first();
            if($query->image_id){
                FileLib::delete_image($query->image_id);
            }
            $contentTranslations = ContentTranslations::where('language_id', $id);
            if($contentTranslations->exists()){
                $contentTranslations->delete();
            }
            if($query->delete()){
                return response()->json(['message' => "This Language successfully deleted"],200);
            }
            return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
        }
        return response()->json(['message' => "This Language not found"], 404);
    }
}
