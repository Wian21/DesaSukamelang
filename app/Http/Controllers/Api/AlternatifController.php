<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Alternatif;

class AlternatifController extends Controller
{
    public function index()
    {
        $alternatif = Alternatif::all();
        return response()->json($alternatif);
    }
    public function store(Request $request)
    {
        $data = $request->validate([
            'nama_lengkap' => 'required|string|max:255',
            'nik' => 'required|string|max:255',
            'alamat' => 'required|string|max:255',
            'telepon' => 'required|string|max:255',
        ]);

        try {
            $alternatif = Alternatif::create($data);
            return response()->json($alternatif, 201);
        } catch (\Exception $e) {
            \Log::error("Failed to store alternatif: " . $e->getMessage());
            return response()->json(['msg' => 'Gagal', 'error' => $e->getMessage()], 500);
        }
    }
}