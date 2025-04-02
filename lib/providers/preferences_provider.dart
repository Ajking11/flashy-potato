// lib/providers/preferences_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/preferences_model.dart';
import '../services/user_service.dart';

class PreferencesProvider with ChangeNotifier {
  UserPreferences _preferences = UserPreferences.defaultPrefs();
  bool _isLoading = true;
  final UserService _userService = UserService();

  // Getters
  UserPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;

  // Initialize provider with stored preferences
  static Future<PreferencesProvider> initialize() async {
    final provider = PreferencesProvider();
    await provider._loadPreferences();
    return provider;
  }

  // Load preferences from Firestore first, fallback to local file
  Future<void> _loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      // First try to load from Firestore
      final firestorePrefs = await _userService.getUserPreferences();
      
      if (firestorePrefs != null) {
        _preferences = firestorePrefs;
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // Fallback to local file if Firestore fails
      await _loadFromLocalFile();
    } catch (e) {
      debugPrint('Error loading preferences from Firestore: $e');
      // Fallback to local file
      await _loadFromLocalFile();
    }
  }
  
  // Load preferences from local file (fallback)
  Future<void> _loadFromLocalFile() async {
    try {
      final file = await _getLocalPrefsFile();
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        _preferences = UserPreferences.fromJson(json.decode(jsonString));
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences from local file: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get the preferences file
  Future<File> _getLocalPrefsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_preferences.json');
  }

  // Save preferences to Firestore and local file as backup
  Future<void> _savePreferences() async {
    try {
      // Save to Firestore
      await _userService.saveUserPreferences(_preferences);
      
      // Also save to local file as backup
      final file = await _getLocalPrefsFile();
      await file.writeAsString(json.encode(_preferences.toJson()));
    } catch (e) {
      debugPrint('Error saving preferences: $e');
      // If Firestore fails, at least try to save locally
      try {
        final file = await _getLocalPrefsFile();
        await file.writeAsString(json.encode(_preferences.toJson()));
      } catch (localError) {
        debugPrint('Error saving preferences locally: $localError');
      }
    }
  }

  // Toggle favorite machine
  Future<void> toggleFavoriteMachine(String machineId) async {
    final List<String> updatedFavorites = List.from(_preferences.favoriteMachineIds);
    
    if (updatedFavorites.contains(machineId)) {
      updatedFavorites.remove(machineId);
    } else {
      updatedFavorites.add(machineId);
    }
    
    _preferences = _preferences.copyWith(favoriteMachineIds: updatedFavorites);
    await _savePreferences();
    notifyListeners();
  }

  // Toggle favorite filter
  Future<void> toggleFavoriteFilter(String filterType) async {
    final List<String> updatedFavorites = List.from(_preferences.favoriteFilterTypes);
    
    if (updatedFavorites.contains(filterType)) {
      updatedFavorites.remove(filterType);
    } else {
      updatedFavorites.add(filterType);
    }
    
    _preferences = _preferences.copyWith(favoriteFilterTypes: updatedFavorites);
    await _savePreferences();
    notifyListeners();
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences({
    bool? notifyDocumentUpdates,
    bool? notifyImportantInfo,
  }) async {
    _preferences = _preferences.copyWith(
      notifyDocumentUpdates: notifyDocumentUpdates,
      notifyImportantInfo: notifyImportantInfo,
    );
    await _savePreferences();
    notifyListeners();
  }
  
  // Update user email
  Future<void> updateUserEmail(String? email) async {
    // If email is being changed, reset confirmation status
    final bool resetConfirmation = email != _preferences.userEmail;
    
    _preferences = _preferences.copyWith(
      userEmail: email,
      isEmailConfirmed: resetConfirmation ? false : _preferences.isEmailConfirmed,
    );
    
    // Update email in Firebase Auth if provided
    if (email != null && email.isNotEmpty) {
      try {
        await _userService.updateEmail(email);
      } catch (e) {
        debugPrint('Error updating email in Firebase: $e');
        // Continue anyway, as we'll save it in preferences
      }
    }
    
    await _savePreferences();
    notifyListeners();
  }
  
  // Confirm the current email address
  Future<void> confirmUserEmail() async {
    if (_preferences.userEmail != null && _preferences.userEmail!.isNotEmpty) {
      _preferences = _preferences.copyWith(isEmailConfirmed: true);
      await _savePreferences();
      notifyListeners();
    }
  }
  
  // Reset email confirmation to allow editing
  Future<void> resetEmailConfirmation() async {
    _preferences = _preferences.copyWith(isEmailConfirmed: false);
    await _savePreferences();
    notifyListeners();
  }

  // Update last update check time
  Future<void> updateLastUpdateCheck() async {
    _preferences = _preferences.copyWith(lastUpdateCheck: DateTime.now());
    await _savePreferences();
    notifyListeners();
  }

  // Check if a machine is favorited
  bool isMachineFavorite(String machineId) {
    return _preferences.favoriteMachineIds.contains(machineId);
  }

  // Check if a filter is favorited
  bool isFilterFavorite(String filterType) {
    return _preferences.favoriteFilterTypes.contains(filterType);
  }
}