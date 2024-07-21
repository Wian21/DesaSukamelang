<?php
namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Crips;

class CripsController extends Controller
{
    public function index()
    {
        $crips = Crips::all();
        return response()->json($crips);
    }
}
