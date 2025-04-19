// lib/riverpod/providers/preferences_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

typedef Ref = AutoDisposeProviderRef;
import '../../models/preferences_model.dart';
import '../notifiers/preferences_notifier.dart';

part 'preferences_providers.g.dart';

// Add explicit Ref typedef to fix undefined class error
typedef Ref = AutoDisposeProviderRef;

/// Provider for accessing UserPreferences
@riverpod
UserPreferences userPreferences(Ref ref) {
  return ref.watch(preferencesNotifierProvider).preferences;
}

/// Provider for checking if preferences are loading
@riverpod
bool isPreferencesLoading(Ref ref) {
  return ref.watch(preferencesNotifierProvider).isLoading;
}

/// Provider for checking if a machine is favorited
@riverpod
bool isMachineFavorite(Ref ref, String machineId) {
  return ref.watch(preferencesNotifierProvider.notifier).isMachineFavorite(machineId);
}

/// Provider for checking if a filter is favorited
@riverpod
bool isFilterFavorite(Ref ref, String filterType) {
  return ref.watch(preferencesNotifierProvider.notifier).isFilterFavorite(filterType);
}

/// Provider for checking if user has email
@riverpod
bool hasUserEmail(Ref ref) {
  final email = ref.watch(userPreferencesProvider).userEmail;
  return email != null && email.isNotEmpty;
}

/// Provider for checking if email is confirmed
@riverpod
bool isEmailConfirmed(Ref ref) {
  return ref.watch(userPreferencesProvider).isEmailConfirmed;
}