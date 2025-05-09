// lib/riverpod/providers/filter_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../notifiers/filter_notifier.dart'; // Moved import

part 'filter_providers.g.dart'; // Moved part directive

// Removed unnecessary import 'package:riverpod/riverpod.dart';
// Removed deprecated typedef Ref = AutoDisposeProviderRef;

/// Provider for checking if filters are loading
@riverpod
bool isFilterLoading(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).isLoading;
}

/// Provider for checking if filter calculation is in progress
@riverpod
bool isFilterCalculating(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).isCalculating;
}

/// Provider for accessing filter results
@riverpod
List<dynamic>? filteredData(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).filteredData;
}

/// Provider to check if we have filter results
@riverpod
bool hasFilterResults(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).hasResults;
}

/// Provider for getting filter size
@riverpod
String? filterSize(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).filterSize;
}

/// Provider for getting bypass
@riverpod
String? bypass(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).bypass;
}

/// Provider for getting capacity
@riverpod
int? capacity(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).capacity;
}

/// Provider for checking if expanded details should be shown
@riverpod
bool showExpandedDetails(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).showExpandedDetails;
}

/// Provider for getting filter error
@riverpod
String? filterError(Ref ref) { // Use generated Ref type
  return ref.watch(filterNotifierProvider).error;
}

// We'll access saved recommendations directly through filterNotifierProvider
// instead of using a separate provider to avoid code generation issues