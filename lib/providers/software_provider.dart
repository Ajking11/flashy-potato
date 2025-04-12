// lib/providers/software_provider.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart' hide debugPrint;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/software.dart';
import '../services/firebase_software_service.dart';

class SoftwareProvider with ChangeNotifier {
  List<Software> _softwareList = [];
  List<Software> _filteredSoftwareList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedMachineId;
  String? _selectedCategory;
  
  // Track software download progress
  final Map<String, double> _downloadProgress = {};
  
  // Create an instance of the Firebase software service
  final FirebaseSoftwareService _softwareService = FirebaseSoftwareService();

  // Getters
  List<Software> get softwareList => _softwareList;
  List<Software> get filteredSoftwareList => _filteredSoftwareList;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedMachineId => _selectedMachineId;
  String? get selectedCategory => _selectedCategory;
  
  // Get download progress for a specific software
  double getDownloadProgress(String softwareId) {
    return _downloadProgress[softwareId] ?? 0.0;
  }
  
  // Check if software is currently downloading
  bool isDownloading(String softwareId) {
    final progress = _downloadProgress[softwareId];
    return progress != null && progress > 0 && progress < 1.0;
  }
  
  // Get software by ID from local cache
  Software? getSoftwareById(String id) {
    try {
      return _softwareList.firstWhere((software) => software.id == id);
    } catch (e) {
      debugPrint('Software not found in local cache: $id');
      return null;
    }
  }
  
  // Get software by ID from Firestore if not in local cache
  Future<Software?> fetchSoftwareById(String id) async {
    // First try to get from local cache
    Software? software = getSoftwareById(id);
    if (software != null) {
      return software;
    }
    
    // If not in cache, fetch from Firestore
    try {
      software = await _softwareService.getSoftwareById(id);
      
      // If found, add to local cache
      if (software != null) {
        // Check if it's downloaded
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/${software.id}${_getFileExtension(software.filePath)}';
        final file = File(filePath);
        final isDownloaded = await file.exists();
        
        // Add to softwareList with download status
        final softwareWithDownloadStatus = software.copyWith(isDownloaded: isDownloaded);
        _softwareList.add(softwareWithDownloadStatus);
        _applyFilters();
        notifyListeners();
        return softwareWithDownloadStatus;
      }
    } catch (e) {
      debugPrint('Error fetching software from Firestore: $e');
    }
    
    return null;
  }

  // Initialize provider with data
  static Future<SoftwareProvider> initialize() async {
    final provider = SoftwareProvider();
    await provider._loadSoftware();
    return provider;
  }

  // Load software from Firestore
  Future<void> _loadSoftware() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load software from Firebase
      _softwareList = await _softwareService.getAllSoftware();
      
      // Log software count for debugging
      debugPrint('Loaded ${_softwareList.length} software packages from Firebase');
      
      // If no software are found from Firebase, load from local JSON as fallback
      if (_softwareList.isEmpty) {
        debugPrint('No software found in Firebase, loading from local JSON');
        await _loadLocalSoftware();
        return;
      }
      
      // Sort software by most recent first
      _softwareList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      
      // Check which software packages are downloaded locally
      final softwareIds = _softwareList.map((software) => software.id).toList();
      final downloadStatus = await _softwareService.checkDownloadedSoftware(softwareIds);
      
      // Update download status for each software
      _softwareList = _softwareList.map((software) {
        return software.copyWith(
          isDownloaded: downloadStatus[software.id] ?? false,
        );
      }).toList();
      
      _applyFilters(); // Initialize filtered software
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading software from Firebase: $e');
      debugPrint('Full error details: ${e.toString()}');
      
