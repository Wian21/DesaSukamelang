@extends('layouts.app')
@section('title', 'Validasi')
@section('content')

<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="card shadow mb-4">
                <a href="#uploadValidation" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="uploadValidation">
                    <h6 class="m-0 font-weight-bold text-primary">Validasi Foto KTP dan Rumah Warga</h6>
                </a>
            
                <div class="collapse show" id="uploadValidation">
                    <div class="card-body">
                        <form action="{{ route('validasi.store') }}" method="post" enctype="multipart/form-data">
                            @csrf
                            <input type="hidden" name="alternatif_id" value="{{ $alternatif->id }}">

                            <div class="form-group">
                                <label for="foto_ktp">Foto KTP</label>
                                <input type="file" class="form-control dropify" name="foto_ktp" data-default-file="{{ asset('path/to/your/image.jpg') }}" data-show-remove="false" data-show-loader="false" disabled>
                            </div>

                            <div class="form-group">
                                <label for="foto_rumah">Foto Rumah</label>
                                <input type="file" class="form-control dropify" name="foto_rumah" data-default-file="{{ asset('path/to/your/image.jpg') }}" data-show-remove="false" data-show-loader="false" disabled>
                            </div>

                            <div class="form-group">
                                <label for="status_validasi">Status Validasi</label>
                                <select class="form-control @error('status_validasi') is-invalid @enderror" name="status_validasi">
                                    <option value="pending" {{ old('status_validasi') == 'pending' ? 'selected' : '' }}>Pending</option>
                                    <option value="approved" {{ old('status_validasi') == 'approved' ? 'selected' : '' }}>Approved</option>
                                    <option value="rejected" {{ old('status_validasi') == 'rejected' ? 'selected' : '' }}>Rejected</option>
                                </select>
                                @error('status_validasi')
                                    <div class="invalid-feedback" role="alert">
                                        {{ $message }}
                                    </div>
                                @enderror
                            </div>

                            <button class="btn btn-primary mt-2">Simpan</button>
                            <a href="{{ route('penilaian.index') }}" type="button" class="btn btn-outline-danger mt-2" style="margin-left: 5px">Batal</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@stop

@section('js')
<script src="{{ asset('js/dropify.js') }}"></script>

<script>
    $(document).ready(function() {
        $('.dropify').dropify();
    });
</script>

@push('css')
<link rel="stylesheet" href="{{ asset('css/dropify.min.css') }}" />
@endpush

@stop
