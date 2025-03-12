import 'dart:convert';
import 'package:flutter/services.dart';

class FilterService {
  // Cache for filter results - Memoization
  final Map<String, Map<String, dynamic>> _cache = {};

  // Load JSON data from assets
  Future<Map<String, dynamic>> loadJsonData(String assetPath) async {
    try {
      final response = await rootBundle.loadString(assetPath);
      return json.decode(response);
    } catch (e) {
      throw Exception('Failed to load $assetPath: $e');
    }
  }

  // Generate cache key from input parameters
  String _generateCacheKey(int tempHardness, int totalHardness, int cpd) {
    return '$tempHardness-$totalHardness-$cpd';
  }

  // Method to clear cache (for cache invalidation)
  void clearCache() {
    _cache.clear();
  }

  // Filter data based on user input with caching.
  // The optional parameter forceRefresh bypasses cache if set to true.
  Future<Map<String, dynamic>> getFilterRecommendation(
    int tempHardness,
    int totalHardness,
    int cpd, {
    bool forceRefresh = false,
    required Map<String, dynamic>? filterListData,
    required Map<String, dynamic>? cpdData,
    required Map<String, dynamic>? freshFilterData,
    required Map<String, dynamic>? standardFilterData,
    required Map<String, dynamic>? finestFilterData,
  }) async {
    final cacheKey = _generateCacheKey(tempHardness, totalHardness, cpd);
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Validate input data
    if (filterListData == null || cpdData == null) {
      throw Exception('Required filter data is not loaded');
    }

    // Process filter data
    final result = <String, dynamic>{};

    // Retrieve filter data based on temp hardness
    final List<dynamic>? tempHardnessFilters = filterListData['$tempHardness'];
    if (tempHardnessFilters == null) {
      throw Exception('No filter data for temporary hardness: $tempHardness');
    }

    // Filter results based on total hardness
    final filteredData = tempHardnessFilters.where((item) {
      final range = item['range'];
      return totalHardness >= range[0] && totalHardness <= range[1];
    }).toList();

    if (filteredData.isEmpty) {
      throw Exception(
          'No filters match the criteria for total hardness: $totalHardness');
    }

    result['filteredData'] = filteredData;

    // Determine filter size using CPD
    final cpdRanges = cpdData['$tempHardness'];
    if (cpdRanges == null) {
      throw Exception('No CPD data for temporary hardness: $tempHardness');
    }

    String? filterSize;
    try {
      filterSize = cpdRanges.entries.firstWhere(
        (entry) {
          final bounds = entry.key.split('-').map(int.parse).toList();
          return cpd >= bounds[0] && cpd <= bounds[1];
        },
        orElse: () => throw Exception('No filter size for CPD: $cpd'),
      ).value;
    } catch (e) {
      throw Exception('Error determining filter size: $e');
    }

    result['filterSize'] = filterSize;

    // Determine filter properties based on filter type
    final filterType = filteredData[0]['type'];
    String bypass = '';
    int capacity = 0;

    if (filterType == "Fresh") {
      // Fresh filter properties
      filterSize = "C50";
      bypass = "0%";
      capacity = 15000;
    } else {
      Map<String, dynamic>? selectedFilterData;
      if (filterType == "Standard") {
        selectedFilterData = standardFilterData?['$tempHardness'];
      } else if (filterType == "Finest") {
        selectedFilterData = finestFilterData?['$tempHardness'];
      }
      if (selectedFilterData == null) {
        throw Exception('No data for filter type: $filterType');
      }
      bypass = selectedFilterData['bypass'] ?? 'Unknown';
      capacity = selectedFilterData['capacities']?[filterSize] ?? 0;
    }

    result['filterSize'] = filterSize;
    result['bypass'] = bypass;
    result['capacity'] = capacity;

    // Cache the result before returning
    _cache[cacheKey] = result;

    return result;
  }
}