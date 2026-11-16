<?php

namespace App\Helpers;

use App\Models\Image;
use App\Models\Video;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;

class FileLib
{

    public static function uploadImage($file, $type = 'user_profile', $id = null)
    {
        $path = env('UPLOAD_' . strtoupper($type) . '_IMAGE');
        $destinationPath = public_path($path);
        if (!file_exists($destinationPath)) {
            mkdir($destinationPath, 0777, true);
        }
        $extension = $file->getClientOriginalExtension();
        $name = md5(mktime(true)) . '.' . $extension;
        if ($id) {
            $query = Image::where('id', $id);
            if($query->exists()){
                $query = $query->first();
                if ($id > 7) {
                    if (file_exists(public_path($path) . '\\' . $query->name)) {
                        unlink(public_path($path) . '\\' . $query->name);
                    }
                }else{
                    $query = new Image();
                }
            }
        }else{
            $query = new Image();
        }

        $query->name = $name;
        $query->path = $path;
        $query->type = Image::TYPES[$type];
        $query->url = $path . $name;
        if ($file->move($destinationPath, $name) && $query->save()) {
            return $query->id;
        }
        return false;
    }

    public static function deleteImage($id)
    {
        if($id >8) return true;
        $query = Image::where('id', $id);
        if($query->exists()){
            $query = $query->first();
            $path = $query->path;
            if (file_exists(public_path($path . $query->name))) {
                unlink(public_path($path . $query->name));
            }
            return $query->delete();
        }
        return false;
    }
    public static function deleteAudio($path)
    {
        if (file_exists(public_path($path))) {
            unlink(public_path($path ));
            return true;
        }
        return false;
    }
    public static function UploadAudioFile($file){
        $path = env('UPLOAD_AUDIO_FILE');
        $destinationPath = public_path($path);
        if (!file_exists($destinationPath)) {
            mkdir($destinationPath, 0777, true);
        }
        $name = md5(md5_file($file) . mktime(true)) . '.' . $file->getClientOriginalExtension();
        $size = $file->getSize();
        if($size > env('SIZE_AUDIO')){
            return false;
        }
        $src = $path . $name;
        $file->move($destinationPath, $name);
        return $src;
    }

    /**delete after finished*/
    public static function upload($file, $id = null, $path = null, $type = null, $file_name = null)
    {

        $destinationPath = public_path($path);
        if (!file_exists($destinationPath)) {
            mkdir($destinationPath, 0777, true);
        }

        if (!is_array($file)) {
            $name = $file_name;
            if ($id == 1) {
                if ($type == 'image') {
                    $query = new Image();
                } elseif ($type == 'video') {
                    $query = new Video();
                }
            } else {
                if ($type == 'image') {
                    $query = Image::where('id', $id);
                } elseif ($type == 'video') {
                    $query = Video::where('id', $id);
                }
                if ($query->exists()) {
                    $query = $query->first();
                    if (file_exists(public_path($path) . '\\' . $query->name)) {

                        unlink(public_path($path) . '\\' . $query->name);
                    }
                    $file->move($destinationPath, $file_name);
                    $query->name = $file_name;
                    if ($query->save()) {
                        return $query->id;
                    }
                } else {
                    if ($type == 'image') {
                        $query = new Image();
                    } elseif ($type == 'video') {
                        $query = new Video();
                    }
                }
            }
            if ($file->move($destinationPath, $name)) {
                $query->name = $name;
                if ($query->save()) {
                    return $query->id;
                }
            }
        }
        return ['message' => 'file_upload_error'];
    }

    public static function upload_image($file, $id = null, $path = null, $type = null)
    {

        $destinationPath = public_path($path);
        if (!file_exists($destinationPath)) {
            mkdir($destinationPath, 0777, true);
        }

        if (!is_array($file)) {
            $name = md5(md5_file($file) . date('d-m-Y_h-i-s')) . '.' .
                $file->getClientOriginalExtension();

            if ($file->move($destinationPath, $name)) {

                if ($id == 1) {
                    if ($type == 'image') {
                        $query = new Image();
                    } elseif ($type == 'video') {
                        $query = new Video();
                    }
                } else {
                    if ($type == 'image') {
                        $query = Image::where('id', $id);
                    } elseif ($type == 'video') {
                        $query = Video::where('id', $id);
                    }
                    if ($query->exists()) {
                        $query = $query->first();
                        if (file_exists(public_path('/' . $query->path))) {

                            unlink(public_path( $query->path));
                        }
                    } else {
                        if ($type == 'image') {
                            $query = new Image();
                        } elseif ($type == 'video') {
                            $query = new Video();
                        }
                    }
                }
                $query->name = $name;
                $query->path = $path . '/' . $name;
                if ($query->save()) {
                    return $query->id;
                }
            }
        }
        return ['message' => 'file_upload_error'];
    }

    public static function fileUploader($image_data, $id = null, $path = null)
    {
        $split = (explode(',', $image_data));
        $ext = explode(';', explode('/', $split[0])[1])[0];
        $base = $split[1];
        if (!($ext == 'jpeg' || $ext == 'bmp' || $ext == 'jpg' || $ext == 'png')) {
            return ['message' => 'The_image_must_be_a_file_of_type:jpeg_bmp_jpg_png'];
        }
        $imageData = base64_decode($base);
        $filename = mktime(true) . '.' . $ext;
        $size = strlen($imageData);
        $size_env = env('SIZE_IMAGE');
        if ($size >= $size_env) {
            return ['message' => 'The_image_may_not_be_greater_than_1MB'];
        }

        if (file_put_contents(public_path($path . $filename), $imageData)) {
            if (is_null($id) || $id == 0 || $id == 1) {
                $query = new Image();
            } else {
                $query = Image::where('id', $id);
                if ($query->exists()) {
                    $query = $query->first();
                    if (file_exists(public_path($query->path))) {
                        unlink(public_path($query->path));
                    }
                } else {
                    $query = new Image();
                }
            }
            $query->name = $filename;
            $query->path = $path . $filename;
            if ($query->save()) {
                return $query->id;
            }
        }
    }

    public static function delete_files($id, $type, $path)
    {

        if ($type == 'video') {
            $query = Video::where('id', $id);
            if ($query->exists()) {
                $query = $query->first();
                if (file_exists(public_path($path . '/' . $query->name))) {
                    unlink(public_path($path . '/' . $query->name));
                }
                if ($query->delete()) {
                    return true;
                }
            }
            return false;
        } else {
            $query = Image::where('id', $id);
            if ($query->value('id') != 1) {
                if ($query->exists()) {
                    $query = $query->first();
                    if (file_exists(public_path($path . '/' . $query->name))) {
                        unlink(public_path($path . '/' . $query->name));
                    }
                    if ($query->delete()) {
                        return true;
                    }
                }
            }
            return false;
        }
    }

    public static function delete_image($id, $type)
    {

        if($type=='video'){
            $query = Video::where('id', $id);
            if ($query->exists()) {
                $query = $query->first();
                if (file_exists(public_path($query->path))) {
                    unlink(public_path($query->path));
                }
                if ($query->delete()) {
                    return true;
                }
            }
            return false;
        }else{
            $query = Image::where('id', $id);
            if ($query->value('id') != 1) {
                if ($query->exists()) {
                    $query = $query->first();
                    if (file_exists(public_path($query->path))) {
                        unlink(public_path($query->path));
                    }
                    if ($query->delete()) {
                        return true;
                    }
                }
            }
            return false;
        }
    }
}
