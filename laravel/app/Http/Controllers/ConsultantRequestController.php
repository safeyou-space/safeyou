<?php

namespace App\Http\Controllers;

use App\Models\ConsultantRequest;
use App\Models\ProfessionConsultantServiceCategory;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ConsultantRequestController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $query = ConsultantRequest::with(['user', 'category'])
            ->orderby('created_at', 'desc');
        if ($query->exists()) {
            $query=$query->paginate(10);
            return response()->json($query, 200);
        }
        return response()->json(['message' => "Empty! Not Created"], 200);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ConsultantRequest  $consultantRequest
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = ConsultantRequest::with(['user', 'category'])
            ->where('id', $id);
        if ($query->exists()) {
            $query=$query->get();
            return response()->json($query, 200);
        }
        return response()->json(['message' => "Empty! Not Created"], 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\ConsultantRequest  $consultantRequest
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "status" => "required|in:1,2",
            "category_id"=>"exists:profession_consultant_service_categories,id",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $req = ConsultantRequest::where('id', $id);
        if($req->exists()){
            $req = $req->first();
            if($request->has('category_id')){
                $req->profession_consultant_service_category_id = $request->get('category_id');
                if(!$req->save()) {
                    return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
                }
            }
            $profession_consultant_service_category_id = $req->profession_consultant_service_category_id;
            $user_id = $req->user_id;
            $user = User::where('id', $user_id);
            if(!$user->exists()){
                return response()->json(['message' => "this user not Found"], 400);
            }
            $user = $user->first();
            if($user->status != 1){
                return response()->json(['message' => "this user Disabled"], 400);
            }
            if($request->get('status') == 2){
                $user->is_consultant = 0;
                $user->role = 5;
                $user->consultant_category_id = null;
                $req->status = 2;
                if($user->save() && $req->save()){
                    $oldReqs = ConsultantRequest::where("id",'!=',$id)->where('user_id', $user->id);
                    if($oldReqs->exists()){
                        $oldReqs->delete();
                    }
                    try {
                        // refresh profile info
                        file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $user_id, env('APP_SOCKET_SECRET_KEY')));
                    } catch (\Exception $ex) { }
                    return response()->json(['message' => $user->first_name . " " . $user->first_name
                        . " was successfully User"], 200);
                }
            }
            $ProfessionConsultantServiceCategory = ProfessionConsultantServiceCategory::where('id', $profession_consultant_service_category_id);
            if(!$ProfessionConsultantServiceCategory->exists()){
                return response()->json(['message' => "this Profession Consultant Category not Found"], 400);
            }
            $ProfessionConsultantServiceCategory = $ProfessionConsultantServiceCategory->first();
            if($ProfessionConsultantServiceCategory->status == 0){
                return response()->json(['message' => "this Profession Consultant Category status Disabled"], 400);
            }
            if($request->get('status') == 1){
                $user->is_consultant = 1;
                $user->role = 4;
                $user->email = $req->email;
                $user->consultant_category_id = $ProfessionConsultantServiceCategory->id;
                $req->status = 1;
                if($user->save() && $req->save()){
                    $oldReqs = ConsultantRequest::where("id",'!=',$id)->where('user_id', $user->id);
                    if($oldReqs->exists()){
                        $oldReqs->delete();
                    }
                    try {
                        // refresh profile info
                        file_get_contents(sprintf("%s/api/profile/%d/refresh/%s", env('APP_SOCKET_URL_'.strtoupper($code)), $user_id, env('APP_SOCKET_SECRET_KEY')));
                    } catch (\Exception $ex) { }
                    return response()->json(['message' => $user->first_name . " " . $user->first_name
                     . " was successfully Consultant"], 200);
                }
            }
            return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
        }return response()->json(['message' => "Not Found"], 404);
    }

    public function changeUserIsConsultantStatus(Request $request, $code, $id){
        if($request->has('status') && $id && $request->has('consultant_category_id')){
            $user = User::whereIn('role', [5, 6])->where('id',$id);
            $category = ProfessionConsultantServiceCategory::where('id', $request->has('consultant_category_id'));
            if($user->exists() && $category->exists()){
                $user = $user->first();
                if($request->get('status') == 1 ){
                    $user->is_consultant = 1;
                    $user->role = 4;
                    $user->email = $request->get('email');
                    $user->consultant_category_id = $request->get('consultant_category_id');
                    if($user->save()){
                        if($request->has('consultant_requests')){
                            $consultant_requests = ConsultantRequest::where('id', $request->get('consultant_requests'));
                            if($consultant_requests->exists()){
                                $consultant_requests = $consultant_requests->first();
                                $consultant_requests->status = 1;
                                $consultant_requests->email = $request->get('email');
                                if(!$consultant_requests->save()){
                                    return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
                                }
                            }
                        }
                        return response()->json(['message' => "This User is successfully  consultant."], 200);
                    }

                }
                if($request->get('status') == 0 ){
                    $user->is_consultant = 0;
                    $user->consultant_category_id = null;
                    $user->role = 5;
                    if($user->save()){
                        $consultant_requests = ConsultantRequest::where('user_id', $user->id);
                        if($consultant_requests->exists()){
                            $consultant_requests = $consultant_requests->first();
                            $consultant_requests->status = 2;
                            if(!$consultant_requests->save()){
                                return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
                            }
                        }
                        return response()->json(['message' => "This Consultant has become a User."], 200);
                    }
                }
                return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
            }
            return response()->json(['message' => "This User or consultant category not found"], 404);
        }return response()->json(['message' => "Invalid request"], 404);
    }
}
