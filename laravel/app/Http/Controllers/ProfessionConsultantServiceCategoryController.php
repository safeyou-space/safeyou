<?php

namespace App\Http\Controllers;

use App\Models\ConsultantRequest;
use App\Models\Languages;
use App\Models\ProfessionConsultantServiceCategory;
use App\Models\ProfessionConsultantServiceCategoryTranslation;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProfessionConsultantServiceCategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $query = ProfessionConsultantServiceCategory::with(['translations'=>function($q){
            $q->with('language');
        }]);
        if ($query->exists()) {
            $query=$query->paginate(10);
            return response()->json($query, 200);
        }
        return response()->json(['message' => "Empty! Not Created"], 200);

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
            "profession" => "required|min:1|max:50|unique:profession_consultant_service_categories,profession",
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
        $query = new ProfessionConsultantServiceCategory();
        $query->profession = $request->get("profession");
        $query->status = $request->has("status")?$request->get("status"):0;
        if($query->save()){
            $professionConsultantServiceCategoryId = $query->id;
            foreach ($request->get("translations") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = new ProfessionConsultantServiceCategoryTranslation();
                    $query->profession_consultant_service_category_id = $professionConsultantServiceCategoryId;
                    $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    $query->translation = $value;
                    $query->save();
                }
            }
            return response()->json(['message' => $request->get("profession") .' Profession Consultant Category successfully created', 'category_id'=>$professionConsultantServiceCategoryId], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ProfessionConsultantServiceCategory  $professionConsultantServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = ProfessionConsultantServiceCategory::with(['translations'=>function($q){
            $q->with('language');
        }])->where("id", $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This Profession-Consultant Service Category not found"], 404);
    }

    public function list(Request $request)
    {
        return response()->json(ProfessionConsultantServiceCategory::where('status',1)->pluck('profession','id'), 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\ProfessionConsultantServiceCategory  $professionConsultantServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        if($request->has("status") && $request->get("status") == 0){
            $users = User::where('consultant_category_id', $id);
            if($users->exists()){
                return response()->json(['message' => 'You can not deactivate this category, it is used by '.
                implode(', ', $users->pluck('first_name')->toArray())], 400);
            }
        }
        $validator = Validator::make($request->all(), [
            "translations.*" => "required|min:1",
            "profession" => "required|min:1",
        ]);
        $languages = Languages::all();
        if($request->has("profession")){
            $ProfessionConsultantServiceCategory = ProfessionConsultantServiceCategory::where('id', '!=', $id)->where('profession', $request->get("profession"));
            if($ProfessionConsultantServiceCategory->exists()){
                return response()->json(['message' => $ProfessionConsultantServiceCategory->value('profession') . ' profession already taken'], 400);
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
        $query = ProfessionConsultantServiceCategory::where('id', $id);
        if(!$query->exists()){
            return response()->json(['message' => "Not found this Profession/Consultant Service Category"], 400);
        }
        $query =  $query ->first();
        $query->profession = $request->get("profession");
        $query->status = $request->has("status")?$request->get("status"): $query->status;
        if($query->save()){
            $ProfessionConsultantServiceCategoryId = $query->id;
            foreach ($request->get("translations") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = ProfessionConsultantServiceCategoryTranslation::where('profession_consultant_service_category_id', $ProfessionConsultantServiceCategoryId)
                        ->where('language_id', $languages->firstWhere('code', '==', $key)->id);
                    if(!$query->exists()){
                        $query = new ProfessionConsultantServiceCategoryTranslation();
                        $query->profession_consultant_service_category_id = $ProfessionConsultantServiceCategoryId;
                        $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    }else{
                        $query = $query->first();
                    }
                    $query->translation = $value;
                    $query->save();
                }
            }
            try {
                // refresh Profession Name
                file_get_contents(sprintf("%s/api/profession/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $id, env('APP_SOCKET_SECRET_KEY')));
            } catch (\Exception $ex) { }
            return response()->json(['message' => 'Profession/Consultant Service Category '.$request->get("profession") .' successfully updated'], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ProfessionConsultantServiceCategory  $professionConsultantServiceCategory
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $query = ProfessionConsultantServiceCategory::with(['translations'=>function($q){
            $q->with('language');
        }])->where("id", $id);
        if ($query->exists()) {
            if(User::where('consultant_category_id', $id)->exists()){
                return response()->json(['message' => "You can not delete this Profession/Consultant Service Category joined "
                    .implode(', ', User::where('consultant_category_id', $id)->pluck('first_name')->toArray())], 400);
            }
            $query = $query->first();
            $translations = ProfessionConsultantServiceCategoryTranslation::where('profession_consultant_service_category_id', $id);
            $consultantRequest = ConsultantRequest::where('profession_consultant_service_category_id', $id);
            if($translations->delete() && $query->delete()){
                if($consultantRequest->exists()){
                    $consultantRequest->delete();
                }
                return response()->json(['message' => ' Profession/Consultant Service Category successfully deleted'],200);
            }
            return response()->json(['message' => ' Profession/Consultant Service Category not deleted'], 404);
        }
        return response()->json(['message' => "This Profession/Consultant Service Category not found"], 404);
    }
}
