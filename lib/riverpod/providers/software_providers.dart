// lib/riverpod/providers/software_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

typedef Ref = AutoDisposeProviderRef;
import '../../models/software.dart';
import '../notifiers/software_notifier.dart';

// Fixed Ref class undefined issue

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
  final software = ref.watch(softwareNotifierProvider).softwareList;
  try {
    return software.firstWhere((s) => s.id == softwareId);
  } catch (e) {
    return null;
  }
}

/// Provider for software error state
@riverpod
String? softwareError(Ref ref) {
  return ref.watch(softwareNotifierProvider).error;
}