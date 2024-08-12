<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('alternatif', function (Blueprint $table) {
            $table->string('foto_ktp')->after('telepon');
            $table->string('foto_kk')->after('foto_ktp');
            $table->enum('status_validasi', ['pending', 'approved', 'rejected'])->after('foto_kk');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('alternatif', function (Blueprint $table) {
            $table->dropColumn('foto_ktp');
            $table->dropColumn('foto_kk');
            $table->dropColumn('status_validasi');
        });
    }
};
