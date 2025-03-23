// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Sign in anonymously while preserving the password check
  Future<UserCredential> signInAnonymously(String password) async {
    // Check for the simple password "techy"
    if (password != "techy") {
      debugPrint('Password validation failed: $password');
      throw Exception('Invalid password');
    }
    
    // If password is correct, sign in anonymously
    debugPrint('Password validated, signing in anonymously');
    return await _auth.signInAnonymously();
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Check if user is currently authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}