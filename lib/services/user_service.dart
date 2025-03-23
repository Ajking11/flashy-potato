// lib/services/user_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/preferences_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get current user ID (or anonymous ID)
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get user preferences from Firestore
  Future<UserPreferences?> getUserPreferences() async {
    if (currentUserId == null) return null;
    
    try {
      final DocumentSnapshot snapshot = 
          await _firestore.collection('user_preferences').doc(currentUserId).get();
      
      if (!snapshot.exists) {
        return UserPreferences.defaultPrefs();
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      return UserPreferences.fromJson(data);
    } catch (e) {
      debugPrint('Error fetching user preferences: $e');
      return null;
    }
  }
  
  // Save user preferences to Firestore
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    if (currentUserId == null) return;
    
    try {
      await _firestore.collection('user_preferences').doc(currentUserId).set(
        preferences.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
      throw Exception('Failed to save preferences: $e');
    }
  }
  
  // Update email and send verification
  Future<void> updateEmail(String email) async {
    if (currentUserId == null) return;
    
    try {
      // We can't directly update email for anonymous users
      // Instead, we'll store it in Firestore
      await _firestore.collection('user_preferences').doc(currentUserId).update({
        'userEmail': email,
      });
    } catch (e) {
      debugPrint('Error updating email: $e');
      throw Exception('Failed to update email: $e');
    }
  }
}