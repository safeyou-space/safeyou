<?php

namespace App\Http\Controllers;

use App\Models\Sms;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use function GuzzleHttp\Psr7\str;

class SmsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $query = Sms::with(['user'=>function($q)use ($request){
            if($request->has('first_name') && $request->get('first_name') != ''){
                $q->Like(['first_name'],$request->get('first_name'));
            }
            if($request->has('last_name') && $request->get('last_name') != ''){
                $q->Like(['last_name'],$request->get('last_name'));
            }
            $q->whereIn("role", [5, 4]);
        }, 'from_user'=>function($q)use ($request){
            if($request->has('first_name') && $request->get('first_name') != ''){
                $q->Like(['first_name'],$request->get('first_name'));
            }
            if($request->has('last_name') && $request->get('last_name') != ''){
                $q->Like(['last_name'],$request->get('last_name'));
            }
            $q->whereIn("role", [5, 4]);
        }]);
            if($request->has('phone') && $request->get('phone') != '') {
                $query->Like(['phone'], $request->get('phone'));
            }
             if($request->has('verifying_otp_code') && $request->get('verifying_otp_code') != ''){
                 $query->Like(['verifying_otp_code'],$request->get('verifying_otp_code'));
             }
             if($request->has('message') && $request->get('message') != ''){
                 $query->Like(['message'],(int)$request->get('message'));
             }
            if($request->has('service_sms_id') && $request->get('service_sms_id') != ''){
                $query->Like(['service_sms_id'],(int)$request->get('service_sms_id'));
            }
            if($request->has('verifying_type') && $request->get('verifying_type') != ''){
                $query->Like(['verifying_type'],(int)$request->get('verifying_type'));
            }
            if($request->has('checked') && $request->get('checked') != ''){
                $query->Like(['checked'],(int)$request->get('checked'));
            }

        $query->orderBy('created_at', 'desc');
        if ($query->exists()) {
            return response()->json($query->paginate(10), 200);
        }
        return response()->json(['message' => "Empty Not found"], 200);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Sms  $sms
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = Sms::with(['from_user', 'user'])->where('id',$id);
        if($query->exists()){
            $query = $query->first();
            return response()->json($query, 200);
        }
        return response()->json(['message' => "This Sms not found"], 404);
    }
    public function view_help_message(Request $request, $code)
    {
        if($request->has('uri') && strlen($request->get('uri')) == 8){

            $validator = Validator::make($request->all(), [
                "uri" => "required|string",
            ]);
            if ($validator->fails()) {
                return response()->json(['message' => $validator->errors()], 422);
            }
                $query = Sms::with(['from_user'=>function($q){
                        $q->with('image');
                }, 'user'=>function($q){
                        $q->with('image');
                }])->where('uri', $request->get('uri'))
                    ->where('verifying_type', 3);
                if ($query->exists()) {
                    $query = $query->first();
                    return response()->json($query, 200);
                }
            return response()->json(['message' => "invalid Phone Number"], 400);
        }
        return response()->json(['message' => "invalid link"], 404);
    }
}
