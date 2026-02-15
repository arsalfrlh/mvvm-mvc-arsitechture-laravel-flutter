<?php

use App\Http\Controllers\AuthApiController;
use App\Http\Controllers\BarangApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/login',[AuthApiController::class,'login']);
Route::post('/register',[AuthApiController::class,'register']);

Route::middleware(['auth:sanctum'])->group(function(){
    Route::apiResource('barang',BarangApiController::class);
});
