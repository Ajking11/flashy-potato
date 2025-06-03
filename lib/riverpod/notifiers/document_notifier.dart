// lib/riverpod/notifiers/document_notifier.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/document.dart';
import '../../services/firebase_document_service.dart';
import '../../services/offline_storage_service.dart';
import '../../services/connectivity_service.dart';
import '../states/document_state.dart';

part 'document_notifier.g.dart';

@riverpod
class DocumentNotifier extends _$DocumentNotifier {
  FirebaseDocumentService? _documentService;
  final _offlineStorage = OfflineStorageService();
  final _connectivityService = ConnectivityService.instance;
  
  @override
  DocumentState build() {
    debugPrint('Building DocumentNotifier');
    
    // Initialize with empty state
    final initialState = DocumentState.initial();
    
    // Use addPostFrameCallback to schedule loading after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndLoad();
    });
    
    return initialState;
  }
  
  // Safely initialize the service and load data
  Future<void> _initializeAndLoad() async {
    try {
      // Try to initialize Firebase service with timeout
      try {
        _documentService ??= FirebaseDocumentService();
        debugPrint('Document service initialized');
      } catch (e) {
        debugPrint('Firebase document service failed to initialize: $e');
        // Continue without Firebase service - will use offline data
      }
      
      // Try to load documents (will use offline storage if Firebase unavailable)
      await _loadDocuments();
    } catch (e) {
      debugPrint('Error in document initialization flow: $e');
      // Try to load from offline storage as last resort
      try {
        final offlineDocuments = await _offlineStorage.getDocumentsOffline();
        if (offlineDocuments.isNotEmpty) {
          debugPrint('Loaded ${offlineDocuments.length} documents from offline storage as fallback');
          state = state.copyWith(
            documents: offlineDocuments,
            filteredDocuments: List<TechnicalDocument>.from(offlineDocuments),
            isLoading: false,
            error: null,
          );
          _applyFilters();
          return;
        }
      } catch (offlineError) {
        debugPrint('Offline storage also failed: $offlineError');
      }
      
      // Final fallback to local assets
      await _loadLocalDocuments();
    }
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
    // Guard against uninitialized service
    if (_documentService == null) {
      debugPrint('Document service not initialized');
      return null;
    }
    
    // First try to get from local cache
    TechnicalDocument? doc = getDocumentById(id);
    if (doc != null) {
      return doc;
    }
    
    // If not in cache, fetch from Firestore
    try {
      doc = await _documentService?.getDocumentById(id);
      
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
  
    debugPrint('Loading documents...');
    
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check connectivity and load accordingly
      List<TechnicalDocument> documents = [];
      
      if (_connectivityService.isOnline && _documentService != null) {
        // Online: Try Firebase first, fallback to offline storage
        try {
          documents = await _documentService?.getAllDocuments() ?? [];
          debugPrint('Loaded ${documents.length} documents from Firebase');
          
          // Save to offline storage for future offline access
          if (documents.isNotEmpty) {
            await _offlineStorage.saveDocumentsOffline(documents);
            debugPrint('Saved documents to offline storage');
          }
        } catch (e) {
          debugPrint('Error loading from Firebase: $e');
          // Fallback to offline storage
          documents = await _offlineStorage.getDocumentsOffline();
          debugPrint('Loaded ${documents.length} documents from offline storage (Firebase failed)');
        }
      } else {
        // Offline or Firebase unavailable: Load from offline storage only
        debugPrint('Device offline or Firebase unavailable, loading from offline storage');
        documents = await _offlineStorage.getDocumentsOffline();
        debugPrint('Loaded ${documents.length} documents from offline storage');
      }
      
      // If no documents from either source, load from local assets
      if (documents.isEmpty) {
        debugPrint('No documents from any source, loading local assets...');
        await _loadLocalDocuments();
        return;
      }
      
      // Otherwise, process Firebase documents
      documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      // Set basic state first with the documents
      state = state.copyWith(
        documents: documents,
        filteredDocuments: List<TechnicalDocument>.from(documents),
        isLoading: false,
      );
      
      // Apply any filters
      _applyFilters();
      
      // Then try to get download status in the background
      _updateDownloadStatus(documents);
      
    } catch (e) {
      debugPrint('Error in document loading flow: $e');
      
      // Fall back to local data
      try {
        await _loadLocalDocuments();
      } catch (localError) {
        // Last-resort error handling
        debugPrint('Failed to load documents from any source: $localError');
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load documents',
          documents: const [],
          filteredDocuments: const [],
        );
      }
    }
  }
  
  // Update download status in the background
  Future<void> _updateDownloadStatus(List<TechnicalDocument> documents) async {
    if (_documentService == null) return;
    
    try {
      // Check download status
      final documentIds = documents.map((doc) => doc.id).toList();
      final downloadStatus = await _documentService?.checkDownloadedDocuments(documentIds) ?? {};
      
      // Update documents with download status
      final updatedDocuments = documents.map((doc) {
        return doc.copyWith(
          isDownloaded: downloadStatus[doc.id] ?? false,
        );
      }).toList();
      
      // Update state with download status
      state = state.copyWith(
        documents: updatedDocuments,
        filteredDocuments: List<TechnicalDocument>.from(updatedDocuments),
      );
      
      // Re-apply filters
      _applyFilters();
    } catch (e) {
      debugPrint('Error updating download status: $e');
      // Don't update state on error - keep existing documents
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
      
      List<TechnicalDocument> documents = [];
      
      if (_connectivityService.isOnline) {
        // Load fresh documents from Firebase
        documents = await _documentService?.getAllDocuments() ?? [];
        
        // Save to offline storage
        if (documents.isNotEmpty) {
          await _offlineStorage.saveDocumentsOffline(documents);
        }
      } else {
        // Load from offline storage when offline
        documents = await _offlineStorage.getDocumentsOffline();
      }
      
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
    debugPrint('Loading local documents as fallback');
    
    try {
      // Load the JSON string
      final String jsonData = await rootBundle.loadString('assets/documents.json');
      
      // Parse the JSON data safely
      Map<String, dynamic> jsonMap;
      try {
        jsonMap = json.decode(jsonData) as Map<String, dynamic>;
      } catch (parseError) {
        // Handle JSON parsing errors
        debugPrint('Error parsing documents.json: $parseError');
        throw Exception('Invalid document file format');
      }
      
      // Verify the structure
      if (!jsonMap.containsKey('documents')) {
        throw Exception('Missing "documents" key in JSON file');
      }
      
      final dynamic documentsData = jsonMap['documents'];
      if (documentsData is! List) {
        throw Exception('Documents is not a list in JSON file');
      }
      
      // Convert the JSON data to document objects
      final List<TechnicalDocument> documents = [];
      
      for (final item in documentsData) {
        try {
          documents.add(TechnicalDocument.fromJson(item));
        } catch (itemError) {
          // Log but continue with other documents
          debugPrint('Error parsing document item: $itemError');
        }
      }
      
      if (documents.isEmpty) {
        throw Exception('No valid documents found in local file');
      }
      
      // Sort documents by most recent first
      documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      // Update state with loaded documents
      state = state.copyWith(
        documents: documents,
        filteredDocuments: List<TechnicalDocument>.from(documents),
        isLoading: false,
        error: null,
      );
      
      // Apply filters
      _applyFilters();
      
    } catch (e) {
      debugPrint('Error loading local documents: $e');
      
      // Set error state but avoid crashes
      state = state.copyWith(
        isLoading: false,
        error: 'Could not load documents: ${e.toString().split('\n').first}',
        documents: const [],
        filteredDocuments: const [],
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
  
  // Get download progress for a specific document
  double getDownloadProgress(String documentId) {
    return state.downloadProgress[documentId] ?? 0.0;
  }
  
  // Check if a document is currently downloading
  bool isDownloading(String documentId) {
    return state.downloadProgress.containsKey(documentId);
  }

  // Mark document as downloaded for offline access using Firebase Storage
  Future<void> downloadDocument(String documentId) async {
    // Service check
    if (_documentService == null) {
      debugPrint('Document service not initialized');
      return;
    }
    
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
      await _documentService?.downloadDocument(
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
      await _documentService?.removeDownloadedDocument(documentId);
      
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
      final results = await _documentService?.searchDocuments(query) ?? [];
      
      // Check which documents are downloaded locally
      final documentIds = results.map((doc) => doc.id).toList();
      final downloadStatus = await _documentService?.checkDownloadedDocuments(documentIds) ?? {};
      
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