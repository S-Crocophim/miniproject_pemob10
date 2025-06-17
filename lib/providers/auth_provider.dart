// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:miniproject_pemob10/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final success = await _apiService.login(username, password);
    _isLoggedIn = success;

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
