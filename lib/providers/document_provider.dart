// lib/providers/document_provider.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
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
  
  // Create an instance of the Firebase document service
  final FirebaseDocumentService _documentService = FirebaseDocumentService();

  // Getters
  List<TechnicalDocument> get documents => _documents;
  List<TechnicalDocument> get filteredDocuments => _filteredDocuments;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedMachineId => _selectedMachineId;
  String? get selectedCategory => _selectedCategory;

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
      // Load documents from Firebase instead of local JSON
      _documents = await _documentService.getAllDocuments();
      
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
      debugPrint('Error loading documents: $e');
      // Fallback to local JSON if Firebase fails
      await _loadLocalDocuments();
    }
  }
  
  // Fallback method to load documents from local assets
  Future<void> _loadLocalDocuments() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/documents.json');
      final List<dynamic> jsonList = json.decode(jsonData)['documents'];
      
      _documents = jsonList.map((json) => TechnicalDocument.fromJson(json)).toList();
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
          .where((doc) => doc.machineId == _selectedMachineId)
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
            doc.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }
  }

  // Mark document as downloaded for offline access using Firebase Storage
  Future<void> downloadDocument(String documentId) async {
    final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    try {
      final document = _documents[docIndex];
      
      // Download the document using Firebase Storage
      final filePath = await _documentService.downloadDocument(document);
      
      // Update the document in the local list
      _documents[docIndex] = document.copyWith(isDownloaded: true);
      _applyFilters();
      notifyListeners();
    } catch (e) {
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
}