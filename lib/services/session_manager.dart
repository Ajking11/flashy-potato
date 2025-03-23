// lib/services/session_manager.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class SessionManager {
  static final AuthService _authService = AuthService();
  
  // Clear the session
  static Future<void> clearSession() async {
    if (_authService.isAuthenticated()) {
      await _authService.signOut();
    }
  }
  
  // Set logged in status using email and password
  static Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    return await _authService.signInWithEmailAndPassword(email, password);
  }
  
  // Check if logged in
  static bool isLoggedIn() {
    return _authService.isAuthenticated();
  }
  
  // Get current user email
  static String? getCurrentUserEmail() {
    return _authService.getCurrentUserEmail();
  }
  
  // Request password reset
  static Future<void> requestPasswordReset(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }
}