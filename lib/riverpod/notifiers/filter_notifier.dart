// lib/riverpod/notifiers/filter_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

  // Reset search
  void resetSearch() {
    if (state.hasResults) {
      state = state.copyWith(
        filteredData: null,
        filterSize: null,
        bypass: null,
        capacity: null,
        showExpandedDetails: false,
        error: null,
      );
    }
  }

  // Clear cache
  void clearCache() {
    _filterService.clearCache();
  }
}