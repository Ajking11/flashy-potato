// lib/providers/document_provider.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart' hide debugPrint;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';
import '../services/firebase_document_service.dart';

class DocumentProvider with ChangeNotifier {
  List<TechnicalDocument> _documents = [];
  List<TechnicalDocument> _filteredDocuments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedMachineId;
  String? _selectedCategory;
  
  // Track document download progress
  final Map<String, double> _downloadProgress = {};
  
  // Create an instance of the Firebase document service
  final FirebaseDocumentService _documentService = FirebaseDocumentService();

  // Getters
  List<TechnicalDocument> get documents => _documents;
  List<TechnicalDocument> get filteredDocuments => _filteredDocuments;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedMachineId => _selectedMachineId;
  String? get selectedCategory => _selectedCategory;
  
  // Get download progress for a specific document
  double getDownloadProgress(String documentId) {
    return _downloadProgress[documentId] ?? 0.0;
  }
  
  // Check if a document is currently downloading
  bool isDownloading(String documentId) {
    final progress = _downloadProgress[documentId];
    return progress != null && progress > 0 && progress < 1.0;
  }
  
  // Get document by ID from local cache
  TechnicalDocument? getDocumentById(String id) {
    try {
      return _documents.firstWhere((doc) => doc.id == id);
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
        _documents.add(documentWithDownloadStatus);
        _applyFilters();
        notifyListeners();
        return documentWithDownloadStatus;
      }
    } catch (e) {
      debugPrint('Error fetching document from Firestore: $e');
    }
    
    return null;
  }

  // Initialize provider with data
  static Future<DocumentProvider> initialize() async {
    final provider = DocumentProvider();
    await provider._loadDocuments();
    return provider;
  }

  // Load documents from Firestore
  Future<void> _loadDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load documents from Firebase
      _documents = await _documentService.getAllDocuments();
      
      // Log document count for debugging
      debugPrint('Loaded ${_documents.length} documents from Firebase');
      for (var doc in _documents) {
        debugPrint('Document: ${doc.id} - ${doc.title}');
      }
      
      // If no documents are found from Firebase, load from local JSON as fallback
      if (_documents.isEmpty) {
        debugPrint('No documents found in Firebase, loading from local JSON');
        await _loadLocalDocuments();
        return;
      }
      
      // Sort documents by most recent first
      _documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      // Check which documents are downloaded locally
      final documentIds = _documents.map((doc) => doc.id).toList();
      final downloadStatus = await _documentService.checkDownloadedDocuments(documentIds);
      
      // Update download status for each document
      _documents = _documents.map((doc) {
        return doc.copyWith(
          isDownloaded: downloadStatus[doc.id] ?? false,
        );
      }).toList();
      
      _applyFilters(); // Initialize filtered documents
      
      _isLoading = false;
      notifyListeners();
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
    _isLoading = true;
    notifyListeners();
    
    try {
      // Get current download status before refreshing
      final Map<String, bool> currentDownloadStatus = {};
      for (final doc in _documents) {
        currentDownloadStatus[doc.id] = doc.isDownloaded;
      }
      
      // Load fresh documents from Firebase
      _documents = await _documentService.getAllDocuments();
      
      // Sort documents by most recent first
      _documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      // Restore download status from before refresh
      _documents = _documents.map((doc) {
        return doc.copyWith(
          isDownloaded: currentDownloadStatus[doc.id] ?? false,
        );
      }).toList();
      
      _applyFilters();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing documents: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fallback method to load documents from local assets
  Future<void> _loadLocalDocuments() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/documents.json');
      final List<dynamic> jsonList = json.decode(jsonData)['documents'];
      
      _documents = jsonList.map((json) => TechnicalDocument.fromJson(json)).toList();
      
      // Sort documents by most recent first
      _documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      
      _applyFilters();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading local documents: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set search query and filter documents
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by machine
  void filterByMachine(String? machineId) {
    _selectedMachineId = machineId;
    _applyFilters();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedMachineId = null;
    _selectedCategory = null;
    _applyFilters();
    notifyListeners();
  }

  // Apply all current filters
  void _applyFilters() {
    _filteredDocuments = _documents;

    // Apply machine filter
    if (_selectedMachineId != null) {
      _filteredDocuments = _filteredDocuments
          .where((doc) => doc.machineIds.contains(_selectedMachineId))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != null) {
      _filteredDocuments = _filteredDocuments
          .where((doc) => doc.category == _selectedCategory)
          .toList();
    }

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredDocuments = _filteredDocuments.where((doc) {
        return doc.title.toLowerCase().contains(query) ||
            doc.description.toLowerCase().contains(query) ||
            doc.tags.any((tag) => tag.toLowerCase().contains(query)) ||
            (doc.uploadedBy != null && doc.uploadedBy!.toLowerCase().contains(query));
      }).toList();
    }
  }

  // Mark document as downloaded for offline access using Firebase Storage
  Future<void> downloadDocument(String documentId) async {
    final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    try {
      final document = _documents[docIndex];
      
      // Initialize download progress tracking
      _downloadProgress[documentId] = 0.01; // Start at 1% to show progress bar immediately
      notifyListeners();
      
      // Download the document using Firebase Storage with progress tracking
      final filePath = await _documentService.downloadDocument(
        document,
        onProgress: (progress) {
          _downloadProgress[documentId] = progress;
          notifyListeners();
        },
      );
      
      // Update the document in the local list
      _documents[docIndex] = document.copyWith(isDownloaded: true);
      _applyFilters();
      
      // Clear progress after a short delay to allow the UI to show completion
      await Future.delayed(const Duration(milliseconds: 500));
      _downloadProgress.remove(documentId);
      notifyListeners();
    } catch (e) {
      // Clear progress on error
      _downloadProgress.remove(documentId);
      notifyListeners();
      
      debugPrint('Error downloading document: $e');
      throw Exception('Failed to download document: $e');
    }
  }

  // Remove a downloaded document
  Future<void> removeDownload(String documentId) async {
    final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    try {
      // Remove the document using Firebase service
      await _documentService.removeDownloadedDocument(documentId);
      
      final document = _documents[docIndex];
      _documents[docIndex] = document.copyWith(isDownloaded: false);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing download: $e');
      throw Exception('Failed to remove download: $e');
    }
  }
  
  // Search documents directly in Firebase
  Future<void> searchDocumentsInFirebase(String query) async {
    if (query.isEmpty) {
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
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
      
      // Replace the filtered documents with search results
      _filteredDocuments = updatedResults;
      _isLoading = false;
      _searchQuery = query;
      notifyListeners();
    } catch (e) {
      debugPrint('Error searching documents in Firebase: $e');
      // Fall back to local search
      _searchQuery = query;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    }
  }
}