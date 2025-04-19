// lib/riverpod/providers/preferences_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/preferences_model.dart';
import '../notifiers/preferences_notifier.dart';

part 'preferences_providers.g.dart';


/// Provider for accessing UserPreferences
@riverpod
UserPreferences userPreferences(Ref ref) {
  // Watch the notifier state and return the preferences object
  return ref.watch(preferencesNotifierProvider).preferences;
}

/// Provider for checking if preferences are loading
@riverpod
bool isPreferencesLoading(Ref ref) {
  // Watch the notifier state and return the loading status
  return ref.watch(preferencesNotifierProvider).isLoading;
}

/// Provider for checking if a machine is favorited
@riverpod
bool isMachineFavorite(Ref ref, String machineId) {
  // Implementation will depend on your UserPreferences model
  // This is a placeholder implementation
  final favoriteIds = ref.watch(userPreferencesProvider).favoriteMachineIds ?? [];
  return favoriteIds.contains(machineId);
}

/// Provider for checking if a filter is favorited
@riverpod
bool isFilterFavorite(Ref ref, String filterType) {
  // Implementation will depend on your UserPreferences model
  // This is a placeholder implementation
  final favoriteFilters = ref.watch(userPreferencesProvider).favoriteFilterTypes ?? [];
  return favoriteFilters.contains(filterType);
}

/// Provider for checking if user has email
@riverpod
bool hasUserEmail(Ref ref) {
  // Watch the userPreferencesProvider and check if the email is set
  final email = ref.watch(userPreferencesProvider).userEmail;
  return email != null && email.isNotEmpty;
}

/// Provider for checking if email is confirmed
@riverpod
bool isEmailConfirmed(Ref ref) {
  // Watch the userPreferencesProvider and return the email confirmation status
  return ref.watch(userPreferencesProvider).isEmailConfirmed;
}