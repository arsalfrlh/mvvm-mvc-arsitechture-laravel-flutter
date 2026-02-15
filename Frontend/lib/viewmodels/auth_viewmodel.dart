import 'package:flutter/material.dart';
import 'package:toko/services/api_service.dart';

class AuthViewmodel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool isLoading = false;
  String? message;

  Future<bool> login(String email, String password)async{
    isLoading = true;
    message = null;
    notifyListeners(); //beritahu jika variabel isLoading true (sedang loading) dan message null

    final response = await apiService.login(email, password);
    message = (response['success'] as bool) ? "${response['message']}, Selamat datang ${response['data']['name']}" : response['message'];
    isLoading = false;
    notifyListeners(); //beritahu jika variabel isLoading false (loading selesai) dan message tidak null
    return (response['success'] as bool);
  }

  Future<bool> register(String name, String email, String password)async{
    isLoading = true;
    message = null;
    notifyListeners();

    final response = await apiService.register(name, email, password);
    message = (response['success'] as bool) ? "${response['message']}, Selamat datang ${response['data']['name']}" : response['message'];
    isLoading = false;
    notifyListeners();
    return (response['success'] as bool);
  }
}