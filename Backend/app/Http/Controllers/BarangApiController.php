<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class BarangApiController extends Controller
{
    public function index(){
        $data = Barang::all();
        return response()->json(['message' => "Menampilkan semua data barang", 'success' => true, 'data' => $data], 200);
    }

    public function store(Request $request){
        $validator = Validator::make($request->all(),[
            'gambar' => 'required|image|mimes:png,jpg,jpeg',
            'nama_barang' => 'required',
            'merk' => 'required',
            'stok' => 'required|numeric',
            'harga' => 'required|numeric'
        ]);

        if($validator->fails()){
            return response()->json(['message' => $validator->errors()->all(), 'success' => false], 422);
        }

        $gambar = $request->file('gambar');
        $nmgambar = 'image_' . time() . '.' . $gambar->getClientOriginalExtension();
        $gambar->storeAs('images',$nmgambar,'public');

        $data = Barang::create([
            'gambar' => $nmgambar,
            'nama_barang' => $request->nama_barang,
            'merk' => $request->merk,
            'stok' => $request->stok,
            'harga' => $request->harga
        ]);

        return response()->json(['message' => "Barang berhasil ditambahkan", 'success' => true, 'data' => $data], 201);
    }

    public function show($id){
        $barang = Barang::findOrFail($id);
        return response()->json(['message' => "Menampilakan barang", 'success' => true, 'data' => $barang], 200);
    }

    public function update(Request $request, $id){
        $validator = Validator::make($request->all(),[
            'gambar' => 'nullable|image|mimes:png,jpg,jpeg',
            'nama_barang' => 'required',
            'merk' => 'required',
            'stok' => 'required|numeric',
            'harga' => 'required|numeric'
        ]);

        if($validator->fails()){
            return response()->json(['message' => $validator->errors()->all(), 'success' => false], 422);
        }

        $barang = Barang::findOrFail($id);
        if($request->hasFile('gambar')){
            if(Storage::disk('public')->exists('images/' . $barang->gambar)){
                Storage::disk('public')->delete('images/' . $barang->gambar);
            }

            $gambar = $request->file('gambar');
            $nmgambar = 'image_' . time() . '.' . $gambar->getClientOriginalExtension();
            $gambar->storeAs('images',$nmgambar,'public');
        }else{
            $nmgambar = $barang->gambar;
        }

        $barang->update([
            'gambar' => $nmgambar,
            'nama_barang' => $request->nama_barang,
            'merk' => $request->merk,
            'stok' => $request->stok,
            'harga' => $request->harga
        ]);

        return response()->json(['message' => "Barang berhasil diupdate", 'success' => true, 'data' => $barang], 200);
    }

    public function destroy($id){
        $barang = Barang::findOrFail($id);
        if(Storage::disk('public')->exists('images/' . $barang->gambar)){
            Storage::disk('public')->delete('images/' . $barang->gambar);
        }

        $barang->delete();
        return response()->json(['message' => "Barang telah dihapus", 'success' => true], 200);
    }
}
