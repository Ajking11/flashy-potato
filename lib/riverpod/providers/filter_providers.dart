// lib/riverpod/providers/filter_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

typedef Ref = AutoDisposeProviderRef;
import '../notifiers/filter_notifier.dart';

part 'filter_providers.g.dart';

// Fixed Ref class undefined issue

/// Provider for checking if filters are loading
@riverpod
bool isFilterLoading(Ref ref) {
  return ref.watch(filterNotifierProvider).isLoading;
}

/// Provider for checking if filter calculation is in progress
@riverpod
bool isFilterCalculating(Ref ref) {
  return ref.watch(filterNotifierProvider).isCalculating;
}

/// Provider for accessing filter results
@riverpod
List<dynamic>? filteredData(Ref ref) {
  return ref.watch(filterNotifierProvider).filteredData;
}

/// Provider to check if we have filter results
@riverpod
bool hasFilterResults(Ref ref) {
  return ref.watch(filterNotifierProvider).hasResults;
}

/// Provider for getting filter size
@riverpod
String? filterSize(Ref ref) {
  return ref.watch(filterNotifierProvider).filterSize;
}

/// Provider for getting bypass
@riverpod
String? bypass(Ref ref) {
  return ref.watch(filterNotifierProvider).bypass;
}

/// Provider for getting capacity
@riverpod
int? capacity(Ref ref) {
  return ref.watch(filterNotifierProvider).capacity;
}

/// Provider for checking if expanded details should be shown
@riverpod
bool showExpandedDetails(Ref ref) {
  return ref.watch(filterNotifierProvider).showExpandedDetails;
}

/// Provider for getting filter error
@riverpod
String? filterError(Ref ref) {
  return ref.watch(filterNotifierProvider).error;
}

// We'll access saved recommendations directly through filterNotifierProvider
// instead of using a separate provider to avoid code generation issues