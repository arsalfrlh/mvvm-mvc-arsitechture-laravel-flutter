<?php
namespace App\Services; //tambahkan namescape

use App\Jobs\SendEmail;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthService
{
    public function login(array $request){
        $user = User::where('email', $request['email'])->first();
        if(!$user || !Hash::check($request['password'], $user->password)){
            return [
                'message' => "Email atau Password Anda salah",
                'success' => false,
                'status_code' => 401
            ];
        }

        if($user->hasVerifiedEmail()){
            $data = [
                'name' => $user->name,
                'token' => $user->createToken('auth-token')->plainTextToken
            ];
            
            return [
                'message' => "Login berhasil",
                'success' => true,
                'status_code' => 200,
                'data' => $data
            ];
        }else{
            return [
                'message' => "Akun anda belum di verifikasi",
                'success' => "UnAuthorization",
                'status_code' => 401
            ];
        }
    }

    public function register($request){
        $otp = random_int(100000, 999999);
        $user = User::create([
            'name' => $request['name'],
            'email' => $request['email'],
            'password' => Hash::make($request['password']),
            'token_verify' => $otp
        ]);

        SendEmail::dispatch($user->id);
        return [
            'message' => "Register berhasil",
            'name' => $user->name,
            'status_code' => 201,
            'success' => true
        ];
    }

    public function verify($request){
        $user = User::where('token_verify', $request['otp'])->first();
        if(!$user){
            return [
                'message' => "Otp tidak Valid",
                'success' => false,
                'status_code' => 401
            ];
        }

        $user->markEmailAsVerified();
        $user->token_verify = null;
        $user->save();
        $data = [
            'name' => $user->name,
            'token' => $user->createToken('auth-token')->plainTextToken
        ];

        return [
            'message' => "Akun berhasil diverifikasi",
            'success' => true,
            'status_code' => 200,
            'data' => $data
        ];
    }

    public function resend($request){
        $otp = random_int(100000, 999999);
        $user = User::where('email', $request['email'])->whereNull('email_verified_at')->update([
            'token_verify' => $otp
        ]);
        if(!$user){
            return [
                'message' => "Email tidak valid",
                'success' => false,
                'status_code' => 422
            ];
        }

        SendEmail::dispatch($user->id);
        return [
            'message' => "Kode Verifikasi sudah di kirim ulang",
            'success' => true,
            'status_code' => 200
        ];
    }
}