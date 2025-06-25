import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    String? errorMessage;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'Pengguna dengan email ini tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password yang dimasukkan salah.';
      } else {
        errorMessage = 'Terjadi kesalahan: ${e.message}';
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
    }

    _isLoading = false;
    notifyListeners();
    return errorMessage;
  }

  Future<String?> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    String? errorMessage;
    try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
        errorMessage = 'Gagal mendaftar: ${e.message}';
    }
    _isLoading = false;
    notifyListeners();
    return errorMessage;
  }
  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}