<?php

namespace App\Http\Controllers;

use App\Models\EmergencyService;
use App\Models\EmergencyServiceCategory;
use App\Models\EmergencyServiceCategoryTranslation;
use App\Models\Languages;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EmergencyServiceCategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $query = EmergencyServiceCategory::with(['translations'=>function($q){
            $q->with('language');
        }]);
        if ($query->exists()) {
            $query=$query->paginate(10);
            return response()->json($query, 200);
        }
        return response()->json(['message' => "Empty! Not Created"], 200);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
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
            "title" => "required|min:1|max:50|unique:emergency_service_categories,title",
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
        $query = new EmergencyServiceCategory();
        $query->title = $request->get("title");
        $query->status = $request->has("status")?$request->get("status"):0;
        if($query->save()){
            $emergencyServiceCategoryId = $query->id;
            foreach ($request->get("translations") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = new EmergencyServiceCategoryTranslation();
                    $query->emergency_service_category_id = $emergencyServiceCategoryId;
                    $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    $query->translation = $value;
                    $query->save();
                }
            }
            return response()->json(['message' => $request->get("title") .' Emergency Service Category successfully created'], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\EmergencyServiceCategory  $emergencyServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = EmergencyServiceCategory::with(['translations'=>function($q){
            $q->with('language');
        }])->where("id", $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This Emergency Service Category not found"], 404);
    }

    public function list(Request $request)
    {
        return response()->json(EmergencyServiceCategory::where('status',1)->pluck('title','id'), 200);
    }
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\EmergencyServiceCategory  $emergencyServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function edit(EmergencyServiceCategory $emergencyServiceCategory)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\EmergencyServiceCategory  $emergencyServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        if($request->has("status") && $request->get("status") == 0){
            $emergencyServices = EmergencyService::where('emergency_service_category_id', $id);
            if($emergencyServices->exists()){
                return response()->json(['message' => 'You can not deactivate this category, it is used by '.
                    implode(', ', $emergencyServices->pluck('title')->toArray())], 400);
            }
        }
        $validator = Validator::make($request->all(), [
            "translations.*" => "required|min:1",
            "title" => "required|min:1",
        ]);
        $languages = Languages::all();
        if($request->has("title")){
            $EmergencyServiceCategory = EmergencyServiceCategory::where('id', '!=', $id)->where('title', $request->get("title"));
            if($EmergencyServiceCategory->exists()){
                return response()->json(['message' => $EmergencyServiceCategory->value('title') . ' title already taken'], 400);
            }
        }
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
        $query = EmergencyServiceCategory::where('id', $id);
        if(!$query->exists()){
            return response()->json(['message' => "Not found this Emergency Service Category"], 400);
        }
        $query =  $query ->first();
        $query->title = $request->get("title");
        $query->status = $request->has("status")?$request->get("status"): $query->status;
        if($query->save()){
            $emergencyServiceCategoryId = $query->id;
            foreach ($request->get("translations") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = EmergencyServiceCategoryTranslation::where('emergency_service_category_id', $emergencyServiceCategoryId)
                        ->where('language_id', $languages->firstWhere('code', '==', $key)->id);
                    if(!$query->exists()){
                        $query = new EmergencyServiceCategoryTranslation();
                        $query->emergency_service_category_id = $emergencyServiceCategoryId;
                        $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    }else{
                        $query = $query->first();
                    }
                    $query->translation = $value;
                    $query->save();
                }
            }
            try {
                // refresh Category Name
                file_get_contents(sprintf("%s/api/category/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $id, env('APP_SOCKET_SECRET_KEY')));
            } catch (\Exception $ex) { }
            return response()->json(['message' => 'Emergency Service Category '.$request->get("title") .' successfully updated'], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\EmergencyServiceCategory  $emergencyServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $query = EmergencyServiceCategory::with(['translations'=>function($q){
            $q->with('language');
        }])->where("id", $id);
        if ($query->exists()) {
            if(EmergencyService::where('emergency_service_category_id', $id)->exists()){
                return response()->json(['message' => "This Emergency Service Category joined "
                    . implode(', ',EmergencyService::where('emergency_service_category_id', $id)->pluck('title')->toArray())], 400);
            }
            $query = $query->first();
            $translations = EmergencyServiceCategoryTranslation::where('emergency_service_category_id', $id);
            if($translations->delete() && $query->delete()){
                return response()->json(['message' => ' Emergency Service Category successfully deleted'],200);
            }
            return response()->json(['message' => ' Emergency Service Category not deleted'], 404);
        }
        return response()->json(['message' => "This Emergency Service Category not found"], 404);
    }
}
