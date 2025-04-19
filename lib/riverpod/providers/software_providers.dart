// lib/riverpod/providers/software_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/software.dart';
import '../notifiers/software_notifier.dart';


part 'software_providers.g.dart';

/// Provider for accessing all software
@riverpod
List<Software> softwareList(Ref ref) {
  return ref.watch(softwareNotifierProvider).softwareList;
}

/// Provider for accessing filtered software
@riverpod
List<Software> filteredSoftwareList(Ref ref) {
  return ref.watch(softwareNotifierProvider).filteredSoftwareList;
}

/// Provider for checking if software is loading
@riverpod
bool isSoftwareLoading(Ref ref) {
  return ref.watch(softwareNotifierProvider).isLoading;
}

/// Provider for current search query
@riverpod
String softwareSearchQuery(Ref ref) {
  return ref.watch(softwareNotifierProvider).searchQuery;
}

/// Provider for selected machine ID filter
@riverpod
String? softwareSelectedMachineId(Ref ref) {
  return ref.watch(softwareNotifierProvider).selectedMachineId;
}

/// Provider for selected category filter
@riverpod
String? softwareSelectedCategory(Ref ref) {
  return ref.watch(softwareNotifierProvider).selectedCategory;
}

/// Provider for software download progress
@riverpod
double softwareDownloadProgress(Ref ref, String softwareId) {
  return ref.watch(softwareNotifierProvider).getDownloadProgress(softwareId);
}

/// Provider to check if a software is currently downloading
@riverpod
bool isSoftwareDownloading(Ref ref, String softwareId) {
  return ref.watch(softwareNotifierProvider).isDownloading(softwareId);
}

/// Provider to get a specific software by ID
@riverpod
Software? softwareById(Ref ref, String softwareId) {
  // Watching the whole list provider might cause unnecessary rebuilds
  // if only one software changes but it's not the one we are looking for.
  // Consider watching the notifier directly if performance becomes an issue.
  final softwareList = ref.watch(softwareNotifierProvider).softwareList;
  try {
    return softwareList.firstWhere((s) => s.id == softwareId);
  } catch (e) {
    // Consider logging the error or handling it differently
    return null;
  }
}

/// Provider for software error state
@riverpod
String? softwareError(Ref ref) {
  return ref.watch(softwareNotifierProvider).error;
}