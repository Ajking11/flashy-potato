// lib/riverpod/providers/document_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/document.dart';
import '../notifiers/document_notifier.dart';

part 'document_providers.g.dart';

/// Provider for accessing all documents
@riverpod
List<TechnicalDocument> documents(DocumentsRef ref) {
  return ref.watch(documentNotifierProvider).documents;
}

/// Provider for accessing filtered documents
@riverpod
List<TechnicalDocument> filteredDocuments(FilteredDocumentsRef ref) {
  return ref.watch(documentNotifierProvider).filteredDocuments;
}

/// Provider for checking if documents are loading
@riverpod
bool isDocumentsLoading(IsDocumentsLoadingRef ref) {
  return ref.watch(documentNotifierProvider).isLoading;
}

/// Provider for current search query
@riverpod
String documentSearchQuery(DocumentSearchQueryRef ref) {
  return ref.watch(documentNotifierProvider).searchQuery;
}

/// Provider for selected machine ID filter
@riverpod
String? selectedMachineId(SelectedMachineIdRef ref) {
  return ref.watch(documentNotifierProvider).selectedMachineId;
}

/// Provider for selected category filter
@riverpod
String? selectedCategory(SelectedCategoryRef ref) {
  return ref.watch(documentNotifierProvider).selectedCategory;
}

/// Provider for document download progress
@riverpod
double documentDownloadProgress(DocumentDownloadProgressRef ref, String documentId) {
  return ref.watch(documentNotifierProvider).getDownloadProgress(documentId);
}

/// Provider to check if a document is currently downloading
@riverpod
bool isDocumentDownloading(IsDocumentDownloadingRef ref, String documentId) {
  return ref.watch(documentNotifierProvider).isDownloading(documentId);
}

/// Provider to get a specific document by ID
@riverpod
TechnicalDocument? documentById(DocumentByIdRef ref, String documentId) {
  final documents = ref.watch(documentNotifierProvider).documents;
  try {
    return documents.firstWhere((doc) => doc.id == documentId);
  } catch (e) {
    return null;
  }
}

/// Provider for document error state
@riverpod
String? documentError(DocumentErrorRef ref) {
  return ref.watch(documentNotifierProvider).error;
}