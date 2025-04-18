// lib/riverpod/notifiers/software_notifier.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/software.dart';
import '../../services/firebase_software_service.dart';
import '../states/software_state.dart';

part 'software_notifier.g.dart';

@riverpod
class SoftwareNotifier extends _$SoftwareNotifier {
  late final FirebaseSoftwareService _softwareService;

  @override
  SoftwareState build() {
    _softwareService = FirebaseSoftwareService();
    _loadSoftware();
    return SoftwareState.initial();
  }

  // Get software by ID from local cache
  Software? getSoftwareById(String id) {
    try {
      return state.softwareList.firstWhere((software) => software.id == id);
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
        final updatedList = [...state.softwareList, softwareWithDownloadStatus];
        
        state = state.copyWith(
          softwareList: updatedList,
        );
        
        // Apply filters
        _applyFilters();
        
        return softwareWithDownloadStatus;
      }
    } catch (e) {
      debugPrint('Error fetching software from Firestore: $e');
      state = state.copyWith(error: 'Error fetching software: $e');
    }
    
    return null;
  }

  // Load software from Firestore
  Future<void> _loadSoftware() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load software from Firebase
      final softwareList = await _softwareService.getAllSoftware();
      
      // Log software count for debugging
      debugPrint('Loaded ${softwareList.length} software packages from Firebase');
      
      // If no software are found from Firebase, load from local JSON as fallback
      if (softwareList.isEmpty) {
        debugPrint('No software found in Firebase, loading from local JSON');
        await _loadLocalSoftware();
        return;
      }
      
      // Sort software by most recent first
      softwareList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      
      // Check which software packages are downloaded locally
      final softwareIds = softwareList.map((software) => software.id).toList();
      final downloadStatus = await _softwareService.checkDownloadedSoftware(softwareIds);
      
      // Update download status for each software
      final updatedSoftwareList = softwareList.map((software) {
        return software.copyWith(
          isDownloaded: downloadStatus[software.id] ?? false,
        );
      }).toList();
      
      state = state.copyWith(
        softwareList: updatedSoftwareList,
        isLoading: false,
      );
      
      // Apply filters to initialize filtered software
      _applyFilters();
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
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Get current download status before refreshing
      final Map<String, bool> currentDownloadStatus = {};
      for (final software in state.softwareList) {
        currentDownloadStatus[software.id] = software.isDownloaded;
      }
      
      // Load fresh software from Firebase
      final softwareList = await _softwareService.getAllSoftware();
      
      // Sort software by most recent first
      softwareList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      
      // Restore download status from before refresh
      final updatedSoftwareList = softwareList.map((software) {
        return software.copyWith(
          isDownloaded: currentDownloadStatus[software.id] ?? false,
        );
      }).toList();
      
      state = state.copyWith(
        softwareList: updatedSoftwareList,
        isLoading: false,
      );
      
      // Apply filters
      _applyFilters();
    } catch (e) {
      debugPrint('Error refreshing software: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error refreshing software: $e',
      );
    }
  }
  
  // Fallback method to load software from local assets
  Future<void> _loadLocalSoftware() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/software.json');
      final List<dynamic> jsonList = json.decode(jsonData)['software'];
      
      final softwareList = jsonList.map((json) => Software.fromJson(json)).toList();
      
      // Sort software by most recent first
      softwareList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      
      state = state.copyWith(
        softwareList: softwareList,
        isLoading: false,
      );
      
      // Apply filters
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading local software: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading software: $e',
      );
    }
  }

  // Set search query and filter software
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
    var filteredList = state.softwareList;

    // Apply machine filter
    if (state.selectedMachineId != null) {
      filteredList = filteredList
          .where((software) => software.machineIds.contains(state.selectedMachineId))
          .toList();
    }

    // Apply category filter
    if (state.selectedCategory != null) {
      filteredList = filteredList
          .where((software) => software.category == state.selectedCategory)
          .toList();
    }

    // Apply search query filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filteredList = filteredList.where((software) {
        return software.name.toLowerCase().contains(query) ||
            software.version.toLowerCase().contains(query) ||
            software.description.toLowerCase().contains(query) ||
            software.tags.any((tag) => tag.toLowerCase().contains(query)) ||
            (software.uploadedBy != null && software.uploadedBy!.toLowerCase().contains(query));
      }).toList();
    }
    
    // Update state with filtered list
    state = state.copyWith(filteredSoftwareList: filteredList);
  }

  // Download software
  Future<void> downloadSoftware(String softwareId) async {
    final softwareIndex = state.softwareList.indexWhere((software) => software.id == softwareId);
    if (softwareIndex == -1) return;

    try {
      final software = state.softwareList[softwareIndex];
      
      // Initialize download progress tracking - start at 5% to avoid multiple small initial updates
      final updatedProgress = Map<String, double>.from(state.downloadProgress);
      updatedProgress[softwareId] = 0.05; // Start at 5% to show progress bar immediately
      state = state.copyWith(downloadProgress: updatedProgress);

      // Throttle progress updates to reduce re-renders (using a buffer system)
      double lastReportedProgress = 0.05;
      
      // Download the software using Firebase Storage with throttled progress tracking
      await _softwareService.downloadSoftware(
        software,
        onProgress: (progress) {
          // Only update if progress has changed by at least 5% to reduce state updates
          if (progress - lastReportedProgress >= 0.05 || progress == 1.0) {
            lastReportedProgress = progress;
            // Update progress in state
            final newProgress = Map<String, double>.from(state.downloadProgress);
            newProgress[softwareId] = progress;
            state = state.copyWith(downloadProgress: newProgress);
          }
        },
      );
      
      // Show 100% completion briefly before marking as downloaded
      final completeProgress = Map<String, double>.from(state.downloadProgress);
      completeProgress[softwareId] = 1.0;
      state = state.copyWith(downloadProgress: completeProgress);
      
      // Small delay to show completion state
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Update the software in the list
      final updatedSoftwareList = List<Software>.from(state.softwareList);
      updatedSoftwareList[softwareIndex] = software.copyWith(isDownloaded: true);
      
      // Clear progress
      final finalProgress = Map<String, double>.from(state.downloadProgress);
      finalProgress.remove(softwareId);
      
      state = state.copyWith(
        softwareList: updatedSoftwareList,
        downloadProgress: finalProgress,
      );
      
      // Apply filters to update filteredSoftwareList
      _applyFilters();
    } catch (e) {
      // Clear progress on error
      final updatedProgress = Map<String, double>.from(state.downloadProgress);
      updatedProgress.remove(softwareId);
      
      state = state.copyWith(
        downloadProgress: updatedProgress,
        error: 'Failed to download software: $e',
      );
      
      debugPrint('Error downloading software: $e');
      throw Exception('Failed to download software: $e');
    }
  }

  // Remove a downloaded software
  Future<void> removeDownload(String softwareId) async {
    final softwareIndex = state.softwareList.indexWhere((software) => software.id == softwareId);
    if (softwareIndex == -1) return;

    try {
      // Remove the software using Firebase service
      await _softwareService.removeDownloadedSoftware(softwareId);
      
      // Update the software in the state
      final updatedSoftwareList = List<Software>.from(state.softwareList);
      updatedSoftwareList[softwareIndex] = state.softwareList[softwareIndex].copyWith(isDownloaded: false);
      
      state = state.copyWith(softwareList: updatedSoftwareList);
      
      // Apply filters to update filteredSoftwareList
      _applyFilters();
    } catch (e) {
      debugPrint('Error removing download: $e');
      state = state.copyWith(error: 'Failed to remove download: $e');
      throw Exception('Failed to remove download: $e');
    }
  }
  
  // Search software directly in Firebase
  Future<void> searchSoftwareInFirebase(String query) async {
    if (query.isEmpty) {
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    
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
      
      // Update state with search results
      state = state.copyWith(
        filteredSoftwareList: updatedResults,
        isLoading: false,
        searchQuery: query,
      );
    } catch (e) {
      debugPrint('Error searching software in Firebase: $e');
      
      // Fall back to local search
      state = state.copyWith(
        searchQuery: query,
        isLoading: false,
        error: 'Error searching software: $e',
      );
      
      // Apply filters to use local search
      _applyFilters();
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