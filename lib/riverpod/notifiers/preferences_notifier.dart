// lib/riverpod/notifiers/preferences_notifier.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/preferences_model.dart';
import '../../services/user_service.dart';
import '../states/preferences_state.dart';

part 'preferences_notifier.g.dart';

@riverpod
class PreferencesNotifier extends _$PreferencesNotifier {
  late final UserService _userService;
  
  @override
  PreferencesState build() {
    _userService = UserService();
    _loadPreferences();
    return PreferencesState.initial();
  }

  // Load preferences from Firestore first, fallback to local file
  Future<void> _loadPreferences() async {
    state = state.copyWith(isLoading: true);

    try {
      // First try to load from Firestore
      final firestorePrefs = await _userService.getUserPreferences();
      
      if (firestorePrefs != null) {
        state = state.copyWith(
          preferences: firestorePrefs,
          isLoading: false,
        );
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
        final loadedPrefs = UserPreferences.fromJson(json.decode(jsonString));
        state = state.copyWith(
          preferences: loadedPrefs,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('Error loading preferences from local file: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load preferences',
      );
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
      await _userService.saveUserPreferences(state.preferences);
      
      // Also save to local file as backup
      final file = await _getLocalPrefsFile();
      await file.writeAsString(json.encode(state.preferences.toJson()));
    } catch (e) {
      debugPrint('Error saving preferences: $e');
      // If Firestore fails, at least try to save locally
      try {
        final file = await _getLocalPrefsFile();
        await file.writeAsString(json.encode(state.preferences.toJson()));
      } catch (localError) {
        debugPrint('Error saving preferences locally: $localError');
        state = state.copyWith(error: 'Failed to save preferences');
      }
    }
  }

  // Toggle favorite machine
  Future<void> toggleFavoriteMachine(String machineId) async {
    final List<String> updatedFavorites = List.from(state.preferences.favoriteMachineIds);
    
    if (updatedFavorites.contains(machineId)) {
      updatedFavorites.remove(machineId);
    } else {
      updatedFavorites.add(machineId);
    }
    
    state = state.copyWith(
      preferences: state.preferences.copyWith(favoriteMachineIds: updatedFavorites),
    );
    await _savePreferences();
  }

  // Toggle favorite filter
  Future<void> toggleFavoriteFilter(String filterType) async {
    final List<String> updatedFavorites = List.from(state.preferences.favoriteFilterTypes);
    
    if (updatedFavorites.contains(filterType)) {
      updatedFavorites.remove(filterType);
    } else {
      updatedFavorites.add(filterType);
    }
    
    state = state.copyWith(
      preferences: state.preferences.copyWith(favoriteFilterTypes: updatedFavorites),
    );
    await _savePreferences();
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences({
    bool? notifyDocumentUpdates,
    bool? notifyImportantInfo,
  }) async {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        notifyDocumentUpdates: notifyDocumentUpdates,
        notifyImportantInfo: notifyImportantInfo,
      ),
    );
    await _savePreferences();
  }
  
  // Update user email
  Future<void> updateUserEmail(String? email) async {
    // If email is being changed, reset confirmation status
    final bool resetConfirmation = email != state.preferences.userEmail;
    
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        userEmail: email,
        isEmailConfirmed: resetConfirmation ? false : state.preferences.isEmailConfirmed,
      ),
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
  }
  
  // Confirm the current email address
  Future<void> confirmUserEmail() async {
    if (state.preferences.userEmail != null && state.preferences.userEmail!.isNotEmpty) {
      state = state.copyWith(
        preferences: state.preferences.copyWith(isEmailConfirmed: true),
      );
      await _savePreferences();
    }
  }
  
  // Reset email confirmation to allow editing
  Future<void> resetEmailConfirmation() async {
    state = state.copyWith(
      preferences: state.preferences.copyWith(isEmailConfirmed: false),
    );
    await _savePreferences();
  }

  // Update last update check time
  Future<void> updateLastUpdateCheck() async {
    state = state.copyWith(
      preferences: state.preferences.copyWith(lastUpdateCheck: DateTime.now()),
    );
    await _savePreferences();
  }

  // Check if a machine is favorited
  bool isMachineFavorite(String machineId) {
    return state.preferences.favoriteMachineIds.contains(machineId);
  }

  // Check if a filter is favorited
  bool isFilterFavorite(String filterType) {
    return state.preferences.favoriteFilterTypes.contains(filterType);
  }
}