import 'package:flutter/material.dart';
import 'package:toko/models/barang.dart';
import 'package:toko/services/api_service.dart';

class BarangViewmodel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool isLoading = false; //variable dalam class
  String? message;
  List<Barang> barangList = [];
  Barang? barang;

  Future<void> fetchBarang()async{
    isLoading = true;
    notifyListeners(); //beritahu jika variabel isLoading true (sedang loading)
    barangList = await apiService.getAllBarang();
    isLoading = false;
    notifyListeners(); //beritahu jika variabel isLoading false (loading selesai)
  }

  Future<bool> addBarang(gambarPath, String namaBarang, String merk, int stok, int harga)async{
    isLoading = true;
    message = null;
    notifyListeners();
    final newBarang = Barang(
      id: 0,
      gambar: gambarPath,
      namaBarang: namaBarang,
      merk: merk,
      stok: stok,
      harga: harga,
    );
    final response = await apiService.addBarang(newBarang);
    isLoading = false;
    message = response['message'] ?? "";
    notifyListeners();
    return(response['success'] as bool);
  }

  Future<bool> updateBarang(int barangId, String? gambarPath, String namaBarang, String merk, int stok, int harga)async{
    isLoading = true;
    message = null;
    notifyListeners();
    final updateBarang = Barang(
      id: barangId,
      gambar: gambarPath,
      namaBarang: namaBarang,
      merk: merk,
      stok: stok,
      harga: harga
    );
    final response = await apiService.updateBarang(updateBarang);
    isLoading = false;
    message = response['message'];
    notifyListeners();
    return (response['success'] as bool);
  }

  Future<void> deleteBarang(int barangId)async{
    isLoading = true;
    notifyListeners();
    await apiService.deleteBarang(barangId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> showBarang(int barangId)async{
    isLoading = true;
    barang = null;
    notifyListeners();
    barang = await apiService.showBarang(barangId);
    isLoading = false;
    notifyListeners();
  }

  // Future<XFile?> setGambar()async{
  //   final gambar = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   notifyListeners();
  //   if(gambar != null){
  //     return XFile(gambar.path);
  //   }else{
  //     return null;
  //   }
  // }
}