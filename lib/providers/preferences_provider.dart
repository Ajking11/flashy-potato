// file_preferences_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/preferences_model.dart';

class PreferencesProvider with ChangeNotifier {
  UserPreferences _preferences = UserPreferences.defaultPrefs();
  bool _isLoading = true;

  // Getters
  UserPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _preferences.isDarkMode;

  // Initialize provider with stored preferences
  static Future<PreferencesProvider> initialize() async {
    final provider = PreferencesProvider();
    await provider._loadPreferences();
    return provider;
  }

  // Get the preferences file
  Future<File> get _prefsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_preferences.json');
  }

  // Load preferences from file
  Future<void> _loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final file = await _prefsFile;
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        _preferences = UserPreferences.fromJson(json.decode(jsonString));
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save preferences to file
  Future<void> _savePreferences() async {
    try {
      final file = await _prefsFile;
      await file.writeAsString(json.encode(_preferences.toJson()));
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _preferences = _preferences.copyWith(isDarkMode: !_preferences.isDarkMode);
    await _savePreferences();
    notifyListeners();
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