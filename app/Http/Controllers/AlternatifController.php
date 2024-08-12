<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Alternatif;
use App\Models\Penilaian;
use PDF;
use Carbon\Carbon;

class AlternatifController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function index(){

        $data['alternatif'] = Alternatif::latest()->paginate(10);
        return view('admin.alternatif.index',$data);

    }

    public function store(Request $request)
    {
        // Validasi input
        $this->validate($request, [
            'nama_alternatif' => 'required|string',
            'nik' => 'required|string',
            'alamat' => 'required|string',
            'telepon' => 'required|string',
            'foto_ktp' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'foto_kk' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',  
        ]);
    
        try {
            // Buat instance model Alternatif
            $alternatif = new Alternatif();
            $alternatif->nama_alternatif = $request->nama_alternatif;
            $alternatif->nik = $request->nik;
            $alternatif->alamat = $request->alamat;
            $alternatif->telepon = $request->telepon;
            $alternatif->status_validasi = 'pending'; // Nilai default
    
            // Upload dan simpan foto KTP
            if ($request->hasFile('foto_ktp')) {
                $file = $request->file('foto_ktp');
                $filename = time() . '_ktp.' . $file->getClientOriginalExtension();
                $path = public_path('img/ktp');
                $file->move($path, $filename);
                $alternatif->foto_ktp = $filename;
            }
    
            // Upload dan simpan foto KK
            if ($request->hasFile('foto_kk')) {
                $file = $request->file('foto_kk');
                $filename = time() . '_kk.' . $file->getClientOriginalExtension();
                $path = public_path('img/kk');
                $file->move($path, $filename);
                $alternatif->foto_kk = $filename;
            }
    
            // Simpan data ke database
            $alternatif->save();
    
            return back()->with('msg', 'Berhasil Menambahkan Data');
        } catch (Exception $e) {
            \Log::emergency("File:" . $e->getFile(). " Line:" . $e->getLine(). " Message:" . $e->getMessage());
            return back()->with('error', 'Gagal Menambahkan Data');
        }
    }
    



    public function edit($id)
    {
        $data['alternatif'] = Alternatif::findOrFail($id);
        return view('admin.alternatif.edit', $data);
    }


    public function update(Request $request, $id)
    {
        // Validasi input untuk memastikan data yang dimasukkan sesuai dengan harapan
        $request->validate([
            'nama_alternatif' => 'required|string|max:255',
            'nik' => 'required|numeric',
            'alamat' => 'required|string',
            'telepon' => 'required|numeric',
            'foto_ktp' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'foto_kk' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'status_validasi' => 'required|string|in:pending,approved,rejected',
        ]);
    
        $data = $request->except(['_token', '_method', 'foto_ktp', 'foto_kk']);
    
        // Handle foto_ktp upload
        if ($request->hasFile('foto_ktp')) {
            $file = $request->file('foto_ktp');
            $filename =  time() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('img/ktp'), $filename);
            $data['foto_ktp'] = $filename;
        } else {
            $data['foto_ktp'] = Alternatif::where('id', $id)->value('foto_ktp');
        }
    
        // Handle foto_kk upload
        if ($request->hasFile('foto_kk')) {
            $file = $request->file('foto_kk');
            $filename =  time() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('img/kk'), $filename);
            $data['foto_kk'] = $filename;
        } else {
            $data['foto_kk'] = Alternatif::where('id', $id)->value('foto_kk');
        }
    
        // Update the Alternatif record
        Alternatif::where('id', $id)->update($data);
    
        return redirect()->route('alternatif.index')->with('success', 'Alternatif berhasil diubah');
    }
    

    public function destroy($id) {
        try {
            $alternatif = Alternatif::findOrFail($id);
    
            // Delete related Penilaian records
            Penilaian::where('alternatif_id', $id)->delete();
    
            // Delete the Alternatif
            $alternatif->delete();
    
            return response()->json(['msg' => 'Berhasil Menghapus Data'], 200);
    
        } catch (Exception $e) {
            \Log::emergency("File:" . $e->getFile() . "Line:" . $e->getLine() . "Message:" . $e->getMessage());
            return response()->json(['msg' => 'Gagal Menghapus Data'], 500);
        }
    }
    


    public function downloadPDF() {
        setlocale(LC_ALL, 'IND');
        $tanggal = Carbon::now()->formatLocalized('%A, %d %B %Y');
        $alternatif = Alternatif::with('penilaian.crips')->get();

        $pdf = PDF::loadView('admin.alternatif.alternatif-pdf',compact('alternatif','tanggal'));
        $pdf->setPaper('A3', 'potrait');
        return $pdf->stream('alternatif.pdf');
    }
}
