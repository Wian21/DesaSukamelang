<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Penilaian;
use Illuminate\Support\Facades\DB;

class PenilaianController extends Controller
{
    public function store(Request $request)
    {
        
        // Validate input
        $validated = $request->validate([
            'alternatif_id' => 'required|integer',
            'crips_id' => 'required|array',
            'crips_id.*' => 'integer',
        ]);

        try {
            DB::transaction(function () use ($validated) {
                // Debugging: log validated data
                \Log::info('Validated data:', $validated);

                // Delete existing penilaian for the given alternatif_id
                Penilaian::where('alternatif_id', $validated['alternatif_id'])->delete();

                // Save new penilaian data
                foreach ($validated['crips_id'] as $cripsId) {
                    Penilaian::create([
                        'alternatif_id' => $validated['alternatif_id'],
                        'crips_id' => $cripsId,
                    ]);
                }
            });

            return response()->json(['msg' => 'Berhasil Disimpan!'], 200);
        } catch (\Exception $e) {
            \Log::emergency("File:" . $e->getFile(). "Line:" . $e->getLine(). "Message:" . $e->getMessage());
            return response()->json(['msg' => 'Gagal', 'error' => $e->getMessage()], 500);
        }
    }
}
