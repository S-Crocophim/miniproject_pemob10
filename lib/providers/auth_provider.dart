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
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }
    } catch (e) {
      errorMessage = 'An unknown error occurred.';
    }

    _isLoading = false;
    notifyListeners();
    return errorMessage;
  }
  
  Future<String?> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    String? resultMessage;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      resultMessage = "A password reset link has been sent to your email.";
    } on FirebaseAuthException catch(e) {
       if (e.code == 'user-not-found') {
        resultMessage = 'This email is not registered.';
       } else {
        resultMessage = 'Failed to send email: ${e.message}';
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