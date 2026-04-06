<?php

namespace App\Http\Controllers;

use App\Http\Requests\PostStoreRequest;
use App\Services\PostService;

class PostApiController extends Controller
{
    //jika error karena service baru dibuat jalankan ini "composer dump-autoload"
    protected $postService;
    public function __construct(PostService $postService)
    {
        $this->postService = $postService;
    }

    public function index(){
        $data = $this->postService->index();
        return response()->json($data,$data['status_code']);
    }

    public function store(PostStoreRequest $postStoreRequest){
        // jika seperti ini $postStoreRequest->validated() akan return array dan di eksekusi di services
        // $request->user();     // ❌ butuh object Request
        // $request->hasFile();  // ❌ butuh object Request
        // $request->file();     // ❌ butuh object Request
        $data = $this->postService->store($postStoreRequest); //jika seperti ini return object dan di eksekusi di services
        return response()->json($data,$data['status_code']);
    }
}
