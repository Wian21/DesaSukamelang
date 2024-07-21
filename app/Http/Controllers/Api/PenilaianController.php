<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Penilaian;
use App\Models\Alternatif;
use App\Models\Kriteria;
use App\Models\Crips;
use Carbon\Carbon;
use DB;

class PenilaianController extends Controller
{
    public function index()
    {
        $alternatif = Alternatif::with('penilaian.crips')->get();
        $kriteria = Kriteria::with('crips')->orderBy('id', 'ASC')->get();

        // Pastikan data alternatif dan kriteria tidak null
        if ($alternatif->isEmpty() || $kriteria->isEmpty()) {
            return response()->json([
                'message' => 'Data tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'alternatif' => $alternatif,
            'kriteria' => $kriteria
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'crips_id' => 'required|array',
        ]);

        try {
            DB::statement("TRUNCATE TABLE penilaian");
            foreach ($request->crips_id as $key => $value) {
                $penilaian = new Penilaian();
                $penilaian->crips_id = $value;
                $penilaian->save();
            }
            return response()->json(['msg' => 'Berhasil Disimpan!'], 201);
        } catch (\Exception $e) {
            \Log::emergency("File:" . $e->getFile() . "Line:" . $e->getLine() . "Message:" . $e->getMessage());
            return response()->json(['msg' => 'Gagal', 'error' => $e->getMessage()], 500);
        }
    }
}