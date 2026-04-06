<?php
namespace App\Services;

use App\Models\Post;
use App\Models\PostImage;
use Illuminate\Http\Request;

class PostService
{
    public function index(){
        $data = Post::with('user','postImage')->paginate(3);
        return [
            'message' => "Menampilkan data postingan",
            'success' => true,
            'status_code' => 200,
            'data' => [
                'post' => $data->items(),
                'pagination' => [
                    'current_page' => $data->currentPage(),
                    'last_page' => $data->lastPage()
                ]
            ]
        ];
    }

    public function store(Request $request){
        $user = $request->user();
        $post = Post::create([
            'user_id' => $user->id,
            'caption' => $request['caption']
        ]);
        
        if($request->hasFile('images')){
            foreach($request->file('images') as $index => $image){
                $nmimage = "image_" . ($index + 1) . time() . '.' . $image->getClientOriginalExtension();
                $imagePath = $image->storeAs('post/images', $nmimage, 'public');

                PostImage::create([
                    'post_id' => $post->id,
                    'image_path' => $imagePath
                ]);
            }
        }

        $data = $post->load('user','postImage');
        return [
            'success' => true,
            'message' => "Postingan berhasil di Upload",
            'status_code' => 201,
            'data' => $data
        ];
    }
}