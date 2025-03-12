import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class DocumentProvider with ChangeNotifier {
  List<TechnicalDocument> _documents = [];
  List<TechnicalDocument> _filteredDocuments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedMachineId;
  String? _selectedCategory;

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

  // Load documents from local JSON file
  Future<void> _loadDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, this would come from an API or database
      final String jsonData = await rootBundle.loadString('assets/documents.json');
      final List<dynamic> jsonList = json.decode(jsonData)['documents'];
      
      _documents = jsonList.map((json) => TechnicalDocument.fromJson(json)).toList();
      _applyFilters(); // Initialize filtered documents
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading documents: $e');
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

  // Mark document as downloaded for offline access
  Future<void> downloadDocument(String documentId) async {
    final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    // Simulate download process
    final document = _documents[docIndex];
    
    // In a real app, this would download the actual PDF
    // For demonstration, we'll just update the isDownloaded status
    _documents[docIndex] = document.copyWith(isDownloaded: true);
    _applyFilters();
    notifyListeners();
    
    // Save download status to persistent storage
    await _saveDownloadStatus();
  }

  // Remove a downloaded document
  Future<void> removeDownload(String documentId) async {
    final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
    if (docIndex == -1) return;

    final document = _documents[docIndex];
    _documents[docIndex] = document.copyWith(isDownloaded: false);
    _applyFilters();
    notifyListeners();
    
    // Update persistent storage
    await _saveDownloadStatus();
  }

  // Save download status to persistent storage
  Future<void> _saveDownloadStatus() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/document_status.json');
      
      final Map<String, bool> downloadStatus = {};
      for (var doc in _documents) {
        downloadStatus[doc.id] = doc.isDownloaded;
      }
      
      await file.writeAsString(json.encode(downloadStatus));
    } catch (e) {
      debugPrint('Error saving download status: $e');
    }
  }

  // Load download status from persistent storage
  // ignore: unused_element
  Future<void> _loadDownloadStatus() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/document_status.json');
      
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> downloadStatus = json.decode(content);
        
        for (int i = 0; i < _documents.length; i++) {
          final docId = _documents[i].id;
          if (downloadStatus.containsKey(docId)) {
            _documents[i] = _documents[i].copyWith(
              isDownloaded: downloadStatus[docId] as bool
            );
          }
        }
        
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading download status: $e');
    }
  }
}