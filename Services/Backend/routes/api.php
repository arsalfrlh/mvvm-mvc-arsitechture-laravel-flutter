<?php

use App\Http\Controllers\AuthApiController;
use App\Http\Controllers\PostApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/login',[AuthApiController::class,'login']);
Route::post('/register',[AuthApiController::class,'register']);
Route::post('/verify',[AuthApiController::class,'verify']);
Route::post('/resend',[AuthApiController::class,'resend']);

Route::middleware(['auth:sanctum'])->group(function(){
    Route::apiResource('/post',PostApiController::class);
});