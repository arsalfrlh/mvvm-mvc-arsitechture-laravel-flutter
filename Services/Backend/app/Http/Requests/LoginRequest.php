<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class LoginRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        //bisa di pakai bebas | return auth()->check | return auth()->user()->role == "admin" | return auth()->id() == $this->route('id');
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'email' => 'required|email',
            'password' => 'required'
        ];
    }

    protected function failedValidation(Validator $validator) //function untuk mengembalikan request error dlm json
    {
        throw new HttpResponseException(response()->json([
            'message' => $validator->errors()->all(),
            'success' => false
        ], 422));
    }
}
