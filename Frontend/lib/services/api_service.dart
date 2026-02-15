import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko/models/barang.dart';

class ApiService {
  final String baseUrl = "http://192.168.0.100:8000/api";

  Future<Map<String, dynamic>> login(String email, String password)async{
    try{
      final response = await http.post(Uri.parse("$baseUrl/login"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        "password": password
      }));

      final responseData = json.decode(response.body);
      if(response.statusCode == 200 && responseData['success'] == true){
        final key = await SharedPreferences.getInstance();
        await key.setString("token", responseData['data']['token']);
        await key.setBool("statusLogin", true);
      }
      return responseData;
    }catch(e){
      return{
        "success": false,
        "message": e
      };
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password)async{
    try{
      final response = await http.post(Uri.parse("$baseUrl/register"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password
      }));
      
      final responseData = json.decode(response.body);
      if(response.statusCode == 201 && responseData['success'] == true){
        final key = await SharedPreferences.getInstance();
        await key.setString("token", responseData['data']['token']);
        await key.setBool("statusLogin", true);
      }

      return responseData;
    }catch(e){
      return{
        "success": false,
        "message": e
      };
    }
  }

  Future<List<Barang>> getAllBarang()async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString("token");

    try{
      final response = await http.get(Uri.parse("$baseUrl/barang"),
      headers: {"Authorization": "Bearer $token"});
      
      return(json.decode(response.body)['data'] as List).map((item) => Barang.fromJson(item)).toList();
    }catch(e){
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> addBarang(Barang barang)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString("token");

    try{
      final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/barang"));
      request.headers.addAll({"Authorization": "Bearer $token"});
      request.fields['nama_barang'] = barang.namaBarang;
      request.fields['merk'] = barang.merk;
      request.fields['stok'] = barang.stok.toString();
      request.fields['harga'] = barang.harga.toString();
      request.files.add(await http.MultipartFile.fromPath("gambar", barang.gambar!));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    }catch(e){
      return{
        "success": false,
        "message": e.toString()
      };
    }
  }

  Future<Map<String, dynamic>> updateBarang(Barang barang)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString("token");

    try{
      final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/barang/${barang.id}"));
      request.headers.addAll({"Authorization": "Bearer $token"});
      request.fields['_method'] = "PUT";
      request.fields['nama_barang'] = barang.namaBarang;
      request.fields['merk'] = barang.merk;
      request.fields['stok'] = barang.stok.toString();
      request.fields['harga'] = barang.harga.toString();
      if(barang.gambar != null){
        request.files.add(await http.MultipartFile.fromPath("gambar", barang.gambar!));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    }catch(e){
      return{
        "success": false,
        "message": e.toString()
      };
    }
  }

  Future<void> deleteBarang(int id)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString("token");
    try{
      await http.delete(Uri.parse("$baseUrl/barang/$id"),
      headers: {"Authorization": "Bearer $token"});
    }catch(e){
      throw Exception(e);
    }
  }

  Future<Barang> showBarang(int barangId)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString("token");

    try{
      final response = await http.get(Uri.parse("$baseUrl/barang/$barangId"),
      headers: {"Authorization": "Bearer $token"});

      return Barang.fromJson(json.decode(response.body)['data']);
    }catch(e){
      throw Exception(e);
    }
  }
}