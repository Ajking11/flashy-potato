// lib/riverpod/states/preferences_state.dart
import 'package:flutter/foundation.dart';
import '../../models/preferences_model.dart';

@immutable
class PreferencesState {
  final UserPreferences preferences;
  final bool isLoading;
  final String? error;

  const PreferencesState({
    required this.preferences,
    this.isLoading = false,
    this.error,
  });

  factory PreferencesState.initial() {
    return PreferencesState(
      preferences: UserPreferences.defaultPrefs(),
      isLoading: true,
    );
  }

  PreferencesState copyWith({
    UserPreferences? preferences,
    bool? isLoading,
    String? error,
  }) {
    return PreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}