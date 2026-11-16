<?php

namespace App\Http\Controllers;

use App\Models\Contents;
use App\Models\ContentTranslations;
use App\Models\Languages;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Validator;

class ContentsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return response()->json(Contents::with(['translations'=>function($q){
            $q->with(['language'=>function($q){
                $q->with('image');
            }]);
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
            "content.*" => "required|min:3",
            "title" => "required|unique:contents,title",
        ]);
        $languages = Languages::all();

        if($request->has("content")){
            if($languages->count() == count($request->get("content"))) {
                foreach ($request->get("content") as $key => $value) {
                    if (!$languages->firstWhere('code', '==', $key)) {
                        return response()->json(['message' => $key . ' code not found in languages'], 422);
                    }
                }
            }else{
                return response()->json(['message' => "did not are written content for all translations"], 422);
            }
        }
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = new Contents();
        $query->title = $request->get("title");
        if($query->save()){
            $contentId = $query->id;
            foreach ($request->get("content") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = new ContentTranslations();
                    $query->content_id = $contentId;
                    $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    $query->content = $value;
                    $query->save();
                }
            }
            return response()->json(['message' => 'Content for '.$request->get("title") .' successfully created'], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Contents  $contents
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = Contents::with(['translations'=>function($q){
            $q->with(['language'=>function($q){
                $q->with('image');
            }
            ]);
        }])->where("id", $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This Content not found"], 404);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Contents  $contents
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "content.*" => "required|min:3",
            "title" => "required|min:3",
        ]);
        $languages = Languages::all();

        if($request->has("content")){
            if($languages->count() == count($request->get("content"))) {
                foreach ($request->get("content") as $key => $value) {
                    if (!$languages->firstWhere('code', '==', $key)) {
                        return response()->json(['message' => $key . ' code not found in languages'], 422);
                    }
                }
            }else{
                return response()->json(['message' => "did not are written content for all translations"], 422);
            }
        }
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = Contents::where('id', $id);
        if(!$query->exists()){
            return response()->json(['message' => "Not found this Content"], 400);
        }
        $query =  $query ->first();
        $query->title = $request->get("title");
        if($query->save()){
            $contentId = $query->id;
            foreach ($request->get("content") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $query = ContentTranslations::where('content_id', $contentId)
                        ->where('language_id', $languages->firstWhere('code', '==', $key)->id);
                    if(!$query->exists()){
                        $query = new ContentTranslations();
                        $query->content_id = $contentId;
                        $query->language_id = $languages->firstWhere('code', '==', $key)->id;
                    }else{
                        $query = $query->first();
                    }
                    $query->content = $value;
                    $query->save();
                }
            }
            return response()->json(['message' => 'Content for '.$request->get("title") .' successfully updated'], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Contents  $contents
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $content = Contents::where('id', $id);
        if(!$content->exists()){
            return response()->json(['message'=>'this Content Not found'], 404);
        }
        $content = $content->first();
        if(ContentTranslations::where('content_id', $content->id)->delete() && $content->delete()){
            return response()->json(['message'=>'this Content Successfully deleted'], 200);
        }
        return response()->json(['message'=>'Please try again, what`s the wrong!'], 400);

    }
}
