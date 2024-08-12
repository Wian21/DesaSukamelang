<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Alternatif;
use Illuminate\Support\Facades\Storage;

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
            'nama_alternatif' => 'required|string|max:255',
            'nik' => 'required|string|max:255',
            'alamat' => 'required|string|max:255',
            'telepon' => 'required|string|max:255',
            'foto_ktp' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048', // max 2 mb files
            'foto_kk' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048', //max 2 mb files
        ]);

        try {
            // Handle file upload for foto_ktp
            if ($request->hasFile('foto_ktp')) {
                $fotoKtpPath = $request->file('foto_ktp')->store('public/img/ktp');
                $data['foto_ktp'] = Storage::url($fotoKtpPath);
            }

            // Handle file upload for foto_kk
            if ($request->hasFile('foto_kk')) {
                $fotoKkPath = $request->file('foto_kk')->store('public/img/kk');
                $data['foto_kk'] = Storage::url($fotoKkPath);
            }

            // Set default status_validasi
            $data['status_validasi'] = 'pending';

            // Create new alternatif record
            $alternatif = Alternatif::create($data);

            return response()->json($alternatif, 201);
        } catch (\Exception $e) {
            \Log::error("Failed to store alternatif: " . $e->getMessage());
            return response()->json(['msg' => 'Gagal', 'error' => $e->getMessage()], 500);
        }
    }
}
