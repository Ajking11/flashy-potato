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
    } catch (e) {
      _isLoading = false;
      throw Exception('Error loading app data: $e');
    }
  }
  
  // Getters
  bool get isLoading => _isLoading;
  bool get isCalculating => _isCalculating;
  Map<String, dynamic>? get filterListData => _filterListData;
  Map<String, dynamic>? get cpdData => _cpdData;
  List<dynamic>? get filteredData => _filteredData;
  String? get filterSize => _filterSize;
  String? get bypass => _bypass;
  int? get capacity => _capacity;
  bool get showExpandedDetails => _showExpandedDetails;
  bool get hasResults => _filteredData != null && _filterSize != null && _filteredData!.isNotEmpty;
  
  // Load JSON data from assets with error handling
  Future<void> loadJsonData() async {
    // Only load if not already loaded
    if (_filterListData != null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _preloadData();
      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
  
  // Filter data based on user input
  Future<void> getFilterRecommendation(int tempHardness, int totalHardness, int cpd) async {
    if (totalHardness <= tempHardness) {
      throw Exception('Total Hardness must be greater than Temp Hardness. Please call Tech Help for support.');
    }
    
    _isCalculating = true;
    notifyListeners();
    
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
      
      _filteredData = result['filteredData'];
      _filterSize = result['filterSize'];
      _bypass = result['bypass'];
      _capacity = result['capacity'];
      _showExpandedDetails = false;
      _isCalculating = false;
      
      notifyListeners();
    } catch (e) {
      _isCalculating = false;
      _filteredData = [];
      _filterSize = null;
      _bypass = null;
      _capacity = null;
      
      notifyListeners();
      throw Exception('Error: $e');
    }
  }
  
  // Toggle expanded details
  void toggleExpandedDetails() {
    _showExpandedDetails = !_showExpandedDetails;
    notifyListeners();
  }
  
  // Reset search
  void resetSearch() {
    _filteredData = null;
    _filterSize = null;
    _bypass = null;
    _capacity = null;
    _showExpandedDetails = false;
    notifyListeners();
  }
  
  // Clear cache
  void clearCache() {
    _filterService.clearCache();
  }
}