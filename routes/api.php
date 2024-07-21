<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PenilaianController;
use App\Http\Controllers\Api\AlternatifController;
use App\Http\Controllers\Api\CripsController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/alternatif', [AlternatifController::class, 'index']);
Route::post('/alternatif', [AlternatifController::class, 'store']);

Route::get('/crips', [CripsController::class, 'index']);

Route::get('/penilaian', [PenilaianController::class, 'index']);
Route::post('/penilaian', [PenilaianController::class, 'store']);

Route::post('/auth/register', [UserController::class, 'createUser']);
Route::post('/auth/login', [UserController::class, 'loginUser']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', 'App\Http\Controllers\AuthController@register');
Route::post('/login', 'App\Http\Controllers\AuthController@login');
Route::post('/logout', 'App\Http\Controllers\AuthController@logout')->middleware('auth:sanctum');
Route::get('/user', 'App\Http\Controllers\AuthController@user')->middleware('auth:sanctum');