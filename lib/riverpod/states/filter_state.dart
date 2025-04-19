// lib/riverpod/states/filter_state.dart
import 'package:flutter/foundation.dart';
import '../../models/filter_recommendation.dart';

@immutable
class FilterState {
  final bool isLoading;
  final bool isCalculating;
  final Map<String, dynamic>? filterListData;
  final Map<String, dynamic>? cpdData;
  final Map<String, dynamic>? freshFilterData;
  final Map<String, dynamic>? standardFilterData;
  final Map<String, dynamic>? finestFilterData;
  
  // Filter result variables
  final List<dynamic>? filteredData;
  final String? filterSize;
  final String? bypass;
  final int? capacity;
  
  // Expanded filter details tracking
  final bool showExpandedDetails;
  
  // Error state
  final String? error;
  
  // Saved filter recommendations
  final List<FilterRecommendation> savedRecommendations;

  const FilterState({
    this.isLoading = true,
    this.isCalculating = false,
    this.filterListData,
    this.cpdData,
    this.freshFilterData,
    this.standardFilterData,
    this.finestFilterData,
    this.filteredData,
    this.filterSize,
    this.bypass,
    this.capacity,
    this.showExpandedDetails = false,
    this.error,
    this.savedRecommendations = const [],
  });

  factory FilterState.initial() {
    return const FilterState();
  }

  FilterState copyWith({
    bool? isLoading,
    bool? isCalculating,
    Map<String, dynamic>? filterListData,
    Map<String, dynamic>? cpdData,
    Map<String, dynamic>? freshFilterData,
    Map<String, dynamic>? standardFilterData,
    Map<String, dynamic>? finestFilterData,
    List<dynamic>? filteredData,
    String? filterSize,
    String? bypass,
    int? capacity,
    bool? showExpandedDetails,
    String? error,
    List<FilterRecommendation>? savedRecommendations,
  }) {
    return FilterState(
      isLoading: isLoading ?? this.isLoading,
      isCalculating: isCalculating ?? this.isCalculating,
      filterListData: filterListData ?? this.filterListData,
      cpdData: cpdData ?? this.cpdData,
      freshFilterData: freshFilterData ?? this.freshFilterData,
      standardFilterData: standardFilterData ?? this.standardFilterData,
      finestFilterData: finestFilterData ?? this.finestFilterData,
      filteredData: filteredData ?? this.filteredData,
      filterSize: filterSize ?? this.filterSize,
      bypass: bypass ?? this.bypass,
      capacity: capacity ?? this.capacity,
      showExpandedDetails: showExpandedDetails ?? this.showExpandedDetails,
      error: error,
      savedRecommendations: savedRecommendations ?? this.savedRecommendations,
    );
  }

  bool get hasResults {
    return filteredData != null && 
           filterSize != null && 
           filteredData!.isNotEmpty && 
           filteredData!.any((item) => item != null);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterState &&
        other.isLoading == isLoading &&
        other.isCalculating == isCalculating &&
        other.showExpandedDetails == showExpandedDetails &&
        other.filterSize == filterSize &&
        other.bypass == bypass &&
        other.capacity == capacity &&
        other.error == error &&
        listEquals(other.filteredData, filteredData) &&
        listEquals(other.savedRecommendations, savedRecommendations);
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      isCalculating,
      showExpandedDetails,
      filterSize,
      bypass,
      capacity,
      error,
      Object.hashAll(filteredData ?? []),
      Object.hashAll(savedRecommendations),
    );
  }
}