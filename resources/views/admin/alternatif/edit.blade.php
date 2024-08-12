@extends('layouts.app')
@section('title', 'SPK Penerima Bantuan ', $alternatif->nama_alternatif)
@section('content')
    <div class="row">
        <div class="col-md-12">
            <div class="card shadow mb-4">
                <!-- Card Header - Accordion -->
                <a href="#tambahkriteria" class="d-block card-header py-3" data-toggle="collapse"
                role="button" aria-expanded="true" aria-controls="collapseCardExample">
                <h6 class="m-0 font-weight-bold text-primary">Edit Alternatif {{ $alternatif->nama_alternatif }}</h6>
                </a>
            
            <!-- Card Content - Collapse -->
            <div class="collapse show" id="tambahkriteria">
                <div class="card-body">
                    @if (Session::has('msg'))
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        <strong>Infor</strong> {{ Session::get('msg') }}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                          <span aria-hidden="true">&times;</span>
                        </button>
                      </div>
                    @endif

                    <form action="{{ route('alternatif.update', $alternatif->id) }}" method="post" enctype="multipart/form-data">
                        @csrf
                        @method('put')
                        <div class="form-group">
                            <label for="nama">Nama Alternatif</label>
                            <input type="text" class="form-control @error ('nama_alternatif') is-invalid @enderror" name="nama_alternatif" value="{{ $alternatif->nama_alternatif }}">

                            @error('nama_alternatif')
                                <div class="invalid-feedback" role="alert">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>
                        <div class="form-group">
                            <label for="nama">NIK</label>
                            <input type="number" class="form-control @error ('nik') is-invalid @enderror" name="nik" value="{{ $alternatif->nik }}">

                            @error('nik')
                                <div class="invalid-feedback" role="alert">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="nama">Alamat</label>
                            <input type="text" class="form-control @error ('alamat') is-invalid @enderror" name="alamat" value="{{ $alternatif->alamat }}">

                            @error('alamat')
                                <div class="invalid-feedback" role="alert">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="nama">Telepon</label>
                            <input type="text" class="form-control @error ('telepon') is-invalid @enderror" name="telepon" value="{{ $alternatif->telepon }}">

                            @error('telepon')
                                <div class="invalid-feedback" role="alert">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="foto_ktp">Foto KTP</label>
                            <a href="{{ asset('' . $alternatif->foto_ktp) }}" data-lightbox="foto_ktp" data-title="Foto KTP">
                                <input type="file" class="dropify" id="foto_ktp" name="foto_ktp" data-default-file="{{ asset('' . $alternatif->foto_ktp) }}" data-id="{{ $alternatif->id }}" data-type="foto_ktp" data-height="600"  disabled/>
                            </a>
                        </div>

                        <div class="form-group">
                            <label for="foto_kk">Foto KK</label>
                            <a href="{{ asset('' . $alternatif->foto_kk) }}" data-lightbox="foto_kk" data-title="Foto KK">
                                <input type="file" class="dropify" id="foto_kk" name="foto_kk" data-default-file="{{ asset('' . $alternatif->foto_kk) }}" data-id="{{ $alternatif->id }}"  data-type="foto_kk" data-height="600" disabled/>
                            </a>
                        </div>

                        <div class="form-group">
                            <label for="status_validasi">Status Validasi</label>
                            <select class="form-control @error('status_validasi') is-invalid @enderror" name="status_validasi">
                                <option value="pending" {{ old('status_validasi', $alternatif->status_validasi) == 'pending' ? 'selected' : '' }}>Pending</option>
                                <option value="approved" {{ old('status_validasi', $alternatif->status_validasi) == 'approved' ? 'selected' : '' }}>Approved</option>
                                <option value="rejected" {{ old('status_validasi', $alternatif->status_validasi) == 'rejected' ? 'selected' : '' }}>Rejected</option>
                            </select>
                            @error('status_validasi')
                                <div class="invalid-feedback" role="alert">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>

                        <button class="btn btn-primary">Simpan</button>
                        <a href="{{ route('alternatif.index') }}" class="btn btn-success">Kembali</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
@stop

@section('js')
<script src="{{ asset('js/dropify.js') }}"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.3/js/lightbox.min.js"></script>
<script>
    $(document).ready(function() {
        $('.dropify').dropify();
        $('.dropify').each(function() {
            $(this).attr('disabled', true);
        });

        // Initialize Lightbox
        lightbox.option({
          'resizeDuration': 200,
          'wrapAround': true
        });
    });
</script>

@push('css')
<link rel="stylesheet" href="{{ asset('css/dropify.min.css') }}" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.3/css/lightbox.min.css">
@endpush
@stop
