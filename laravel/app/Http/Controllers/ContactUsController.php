<?php

namespace App\Http\Controllers;

use App\Mail\ContactUsEmail;
use App\Mail\ResponseLetter;
use App\Models\ContactUs;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;

class ContactUsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $contact_us_lists = ContactUs::with(['user'=>function($q){
            $q->with('image');
        }, 'reply'])->where('user_id', '=',NULL)
            ->orderBy('created_at', 'desc')
            ->orderBy('checked', 'desc');

        if($contact_us_lists->exists()){

            return response()->json($contact_us_lists->paginate(20), 200);
        }
        return response()->json(['message'=>"Not Found"], 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request){
        $validator = Validator::make($request->all(), [
            "name" => "required|string|min:1|max:120",
            "message" => "required|string|min:1|max:500",
            "email" => "required|min:6|max:120",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        if($request->has('email') && ($request->get('email') != '')){
            if(!filter_var($request->get('email'), FILTER_VALIDATE_EMAIL)){
                return response()->json(['message' => "Invalid email address"], 400);
            }
        }
        $contactUs = new ContactUs();
        $contactUs->name = $request->get('name');
        $contactUs->email = $request->get('email');
        $contactUs->message = $request->get('message');
        if($contactUs->save()){
            Mail::send(new ContactUsEmail($request->get('message'),
                $request->get('name'), $request->get('email')));
            return response()->json(['message' => "Successfully sent."], 200);
        } return response()->json(['message' => "Error not sent."], 400);
    }

    public function responseLetter(Request $request, $code, $id){
        $validator = Validator::make($request->all(), [
            "message" => "required|min:1|max:500",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $contactMail = ContactUs::where('id', $id);
        if($contactMail->exists()){
            $contactMail = $contactMail->first();
            $name = $contactMail->name;
            $email = $contactMail->email;
            $contactUs = new ContactUs();
            $contactUs->name = Auth::user()->first_name . ' ' .Auth::user()->last_name;
            $contactUs->message = $request->get('message');
            $contactUs->reply_id = $id;
            $contactUs->user_id = Auth::user()->id;
            $contactUs->checked = 1;
            if($contactUs->save()){
                Mail::send(new ResponseLetter($request->get('message'),
                    $name, $email));
                return response()->json(['message' => "Successfully sent."], 200);
            } return response()->json(['message' => "Error not sent."], 400);
        }return response()->json(['message' => "Not Found this contact mail."], 404);
    }
    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ContactUs  $contactUs
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $contactUs = ContactUs::with(['user'=>function($q){
            $q->with('image');
        }, 'reply'])->where('id', $id);
        if($contactUs->exists()){
            return response()->json($contactUs->first(), 200);
        }
        return response()->json(["message"=>"Not Found"], 400);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ContactUs  $contactUs
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $countryCode, $id)
    {
        $contactUs = ContactUs::with('reply')->where('id', $id);
        if($contactUs->exists()){
            $contactUs = $contactUs->first();
            if($contactUs->reply()->exists()){
                $contactUs->reply()->delete();
            }
            if($contactUs->delete()){
                return response()->json(['message' => "Successfully deleted"], 200);
            }return response()->json(['message' => "Error delete"], 400);
        }return response()->json(['message' => "Not Found"], 400);
    }
    public function changeStatus(Request $request, $countryCode, $id)
    {
        $contactUs = ContactUs::where('id', $id);
        if($contactUs->exists()){
            $contactUs = $contactUs->first();
            $contactUs->checked = 1;
            if($contactUs->save()){
                return response()->json(['message' => "Successfully checked"], 200);
            }return response()->json(['message' => "Error checked"], 400);
        }return response()->json(['message' => "Not Found"], 400);
    }
    public function getUncheckedList(Request $request, $countryCode)
    {
        $contactUs = ContactUs::where('checked', 0)->get();
        return response()->json($contactUs, 200);
    }
}
