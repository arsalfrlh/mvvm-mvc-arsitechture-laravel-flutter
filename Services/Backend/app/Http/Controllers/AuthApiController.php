<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\ResendRequest;
use App\Http\Requests\VerifyRequest;
use App\Services\AuthService;
use Illuminate\Http\Request;

class AuthApiController extends Controller
{
    protected $authService; //buat variabel dlm class
    public function __construct(AuthService $authService){ //buat function konstruktor dan berisi parameter class AuthService
        $this->authService = $authService; //isi variable dlm class tadi dengan parameter class AuthService
    }

    public function login(LoginRequest $loginRequest){
        //$data akan menyimpan hasil dari AuthService| $panggil variable authService dlm class dan panggil function login dlm class AuthService tersebut| validated() untuk validasi request
        $data = $this->authService->login($loginRequest->validated());
        return response()->json($data, $data['status_code']);
    }

    public function register(RegisterRequest $registerRequest){
        $data = $this->authService->register($registerRequest->validated());
        return response()->json($data, $data['status_code']);
    }

    public function verify(VerifyRequest $verifyRequest){
        $data = $this->authService->verify($verifyRequest->validated());
        return response()->json($data, $data['status_code']);
    }

    public function resend(ResendRequest $resendRequest){
        $data = $this->authService->resend($resendRequest->validated());
        return response()->json($data, $data['status_code']);
    }
}
