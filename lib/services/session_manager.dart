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
  
  // Set logged in status using password
  static Future<UserCredential> setLoggedIn(String password) async {
    return await _authService.signInAnonymously(password);
  }
  
  // Check if logged in
  static bool isLoggedIn() {
    return _authService.isAuthenticated();
  }
}