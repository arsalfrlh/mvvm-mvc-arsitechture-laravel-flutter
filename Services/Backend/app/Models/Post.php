<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    protected $table = "posts";
    protected $fillable = ['user_id','caption'];

    function user(){
        return $this->belongsTo(User::class,'user_id');
    }

    function postImage(){
        return $this->hasMany(PostImage::class,'post_id');
    }
}
