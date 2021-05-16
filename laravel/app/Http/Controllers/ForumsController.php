<?php

namespace App\Http\Controllers;

use App\Helpers\FileLib;
use App\Models\ForumDiscussions;
use App\Models\Forums;
use App\Models\ForumTranslations;
use App\Models\Languages;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ForumsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $query = Forums::with(['image',  'creator', 'translations'=>function($q) use($request){
            $q->with(['language'=>function($query) use($request) {
                $query->with('image');
            }]);
        }]);
         $query->whereHas('translations', function ($query)use($request) {
            if ($request->has('title') && $request->get('title') != '') {
                $query->Like(['title'], $request->get('title'));
            }
            if ($request->has('sub_title') && $request->get('sub_title') != '') {
                $query->Like(['sub_title'], $request->get('sub_title'));
            }
            if ($request->has('short_description') && $request->get('short_description') != '') {
                $query->Like(['short_description'], $request->get('short_description'));
            }
            if ($request->has('description') && $request->get('description') != '') {
                $query->Like(['description'], $request->get('description'));
            }
        });
        if ($request->has('status') && $request->get('status') != '') {
            $query->Like(['status'], $request->get('status'));
        }
        $query->orderBy('created_at', 'desc');
        if($query->exists()){
            return response()->json($query->paginate(10), 200);
        }return response()->json(['message' => "Empty Not found"], 200);
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
            "translations.en.title" => "required|string|min:3",
            "translations.*.sub_title" => "required|string|min:3",
            "translations.*.description" => "required|string|min:3",
            "translations.*.short_description" => "required|string|min:3",
            "image" => "required|mimes:jpeg,bmp,png,gif|max:5120",
            "status" => "numeric|in:1,0",
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
        $query = new Forums();
        $image_id = 7;
        if(request()->hasFile('image')){
            $image_id = FileLib::uploadImage($request->file('image'), 'forum');
            if(!$image_id){
                return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
            }
        }
        $query->image_id = $image_id;
        $query->creator_id = Auth::user()->id;
        $query->status = $request->has('status')? $request->get('status') : 0;
        if($query->save()){
            foreach ($request->get("translations") as $key => $value){
                if($languages->firstWhere('code', '==', $key)){
                    $q = new ForumTranslations();
                    $q->forum_id = $query->id;;
                    $q->title = $value['title']?$value['title']:null;
                    $q->sub_title = ($value['sub_title'])?$value['sub_title']:null;
                    $q->description = $value['description']?$value['description']:null;
                    $q->short_description = $value['short_description']?$value['short_description']:null;
                    $q->language_id = $languages->firstWhere('code', '==', $key)->id;
                    $q->save();
                }
            }
            if($query->status == 1){
                $id = $query->id;
                try {
                    // send notification new forum
                    file_get_contents(sprintf("%s/api/forum/%d/%s", env('APP_SOCKET_URL_'.strtoupper(request()->segments()[1])), $id, env('APP_SOCKET_SECRET_KEY')));
                } catch (\Exception $ex) { }
            }
            return response()->json(['message' => "This Forum successfully created"], 200);
        }return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Forums  $forums
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $code, $id)
    {
        $query = Forums::with(['image', 'creator',  'translations'=>function($q) {
            $q->with(['language'=>function($q) {
                $q->with('image');
            }]);
        }])->withCount('discussions')->where("id", $id);
        if ($query->exists()) {
            return response()->json($query->get(), 200);
        }
        return response()->json(['message' => "This Forum not found"], 404);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Forums  $forums
     * @return \Illuminate\Http\Response
     */
    public function edit(Forums $forums)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Forums  $forums
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $code, $id)
    {
        $validator = Validator::make($request->all(), [
            "translations.*" => "required|min:1|max:255",
            "translations" => "required|array",
            "translations.*.title" => "required|string|min:3",
            "translations.*.sub_title" => "required|string|min:3",
            "translations.*.description" => "required|string|min:3",
            "translations.*.short_description" => "required|string|min:3",
            "image" => "mimes:jpeg,bmp,png,gif|max:5120",
            "status" => "numeric|in:1,0",
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 422);
        }
        $query = Forums::where('id', $id);
        if(!$query->exists()){
            return response()->json(['message' => "This Forum Not found"], 400);
        } $query = $query->first();
        $oldStatus = $query->status;
       if(($request->has('status') && $request->get('status') != $query->status)|| request()->hasFile('image')){
           $query->creator_id = Auth::user()->id;
           if(request()->hasFile('image')){
               $old_image_id = NULL;
               if($query->image_id != 7){
                   $old_image_id = $query->image_id;
               }
               $image_id = FileLib::uploadImage($request->file('image'), 'forum', $old_image_id);
               if(!$image_id){
                   return response()->json(['message' => ["Image is not updated.","Something went  wrong!"]], 400);
               } $query->image_id = $image_id;
           }

           $query->status = $request->has('status')? $request->get('status') : $query->status;
           $query->save();
           $id = $query->id;
       }
        foreach ($request->get('translations') as $code =>  $translation){
            $queryTranslation = ForumTranslations::where('forum_id', $query->id)->where('language_id', Languages::where('code', $code)->value('id'));
            if(!$queryTranslation->exists()){
                $queryTranslation = new ForumTranslations();
                $queryTranslation->language_id = Languages::where('code', $code)->value('id');
                $queryTranslation->forum_id = $query->id;
            }else{
                $queryTranslation = $queryTranslation->first();
            }
            $queryTranslation->title = $translation['title'];
            $queryTranslation->sub_title = $translation['sub_title'];
            $queryTranslation->description = $translation['description'];
            $queryTranslation->short_description = $translation['short_description'];
            if(!$queryTranslation->save()){
                return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
            }
        }
        if($oldStatus == 0 && $query->status == 1){
            try {
                // send notification new forum
                file_get_contents(sprintf("%s/api/forum/%d/%s", env('APP_SOCKET_URL_'.strtoupper(request()->segments()[1])), $id, env('APP_SOCKET_SECRET_KEY')));
            } catch (\Exception $ex) { }
        }
            return response()->json(['message' => "This Forum successfully Updated"], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Forums  $forums
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $code, $id)
    {
        $query = Forums::where("id", $id);
        if ($query->exists()) {
            $query = $query->first();
            if($query->image_id){
                FileLib::deleteImage($query->image_id, '');
            }
            $forumsMessages = ForumDiscussions::where('forum_id', $id);
            if($forumsMessages->exists()){
                $forumsMessages->delete();
            }
            $queryTranslations = ForumTranslations::where('forum_id',$query->id);
            if($queryTranslations->delete() && $query->delete()){
                return response()->json(['message' => "This Forum successfully deleted"], 200);
            }
            return response()->json(['message' => ["Please try again.","Something went  wrong!"]], 400);
        }
        return response()->json(['message' => "This Forum not found"], 404);
    }
}
