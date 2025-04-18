// lib/riverpod/notifiers/document_notifier.dart
import 'dart:io';
import 'dart:convert';
// We don't actually need Material imports in this file
// import 'package:flutter/material.dart' hide debugPrint;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/document.dart';
import '../../services/firebase_document_service.dart';
import '../states/document_state.dart';

part 'document_notifier.g.dart';

@riverpod
class DocumentNotifier extends _$DocumentNotifier {
  late final FirebaseDocumentService _documentService;
  
  @override
  DocumentState build() {
    _documentService = FirebaseDocumentService();
    _loadDocuments();
    return DocumentState.initial();
  }

  // Get document by ID from local cache
  TechnicalDocument? getDocumentById(String id) {
    try {
      return state.documents.firstWhere((doc) => doc.id == id);
    } catch (e) {
      debugPrint('Document not found in local cache: $id');
      return null;
    }
  }
  
  // Get document by ID from Firestore if not in local cache
  Future<TechnicalDocument?> fetchDocumentById(String id) async {
    // First try to get from local cache
    TechnicalDocument? doc = getDocumentById(id);
    if (doc != null) {
      return doc;
    }
    
    // If not in cache, fetch from Firestore
    try {
      doc = await _documentService.getDocumentById(id);
      
      // If found, add to local cache
      if (doc != null) {
        // Check if it's downloaded
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/${doc.id}.pdf';
        final file = File(filePath);
        final isDownloaded = await file.exists();
        
        // Add to documents with download status
        final documentWithDownloadStatus = doc.copyWith(isDownloaded: isDownloaded);
        
        // Update state with new document
        final updatedDocuments = [...state.documents, documentWithDownloadStatus];
        state = state.copyWith(
          documents: updatedDocuments,
        );
        
        // Apply filters
        _applyFilters();
        
        return documentWithDownloadStatus;
      }
    } catch (e) {
      debugPrint('Error fetching document from Firestore: $e');
      state = state.copyWith(error: 'Error fetching document: $e');
    }
    
    return null;
  }

  // Load documents from Firestore
  Future<void> _loadDocuments() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load documents from Firebase
      final documents = await _documentService.getAllDocuments();
      
      // Log document count for debugging
      debugPrint('Loaded ${documents.length} documents from Firebase');
      for (var doc in documents) {
        debugPrint('Document: ${doc.id} - ${doc.title}');
      }
      
      // If no documents are found from Firebase, load from local JSON as fallback
      if (documents.isEmpty) {
        debugPrint('No documents found in Firebase, loading from local JSON');
        await _loadLocalDocuments();
        return;
      }
      
      // Sort documents by most recent first
      documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      // Check which documents are downloaded locally
      final documentIds = documents.map((doc) => doc.id).toList();
      final downloadStatus = await _documentService.checkDownloadedDocuments(documentIds);
      
      // Update download status for each document
      final updatedDocuments = documents.map((doc) {
        return doc.copyWith(
          isDownloaded: downloadStatus[doc.id] ?? false,
        );
      }).toList();
      
      state = state.copyWith(
        documents: updatedDocuments,
        isLoading: false,
      );
      
      // Apply filters to initialize filtered documents
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading documents from Firebase: $e');
      debugPrint('Full error details: ${e.toString()}');
      
