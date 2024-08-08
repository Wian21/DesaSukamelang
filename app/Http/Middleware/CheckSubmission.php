<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class CheckSubmission
{
    public function handle($request, Closure $next)
    {
        if (Auth::check() && Auth::user()->has_submitted) {
            return response()->json(['message' => 'Data has already been submitted'], 403);
        }
        return $next($request);
    }
}
