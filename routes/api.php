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

Route::middleware('auth:sanctum')->get('/user', [UserController::class, 'getUser']);
Route::post('/auth/register', [UserController::class, 'createUser']);
Route::post('/auth/login', [UserController::class, 'loginUser']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', 'App\Http\Controllers\AuthController@register');
Route::post('/login', 'App\Http\Controllers\AuthController@login');
Route::middleware('auth:sanctum')->post('/logout', 'App\Http\Controllers\AuthController@logout');

Route::get('/user', 'App\Http\Controllers\AuthController@user')->middleware('auth:sanctum');

// Route::post('/submit-data', 'DataController@submit')->middleware('check.submission');
Route::middleware('auth:sanctum')->get('/check-data-submission', [AlternatifController::class, 'checkDataSubmission']);
// Route::middleware('auth:sanctum')->get('/check-data-submission', [UserController::class, 'checkDataSubmission']);
// Route::middleware('auth:sanctum')->post('/mark-data-submitted', [UserController::class, 'markDataSubmitted']);