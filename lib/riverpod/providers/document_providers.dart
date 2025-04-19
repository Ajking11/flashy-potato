// lib/riverpod/providers/document_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

typedef Ref = AutoDisposeProviderRef;
import '../../models/document.dart';
import '../notifiers/document_notifier.dart';

part 'document_providers.g.dart';

// Add explicit Ref typedef to fix undefined class error
typedef Ref = AutoDisposeProviderRef;

/// Provider for accessing all documents
@riverpod
List<TechnicalDocument> documents(Ref ref) {
  return ref.watch(documentNotifierProvider).documents;
}

/// Provider for accessing filtered documents
@riverpod
List<TechnicalDocument> filteredDocuments(Ref ref) {
  return ref.watch(documentNotifierProvider).filteredDocuments;
}

/// Provider for checking if documents are loading
@riverpod
bool isDocumentsLoading(Ref ref) {
  return ref.watch(documentNotifierProvider).isLoading;
}

/// Provider for current search query
@riverpod
String documentSearchQuery(Ref ref) {
  return ref.watch(documentNotifierProvider).searchQuery;
}

/// Provider for selected machine ID filter
@riverpod
String? selectedMachineId(Ref ref) {
  return ref.watch(documentNotifierProvider).selectedMachineId;
}

/// Provider for selected category filter
@riverpod
String? selectedCategory(Ref ref) {
  return ref.watch(documentNotifierProvider).selectedCategory;
}

/// Provider for document download progress
@riverpod
double documentDownloadProgress(Ref ref, String documentId) {
  return ref.watch(documentNotifierProvider).getDownloadProgress(documentId);
}

/// Provider to check if a document is currently downloading
@riverpod
bool isDocumentDownloading(Ref ref, String documentId) {
  return ref.watch(documentNotifierProvider).isDownloading(documentId);
}

/// Provider to get a specific document by ID
@riverpod
TechnicalDocument? documentById(Ref ref, String documentId) {
  final documents = ref.watch(documentNotifierProvider).documents;
  try {
    return documents.firstWhere((doc) => doc.id == documentId);
  } catch (e) {
    return null;
  }
}

/// Provider for document error state
@riverpod
String? documentError(Ref ref) {
  return ref.watch(documentNotifierProvider).error;
}