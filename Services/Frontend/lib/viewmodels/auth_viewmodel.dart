import 'package:flutter/material.dart';
import 'package:toko/models/user.dart';
import 'package:toko/services/api_service.dart';

class AuthViewmodel extends ChangeNotifier {
  final _apiService = ApiService();
  bool isLoading = false;
  String? message;
  User? currentUser;

  Future<dynamic> login(String email, String password) async {
    isLoading = true;
    message = null;
    notifyListeners();
    final response = await _apiService.login(email, password);
    message = response['success'] is bool
        ? response['success'] as bool
            ? "${response['message']}, Selamat datang ${response['data']['name']}"
            : response['message']
        : response['message'];
    isLoading = false;
    notifyListeners();
    return response['success'];
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    message = null;
    notifyListeners();
    final response = await _apiService.register(name, email, password);
    isLoading = false;
    message = response['message'];
    notifyListeners();
    return (response['success'] as bool);
  }

  Future<bool> verify(int otp) async {
    isLoading = true;
    message = null;
    notifyListeners();
    final response = await _apiService.verify(otp);
    isLoading = false;
    message = response['message'];
    notifyListeners();
    return (response['success'] as bool);
  }

  Future<void> getUser() async {
    isLoading = true;
    notifyListeners();
    currentUser = await _apiService.currentUser();
    isLoading = false;
    notifyListeners();
  }
}
