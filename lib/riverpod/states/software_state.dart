// lib/riverpod/states/software_state.dart
import 'package:flutter/foundation.dart';
import '../../models/software.dart';

@immutable
class SoftwareState {
  final List<Software> softwareList;
  final List<Software> filteredSoftwareList;
  final bool isLoading;
  final String searchQuery;
  final String? selectedMachineId;
  final String? selectedCategory;
  final Map<String, double> downloadProgress;
  final String? error;

  const SoftwareState({
    this.softwareList = const [],
    this.filteredSoftwareList = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.selectedMachineId,
    this.selectedCategory,
    this.downloadProgress = const {},
    this.error,
  });

  factory SoftwareState.initial() {
    return const SoftwareState();
  }

  SoftwareState copyWith({
    List<Software>? softwareList,
    List<Software>? filteredSoftwareList,
    bool? isLoading,
    String? searchQuery,
    String? selectedMachineId,
    String? selectedCategory,
    Map<String, double>? downloadProgress,
    String? error,
  }) {
    return SoftwareState(
      softwareList: softwareList ?? this.softwareList,
      filteredSoftwareList: filteredSoftwareList ?? this.filteredSoftwareList,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMachineId: selectedMachineId ?? this.selectedMachineId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      error: error,
    );
  }

  // Get download progress for a specific software
  double getDownloadProgress(String softwareId) {
    return downloadProgress[softwareId] ?? 0.0;
  }

  // Check if software is currently downloading
  bool isDownloading(String softwareId) {
    final progress = downloadProgress[softwareId];
    return progress != null && progress > 0 && progress < 1.0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SoftwareState &&
        other.isLoading == isLoading &&
        other.searchQuery == searchQuery &&
        other.selectedMachineId == selectedMachineId &&
        other.selectedCategory == selectedCategory &&
        other.error == error &&
        mapEquals(other.downloadProgress, downloadProgress) &&
        listEquals(other.softwareList, softwareList) &&
        listEquals(other.filteredSoftwareList, filteredSoftwareList);
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      searchQuery,
      selectedMachineId,
      selectedCategory,
      error,
      Object.hashAll(softwareList),
      Object.hashAll(filteredSoftwareList),
      Object.hashAll(downloadProgress.entries),
    );
  }
}