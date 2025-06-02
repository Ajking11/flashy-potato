// lib/riverpod/states/document_state.dart
import 'package:flutter/foundation.dart';
import '../../models/document.dart';

@immutable
class DocumentState {
  final List<TechnicalDocument> documents;
  final List<TechnicalDocument> filteredDocuments;
  final bool isLoading;
  final String searchQuery;
  final String? selectedMachineId;
  final String? selectedCategory;
  final Map<String, double> downloadProgress;
  final String? error;

  const DocumentState({
    this.documents = const [],
    this.filteredDocuments = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.selectedMachineId,
    this.selectedCategory,
    this.downloadProgress = const {},
    this.error,
  });

  factory DocumentState.initial() {
    return const DocumentState();
  }

  DocumentState copyWith({
    List<TechnicalDocument>? documents,
    List<TechnicalDocument>? filteredDocuments,
    bool? isLoading,
    String? searchQuery,
    Object? selectedMachineId = _undefined,
    Object? selectedCategory = _undefined,
    Map<String, double>? downloadProgress,
    Object? error = _undefined,
  }) {
    return DocumentState(
      documents: documents ?? this.documents,
      filteredDocuments: filteredDocuments ?? this.filteredDocuments,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMachineId: selectedMachineId == _undefined ? this.selectedMachineId : selectedMachineId as String?,
      selectedCategory: selectedCategory == _undefined ? this.selectedCategory : selectedCategory as String?,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      error: error == _undefined ? this.error : error as String?,
    );
  }

  static const Object _undefined = Object();

  // Get download progress for a specific document
  double getDownloadProgress(String documentId) {
    return downloadProgress[documentId] ?? 0.0;
  }

  // Check if a document is currently downloading
  bool isDownloading(String documentId) {
    final progress = downloadProgress[documentId];
    return progress != null && progress > 0 && progress < 1.0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentState &&
        other.isLoading == isLoading &&
        other.searchQuery == searchQuery &&
        other.selectedMachineId == selectedMachineId &&
        other.selectedCategory == selectedCategory &&
        other.error == error &&
        mapEquals(other.downloadProgress, downloadProgress) &&
        listEquals(other.documents, documents) &&
        listEquals(other.filteredDocuments, filteredDocuments);
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      searchQuery,
      selectedMachineId,
      selectedCategory,
      error,
      Object.hashAll(documents),
      Object.hashAll(filteredDocuments),
      Object.hashAll(downloadProgress.entries),
    );
  }
}