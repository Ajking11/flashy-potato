// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Sign in with email and password using Firebase Authentication
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      debugPrint('Sign-in error: $e');
      throw Exception('Failed to sign in: ${_getFirebaseAuthErrorMessage(e)}');
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Check if user is currently authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
  
  // Get current user email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }
  
  // Create a new user account (used by admins)
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      debugPrint('User creation error: $e');
      throw Exception('Failed to create account: ${_getFirebaseAuthErrorMessage(e)}');
    }
  }
  
  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Password reset email error: $e');
      throw Exception('Failed to send password reset email: ${_getFirebaseAuthErrorMessage(e)}');
    }
  }
  
  // Helper method to get user-friendly error messages from Firebase Auth errors
  String _getFirebaseAuthErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'This email address is already in use.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        case 'weak-password':
          return 'The password is too weak.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Check your connection.';
        default:
          return error.message ?? 'An unknown error occurred.';
      }
    }
    return 'An unexpected error occurred.';
  }
}