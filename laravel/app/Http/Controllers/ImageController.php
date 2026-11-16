<?php

namespace App\Http\Controllers;

use App\Models\Image;
use Illuminate\Http\Request;

class ImageController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function getDefaultByType(Request $request, $code, $type)
    {
        if(Image::TYPES[$type]){
            return Image::where('type', Image::TYPES[$type])->orderBy('id')->first();
        }return response()->json(['message' => "invalid Type"], 400);
    }

    public function icons(){
        if(Image::ICONS){
            return response()->json(Image::ICONS, 200);
        }return response()->json(['message' => "not found"], 400);
    }
    public function social_icons(){
        if(Image::ICONS['facebook'] && Image::ICONS['instagram']){
            return response()->json(['facebook'=>Image::ICONS['facebook'], 'instagram'=>Image::ICONS['instagram']], 200);
        }return response()->json(['message' => "not found"], 400);
    }
}
