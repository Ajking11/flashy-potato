// lib/riverpod/notifiers/filter_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/filter_recommendation.dart';
import '../../services/filter_service.dart';
import '../states/filter_state.dart';

part 'filter_notifier.g.dart';

@riverpod
class FilterNotifier extends _$FilterNotifier {
  late final FilterService _filterService;
  
  @override
  FilterState build() {
    _filterService = FilterService();
    _preloadData();
    _loadSavedRecommendations();
    return FilterState.initial();
  }

  // Load all filter data
  Future<void> _preloadData() async {
    try {
      final filterListData = await _filterService.loadJsonData('assets/filter_list.json');
      final cpdData = await _filterService.loadJsonData('assets/cpd.json');
      final freshFilterData = await _filterService.loadJsonData('assets/fresh_filter_capacities.json');
      final standardFilterData = await _filterService.loadJsonData('assets/standard_filter_capacities.json');
      final finestFilterData = await _filterService.loadJsonData('assets/finest_filter_capacities.json');
      
      state = state.copyWith(
        filterListData: filterListData,
        cpdData: cpdData,
        freshFilterData: freshFilterData,
        standardFilterData: standardFilterData,
        finestFilterData: finestFilterData,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Error loading filter data: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading app data: $e',
      );
    }
  }

  // Load JSON data from assets with error handling
  Future<void> loadJsonData() async {
    // Only load if not already loaded
    if (state.filterListData != null) {
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
      return;
    }
    
    // Set loading state
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true);
    }
    
    try {
      await _preloadData();
    } catch (e) {
      // Already handled in _preloadData
      debugPrint('Error in loadJsonData: $e');
    }
  }

  // Filter data based on user input
  Future<void> getFilterRecommendation(int tempHardness, int totalHardness, int cpd) async {
    if (totalHardness <= tempHardness) {
      state = state.copyWith(
        error: 'Total Hardness must be greater than Temp Hardness. Please call Tech Help for support.',
        filteredData: [],
        filterSize: null,
        bypass: null,
        capacity: null,
      );
      return;
    }
    
    // Set calculating state
    state = state.copyWith(isCalculating: true, error: null);
    
    try {
      final result = await _filterService.getFilterRecommendation(
        tempHardness,
        totalHardness,
        cpd,
        filterListData: state.filterListData,
        cpdData: state.cpdData,
        freshFilterData: state.freshFilterData,
        standardFilterData: state.standardFilterData,
        finestFilterData: state.finestFilterData,
      );
      
      state = state.copyWith(
        filteredData: result['filteredData'],
        filterSize: result['filterSize'],
        bypass: result['bypass'],
        capacity: result['capacity'],
        showExpandedDetails: false,
        isCalculating: false,
        error: null,
      );
      
      // Auto-save the successful recommendation
      final filteredDataList = result['filteredData'] as List<dynamic>;
      if (filteredDataList.isNotEmpty) {
        final filterType = filteredDataList[0]['filter_type'] as String? ?? 'Unknown';
        
        final recommendation = FilterRecommendation(
          tempHardness: tempHardness,
          totalHardness: totalHardness,
          cpd: cpd,
          filterType: filterType,
          filterSize: result['filterSize'] ?? 'Unknown',
          bypass: result['bypass'] ?? 'Unknown',
          capacity: result['capacity'] ?? 0,
          createdAt: DateTime.now(),
        );
        
        _saveRecommendation(recommendation);
      }
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        filteredData: [],
        filterSize: null,
        bypass: null,
        capacity: null,
        error: 'Error: $e',
      );
    }
  }

  // Toggle expanded details
  void toggleExpandedDetails() {
    state = state.copyWith(showExpandedDetails: !state.showExpandedDetails);
  }

  // Reset search - force the app back to input view
  void resetSearch() {
    // Force a complete state reset
    state = FilterState.initial().copyWith(
      // Keep only the data we've already loaded
      filterListData: state.filterListData,
      cpdData: state.cpdData,
      freshFilterData: state.freshFilterData,
      standardFilterData: state.standardFilterData,
      finestFilterData: state.finestFilterData,
      isLoading: false,
      savedRecommendations: state.savedRecommendations,
    );
  }

  // Load saved filter recommendations from SharedPreferences
  Future<void> _loadSavedRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRecsJson = prefs.getStringList('savedFilterRecommendations') ?? [];
      
      final savedRecs = savedRecsJson
          .map((json) => FilterRecommendation.fromJson(jsonDecode(json)))
          .toList();
      
      // Sort by creation date (newest first)
      savedRecs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      state = state.copyWith(savedRecommendations: savedRecs);
    } catch (e) {
      debugPrint('Error loading saved recommendations: $e');
    }
  }
  
  // Save current filter recommendation
  Future<void> saveCurrentRecommendation() async {
    if (!state.hasResults) return;
    
    try {
      final filteredDataList = state.filteredData as List<dynamic>;
      if (filteredDataList.isEmpty) return;
      
      final filterType = filteredDataList[0]['filter_type'] as String? ?? 'Unknown';
      
      final recommendation = FilterRecommendation(
        tempHardness: int.tryParse(filteredDataList[0]['temp_hardness'].toString()) ?? 0,
        totalHardness: int.tryParse(filteredDataList[0]['total_hardness'].toString()) ?? 0,
        cpd: int.tryParse(filteredDataList[0]['cpd'].toString()) ?? 0,
        filterType: filterType,
        filterSize: state.filterSize ?? 'Unknown',
        bypass: state.bypass ?? 'Unknown',
        capacity: state.capacity ?? 0,
        createdAt: DateTime.now(),
      );
      
      _saveRecommendation(recommendation);
    } catch (e) {
      debugPrint('Error saving recommendation: $e');
    }
  }
  
  // Helper method to save a recommendation
  Future<void> _saveRecommendation(FilterRecommendation recommendation) async {
    try {
      // Add to existing recommendations
      final updatedRecs = [...state.savedRecommendations, recommendation];
      
      // Keep only the most recent 10 recommendations
      if (updatedRecs.length > 10) {
        updatedRecs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        updatedRecs.removeRange(10, updatedRecs.length);
      }
      
      // Update state
      state = state.copyWith(savedRecommendations: updatedRecs);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jsonList = updatedRecs.map((rec) => jsonEncode(rec.toJson())).toList();
      await prefs.setStringList('savedFilterRecommendations', jsonList);
    } catch (e) {
      debugPrint('Error saving recommendation: $e');
    }
  }
  
  // Delete a saved recommendation
  Future<void> deleteSavedRecommendation(FilterRecommendation recommendation) async {
    try {
      final updatedRecs = [...state.savedRecommendations];
      updatedRecs.removeWhere((rec) => 
          rec.createdAt == recommendation.createdAt &&
          rec.filterType == recommendation.filterType &&
          rec.filterSize == recommendation.filterSize);
      
      // Update state
      state = state.copyWith(savedRecommendations: updatedRecs);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jsonList = updatedRecs.map((rec) => jsonEncode(rec.toJson())).toList();
      await prefs.setStringList('savedFilterRecommendations', jsonList);
    } catch (e) {
      debugPrint('Error deleting recommendation: $e');
    }
  }
  
  // Load a saved recommendation into the current view
  void loadSavedRecommendation(FilterRecommendation recommendation) {
    state = state.copyWith(
      filteredData: [{
        'filter_type': recommendation.filterType,
        'temp_hardness': recommendation.tempHardness,
        'total_hardness': recommendation.totalHardness,
        'cpd': recommendation.cpd,
      }],
      filterSize: recommendation.filterSize,
      bypass: recommendation.bypass,
      capacity: recommendation.capacity,
      showExpandedDetails: false,
      error: null,
    );
  }
  
  // Clear all saved recommendations
  Future<void> clearSavedRecommendations() async {
    try {
      // Update state
      state = state.copyWith(savedRecommendations: []);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('savedFilterRecommendations', []);
    } catch (e) {
      debugPrint('Error clearing recommendations: $e');
    }
  }
  
  // Clear cache
  void clearCache() {
    _filterService.clearCache();
  }
}