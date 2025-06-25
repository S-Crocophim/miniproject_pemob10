// lib/providers/auth_provider.dart
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
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        errorMessage = 'Email yang Anda masukkan tidak terdaftar.';
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
  
  // FUNGSI BARU: Mengirim email reset password
  Future<String?> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    String? resultMessage;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      resultMessage = "Link reset password telah dikirim ke email Anda.";
    } on FirebaseAuthException catch(e) {
       if (e.code == 'user-not-found') {
        resultMessage = 'Email tidak terdaftar.';
       } else {
        resultMessage = 'Gagal mengirim email: ${e.message}';
       }
    }
    _isLoading = false;
    notifyListeners();
    return resultMessage;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}