      // Fall back to local JSON
      debugPrint('Loading local software as fallback');
      await _loadLocalSoftware();
    }
  }
  
  // Refresh software list from Firestore
  Future<void> refreshSoftware() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Get current download status before refreshing
      final Map<String, bool> currentDownloadStatus = {};
      for (final software in _softwareList) {
        currentDownloadStatus[software.id] = software.isDownloaded;
      }
      
      // Load fresh software from Firebase
      _softwareList = await _softwareService.getAllSoftware();
      
      // Sort software by most recent first
      _softwareList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      
      // Restore download status from before refresh
      _softwareList = _softwareList.map((software) {
        return software.copyWith(
          isDownloaded: currentDownloadStatus[software.id] ?? false,
        );
      }).toList();
      
      _applyFilters();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing software: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fallback method to load software from local assets
  Future<void> _loadLocalSoftware() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/software.json');
      final List<dynamic> jsonList = json.decode(jsonData)['software'];
      
      _softwareList = jsonList.map((json) => Software.fromJson(json)).toList();
      
      // Sort software by most recent first
      _softwareList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      
      _applyFilters();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading local software: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set search query and filter software
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
    _filteredSoftwareList = _softwareList;

    // Apply machine filter
    if (_selectedMachineId != null) {
      _filteredSoftwareList = _filteredSoftwareList
          .where((software) => software.machineIds.contains(_selectedMachineId))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != null) {
      _filteredSoftwareList = _filteredSoftwareList
          .where((software) => software.category == _selectedCategory)
          .toList();
    }

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredSoftwareList = _filteredSoftwareList.where((software) {
        return software.name.toLowerCase().contains(query) ||
            software.version.toLowerCase().contains(query) ||
            software.description.toLowerCase().contains(query) ||
            software.tags.any((tag) => tag.toLowerCase().contains(query)) ||
            (software.uploadedBy != null && software.uploadedBy!.toLowerCase().contains(query));
      }).toList();
    }
  }

  // Download software
  Future<void> downloadSoftware(String softwareId) async {
    final softwareIndex = _softwareList.indexWhere((software) => software.id == softwareId);
    if (softwareIndex == -1) return;

    try {
      final software = _softwareList[softwareIndex];
      
      // Initialize download progress tracking
      _downloadProgress[softwareId] = 0.01; // Start at 1% to show progress bar immediately
      notifyListeners();
      
      // Download the software using Firebase Storage with progress tracking
      final filePath = await _softwareService.downloadSoftware(
        software,
        onProgress: (progress) {
          _downloadProgress[softwareId] = progress;
          notifyListeners();
        },
      );
      
      // Update the software in the local list
      _softwareList[softwareIndex] = software.copyWith(isDownloaded: true);
      _applyFilters();
      
      // Clear progress after a short delay to allow the UI to show completion
      await Future.delayed(const Duration(milliseconds: 500));
      _downloadProgress.remove(softwareId);
      notifyListeners();
    } catch (e) {
      // Clear progress on error
      _downloadProgress.remove(softwareId);
      notifyListeners();
      
      debugPrint('Error downloading software: $e');
      throw Exception('Failed to download software: $e');
    }
  }

  // Remove a downloaded software
  Future<void> removeDownload(String softwareId) async {
    final softwareIndex = _softwareList.indexWhere((software) => software.id == softwareId);
    if (softwareIndex == -1) return;

    try {
      // Remove the software using Firebase service
      await _softwareService.removeDownloadedSoftware(softwareId);
      
      final software = _softwareList[softwareIndex];
      _softwareList[softwareIndex] = software.copyWith(isDownloaded: false);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing download: $e');
      throw Exception('Failed to remove download: $e');
    }
  }
  
  // Search software directly in Firebase
  Future<void> searchSoftwareInFirebase(String query) async {
    if (query.isEmpty) {
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final results = await _softwareService.searchSoftware(query);
      
      // Check which software packages are downloaded locally
      final softwareIds = results.map((software) => software.id).toList();
      final downloadStatus = await _softwareService.checkDownloadedSoftware(softwareIds);
      
      // Update download status for each software
      final updatedResults = results.map((software) {
        return software.copyWith(
          isDownloaded: downloadStatus[software.id] ?? false,
        );
      }).toList();
      
      // Replace the filtered software with search results
      _filteredSoftwareList = updatedResults;
      _isLoading = false;
      _searchQuery = query;
      notifyListeners();
    } catch (e) {
      debugPrint('Error searching software in Firebase: $e');
      // Fall back to local search
      _searchQuery = query;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Helper method to extract file extension from a path
  String _getFileExtension(String path) {
    final Uri uri = Uri.parse(path);
    final String fileName = uri.pathSegments.last;
    final int dotIndex = fileName.lastIndexOf('.');
    
    if (dotIndex != -1 && dotIndex < fileName.length - 1) {
      return fileName.substring(dotIndex);
    }
    
    return ''; // No extension found
  }
}