      // Always fall back to local JSON for now to ensure documents are shown
      debugPrint('Loading local documents as fallback');
      await _loadLocalDocuments();
    }
  }
  
  // Refresh documents from Firestore
  Future<void> refreshDocuments() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Get current download status before refreshing
      final Map<String, bool> currentDownloadStatus = {};
      for (final doc in state.documents) {
        currentDownloadStatus[doc.id] = doc.isDownloaded;
      }
      
      // Load fresh documents from Firebase
      final documents = await _documentService.getAllDocuments();
      
      // Sort documents by most recent first
      documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      // Restore download status from before refresh
      final updatedDocuments = documents.map((doc) {
        return doc.copyWith(
          isDownloaded: currentDownloadStatus[doc.id] ?? false,
        );
      }).toList();
      
      state = state.copyWith(
        documents: updatedDocuments,
        isLoading: false,
      );
      
      // Apply filters
      _applyFilters();
    } catch (e) {
      debugPrint('Error refreshing documents: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error refreshing documents: $e',
      );
    }
  }
  
  // Fallback method to load documents from local assets
  Future<void> _loadLocalDocuments() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/documents.json');
      final List<dynamic> jsonList = json.decode(jsonData)['documents'];
      
      final documents = jsonList.map((json) => TechnicalDocument.fromJson(json)).toList();
      
      // Sort documents by most recent first
      documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      state = state.copyWith(
        documents: documents,
        isLoading: false,
      );
      
      // Apply filters
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading local documents: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading documents: $e',
      );
    }
  }

  // Set search query and filter documents
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  // Filter by machine
  void filterByMachine(String? machineId) {
    state = state.copyWith(selectedMachineId: machineId);
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedMachineId: null,
      selectedCategory: null,
    );
    _applyFilters();
  }

  // Apply all current filters
  void _applyFilters() {
    var filteredDocs = state.documents;

    // Apply machine filter
    if (state.selectedMachineId != null) {
      filteredDocs = filteredDocs
          .where((doc) => doc.machineIds.contains(state.selectedMachineId))
          .toList();
    }

    // Apply category filter
    if (state.selectedCategory != null) {
      filteredDocs = filteredDocs
          .where((doc) => doc.category == state.selectedCategory)
          .toList();
    }

    // Apply search query filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filteredDocs = filteredDocs.where((doc) {
        return doc.title.toLowerCase().contains(query) ||
            doc.description.toLowerCase().contains(query) ||
            doc.tags.any((tag) => tag.toLowerCase().contains(query)) ||
            (doc.uploadedBy != null && doc.uploadedBy!.toLowerCase().contains(query));
      }).toList();
    }
    
    // Update state with filtered documents
    state = state.copyWith(filteredDocuments: filteredDocs);
  }

  // Mark document as downloaded for offline access using Firebase Storage
  Future<void> downloadDocument(String documentId) async {
    final docIndex = state.documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    try {
      final document = state.documents[docIndex];
      
      // Initialize download progress tracking - start at 5% to avoid multiple small initial updates
      final updatedProgress = Map<String, double>.from(state.downloadProgress);
      updatedProgress[documentId] = 0.05; // Start at 5% to show progress bar immediately
      state = state.copyWith(downloadProgress: updatedProgress);

      // Throttle progress updates to reduce re-renders (using a buffer system)
      double lastReportedProgress = 0.05;
      
      // Download the document using Firebase Storage with throttled progress tracking
      await _documentService.downloadDocument(
        document,
        onProgress: (progress) {
          // Only update if progress has changed by at least 5% to reduce state updates
          if (progress - lastReportedProgress >= 0.05 || progress == 1.0) {
            lastReportedProgress = progress;
            // Update progress in state
            final newProgress = Map<String, double>.from(state.downloadProgress);
            newProgress[documentId] = progress;
            state = state.copyWith(downloadProgress: newProgress);
          }
        },
      );
      
      // Show 100% completion briefly before marking as downloaded
      final completeProgress = Map<String, double>.from(state.downloadProgress);
      completeProgress[documentId] = 1.0;
      state = state.copyWith(downloadProgress: completeProgress);
      
      // Small delay to show completion state
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Update the document in the list
      final updatedDocuments = List<TechnicalDocument>.from(state.documents);
      updatedDocuments[docIndex] = document.copyWith(isDownloaded: true);
      
      // Clear progress
      final finalProgress = Map<String, double>.from(state.downloadProgress);
      finalProgress.remove(documentId);
      
      state = state.copyWith(
        documents: updatedDocuments,
        downloadProgress: finalProgress,
      );
      
      // Apply filters to update filteredDocuments
      _applyFilters();
    } catch (e) {
      // Clear progress on error
      final updatedProgress = Map<String, double>.from(state.downloadProgress);
      updatedProgress.remove(documentId);
      
      state = state.copyWith(
        downloadProgress: updatedProgress,
        error: 'Failed to download document: $e',
      );
      
      debugPrint('Error downloading document: $e');
      throw Exception('Failed to download document: $e');
    }
  }

  // Remove a downloaded document
  Future<void> removeDownload(String documentId) async {
    final docIndex = state.documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    try {
      // Remove the document using Firebase service
      await _documentService.removeDownloadedDocument(documentId);
      
      // Update the document in the state
      final updatedDocuments = List<TechnicalDocument>.from(state.documents);
      updatedDocuments[docIndex] = state.documents[docIndex].copyWith(isDownloaded: false);
      
      state = state.copyWith(documents: updatedDocuments);
      
      // Apply filters to update filteredDocuments
      _applyFilters();
    } catch (e) {
      debugPrint('Error removing download: $e');
      state = state.copyWith(error: 'Failed to remove download: $e');
      throw Exception('Failed to remove download: $e');
    }
  }
  
  // Search documents directly in Firebase
  Future<void> searchDocumentsInFirebase(String query) async {
    if (query.isEmpty) {
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final results = await _documentService.searchDocuments(query);
      
      // Check which documents are downloaded locally
      final documentIds = results.map((doc) => doc.id).toList();
      final downloadStatus = await _documentService.checkDownloadedDocuments(documentIds);
      
      // Update download status for each document
      final updatedResults = results.map((doc) {
        return doc.copyWith(
          isDownloaded: downloadStatus[doc.id] ?? false,
        );
      }).toList();
      
      // Update state with search results
      state = state.copyWith(
        filteredDocuments: updatedResults,
        isLoading: false,
        searchQuery: query,
      );
    } catch (e) {
      debugPrint('Error searching documents in Firebase: $e');
      
      // Fall back to local search
      state = state.copyWith(
        searchQuery: query,
        isLoading: false,
        error: 'Error searching documents: $e',
      );
      
      // Apply filters to use local search
      _applyFilters();
    }
  }
}