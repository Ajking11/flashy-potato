// lib/riverpod/notifiers/machine_notifier.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/machine.dart';
import '../../services/firebase_machine_service.dart';
import '../states/machine_state.dart';

part 'machine_notifier.g.dart';

@riverpod
class MachineNotifier extends _$MachineNotifier {
  FirebaseMachineService? _machineService;
  bool _hasLoadedOnce = false;
  
  @override
  MachineState build() {
    debugPrint('Building MachineNotifier');
    
    // Initialize with empty state
    final initialState = MachineState.initial();
    
    // Use addPostFrameCallback to schedule loading after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndLoad();
    });
    
    return initialState;
  }
  
  // Safely initialize the service and load data
  Future<void> _initializeAndLoad() async {
    try {
      // Make sure service is initialized only once
      _machineService ??= FirebaseMachineService();
      
      // Only load if we haven't loaded before or if machines list is empty
      if (!_hasLoadedOnce || state.machines.isEmpty) {
        await _loadMachines();
      } else {
        debugPrint('Using cached machines: ${state.machines.length}');
      }
    } catch (e) {
      debugPrint('Error initializing machine service: $e');
      // Set error in state
      state = state.copyWith(
        error: 'Error initializing: $e',
        isLoading: false,
      );
    }
  }

  // Load machines from Firebase
  Future<void> _loadMachines() async {
    if (_machineService == null) {
      debugPrint('Machine service not initialized');
      return;
    }
  
    debugPrint('Loading machines...');
    
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Try loading from Firebase first
      List<Machine> machines = [];
      
      try {
        machines = await _machineService?.getAllMachines() ?? [];
        debugPrint('Loaded ${machines.length} machines from Firebase');
        
        // Check if any Firebase machines are displayable
        final displayableMachines = machines.where((m) => m.displayInApp).toList();
        debugPrint('Displayable machines from Firebase: ${displayableMachines.length}');
        
        // If no displayable machines from Firebase, use local fallback
        if (displayableMachines.isEmpty) {
          debugPrint('No displayable machines from Firebase, using local fallback');
          machines = getLocalMachines();
          debugPrint('Using ${machines.length} local machines as fallback');
        }
      } catch (e) {
        debugPrint('Error loading from Firebase: $e');
        // Fall back to local machines
        machines = getLocalMachines();
        debugPrint('Falling back to ${machines.length} local machines');
      }
      
      // Update state with loaded machines
      state = state.copyWith(
        machines: machines,
        isLoading: false,
        error: null,
      );
      
      // Mark as loaded once
      _hasLoadedOnce = true;
      debugPrint('Machines cached successfully: ${machines.length} machines');
      
    } catch (e) {
      debugPrint('Error in machine loading flow: $e');
      
      // Fall back to local data
      try {
        final localMachines = getLocalMachines();
        state = state.copyWith(
          machines: localMachines,
          isLoading: false,
          error: 'Using local data: Failed to load from Firebase',
        );
        _hasLoadedOnce = true;
      } catch (localError) {
        // Last-resort error handling
        debugPrint('Failed to load machines from any source: $localError');
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load machines',
          machines: const [],
        );
      }
    }
  }
  
  // Refresh machines from Firebase (forces reload)
  Future<void> refreshMachines() async {
    debugPrint('Force refreshing machines from Firebase');
    _hasLoadedOnce = false; // Reset cache flag to force reload
    await _loadMachines();
  }
  
  // Check if machines are cached
  // ignore: avoid_public_notifier_properties
  bool get hasCachedMachines => _hasLoadedOnce && state.machines.isNotEmpty;
  
  // Get machine by ID
  Machine? getMachineById(String machineId) {
    try {
      return state.machines.firstWhere((machine) => machine.machineId == machineId);
    } catch (e) {
      debugPrint('Machine not found: $machineId');
      return null;
    }
  }
  
  // Get machines for display (only those with displayInApp = true)
  List<Machine> getDisplayableMachines() {
    return state.machines.where((machine) => machine.displayInApp).toList();
  }
}