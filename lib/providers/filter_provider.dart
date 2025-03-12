import 'package:flutter/material.dart';
import '../services/filter_service.dart';

class FilterProvider with ChangeNotifier {
  // Filter service instance
  final FilterService _filterService;
  
  // State variables
  bool _isLoading = true;
  bool _isCalculating = false;
  Map<String, dynamic>? _filterListData;
  Map<String, dynamic>? _cpdData;
  Map<String, dynamic>? _freshFilterData;
  Map<String, dynamic>? _standardFilterData;
  Map<String, dynamic>? _finestFilterData;
  
  // Filter result variables
  List<dynamic>? _filteredData;
  String? _filterSize;
  String? _bypass;
  int? _capacity;
  
  // Expanded filter details tracking
  bool _showExpandedDetails = false;
  
  // Constructor with optional dependency injection
  FilterProvider({FilterService? filterService}) 
      : _filterService = filterService ?? FilterService();
  
  // Static initializer to preload data
  static Future<FilterProvider> initialize() async {
    final provider = FilterProvider();
    try {
      await provider._preloadData();
    } catch (e) {
      debugPrint('Error preloading data: $e');
    }
    return provider;
  }

  // Private method to load data
  Future<void> _preloadData() async {
    try {
      _filterListData = await _filterService.loadJsonData('assets/filter_list.json');
      _cpdData = await _filterService.loadJsonData('assets/cpd.json');
      _freshFilterData = await _filterService.loadJsonData('assets/fresh_filter_capacities.json');
      _standardFilterData = await _filterService.loadJsonData('assets/standard_filter_capacities.json');
      _finestFilterData = await _filterService.loadJsonData('assets/finest_filter_capacities.json');
      _isLoading = false;
      notifyListeners(); // Only notify once after all data is loaded
    } catch (e) {
      _isLoading = false;
      notifyListeners(); // Notify of error state
      throw Exception('Error loading app data: $e');
    }
  }
  
  // Getters
  bool get isLoading => _isLoading;
  bool get isCalculating => _isCalculating;
  Map<String, dynamic>? get filterListData => _filterListData;
  Map<String, dynamic>? get cpdData => _cpdData;
  
  // Memoized getters to prevent unnecessary rebuilds
  List<dynamic>? get filteredData => _filteredData;
  String? get filterSize => _filterSize;
  String? get bypass => _bypass;
  int? get capacity => _capacity;
  bool get showExpandedDetails => _showExpandedDetails;
  
  // Computed property with caching to avoid recalculation
  bool get hasResults {
    return _filteredData != null && _filterSize != null && _filteredData!.isNotEmpty;
  }
  
  // Load JSON data from assets with error handling
  Future<void> loadJsonData() async {
    // Only load if not already loaded
    if (_filterListData != null) {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
      return;
    }
    
    // Only notify if state changed
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    
    try {
      await _preloadData();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
  
  // Filter data based on user input with debouncing
  Future<void> getFilterRecommendation(int tempHardness, int totalHardness, int cpd) async {
    if (totalHardness <= tempHardness) {
      throw Exception('Total Hardness must be greater than Temp Hardness. Please call Tech Help for support.');
    }
    
    // Only notify if state changed
    if (!_isCalculating) {
      _isCalculating = true;
      notifyListeners();
    }
    
    try {
      final result = await _filterService.getFilterRecommendation(
        tempHardness,
        totalHardness,
        cpd,
        filterListData: _filterListData,
        cpdData: _cpdData,
        freshFilterData: _freshFilterData,
        standardFilterData: _standardFilterData,
        finestFilterData: _finestFilterData,
      );
      
      // Check if values actually changed to avoid unnecessary notifications
      final dataChanged = _filteredData != result['filteredData'] || 
                          _filterSize != result['filterSize'] ||
                          _bypass != result['bypass'] ||
                          _capacity != result['capacity'];
      
      if (dataChanged) {
        _filteredData = result['filteredData'];
        _filterSize = result['filterSize'];
        _bypass = result['bypass'];
        _capacity = result['capacity'];
        _showExpandedDetails = false;
      }
      
      _isCalculating = false;
      notifyListeners();
    } catch (e) {
      _isCalculating = false;
      
      // Only notify if values changed
      final hadResults = _filteredData != null && _filteredData!.isNotEmpty;
      
      _filteredData = [];
      _filterSize = null;
      _bypass = null;
      _capacity = null;
      
      if (hadResults) {
        notifyListeners();
      } else {
        notifyListeners();
      }
      
      throw Exception('Error: $e');
    }
  }
  
  // Toggle expanded details - only notify if state actually changes
  void toggleExpandedDetails() {
    final newValue = !_showExpandedDetails;
    if (newValue != _showExpandedDetails) {
      _showExpandedDetails = newValue;
      notifyListeners();
    }
  }
  
  // Reset search - only notify if there were results
  void resetSearch() {
    final hadResults = _filteredData != null && _filteredData!.isNotEmpty;
    
    _filteredData = null;
    _filterSize = null;
    _bypass = null;
    _capacity = null;
    _showExpandedDetails = false;
    
    if (hadResults) {
      notifyListeners();
    }
  }
  
  // Clear cache
  void clearCache() {
    _filterService.clearCache();
  }
}