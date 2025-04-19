// lib/riverpod/notifiers/machine_detail_notifier.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/firebase_machine_service.dart';
import '../states/machine_detail_state.dart';

part 'machine_detail_notifier.g.dart';

@riverpod
class MachineDetailNotifier extends _$MachineDetailNotifier {
  late final FirebaseMachineService _machineService;

  @override
  MachineDetailState build(String machineId) {
    _machineService = FirebaseMachineService();
    
    // Initialize with loading state first
    final initialState = MachineDetailState.initial();
    
    // Use Future.microtask to load details after initialization
    Future.microtask(() async {
      try {
        await _loadMachineDetails(machineId);
      } catch (e) {
        assert(() {
          debugPrint("Error loading machine details in build: $e");
          return true;
        }());
        
        // The 'mounted' check is typically used in StatefulWidget state, not Riverpod notifiers.
        // If the provider is disposed before the async operation completes, setting state might throw.
        // However, in this specific case (microtask in build), it's less likely to be an issue.
        // Consider more robust error handling or state management if needed.
        
        state = state.copyWith(
          isLoading: false, 
          error: "Failed to load machine details: $e"
        );
      }
    });
    
    return initialState;
  }

  Future<void> _loadMachineDetails(String machineId) async {
    try {
      assert(() {
        debugPrint("===== MachineDetailNotifier: Loading details for machine ID: $machineId =====");
        return true;
      }());
      state = state.copyWith(isLoading: true, error: null);
      
      // Fetch from Firestore
      try {
        assert(() {
          debugPrint("Fetching machine details from Firestore...");
          return true;
        }());
        final details = await _machineService.getMachineDetails(machineId);
        
        if (details != null) {
          assert(() {
            debugPrint("Successfully loaded machine details from Firestore!");
            return true;
          }());
          state = state.copyWith(machineDetail: details, isLoading: false);
          return;
        } else {
          assert(() {
            debugPrint("No machine details found in Firestore for ID: $machineId");
            return true;
          }());
          // No fallback to mock data - if no details found, show error state
          state = state.copyWith(
            error: "No details found for this machine.", 
            isLoading: false
          );
        }
      } catch (firestoreError) {
        assert(() {
          debugPrint("Error fetching from Firestore: $firestoreError");
          return true;
        }());
        state = state.copyWith(
          error: "Failed to load machine details. Please check your connection and try again.", 
          isLoading: false
        );
      }
    } catch (e) {
      assert(() {
        debugPrint("Error in _loadMachineDetails: $e");
        return true;
      }());
      state = state.copyWith(error: "Failed to load machine details: $e", isLoading: false);
    }
  }

  Future<void> refreshMachineDetails(String machineId) async {
    try {
      await _loadMachineDetails(machineId);
    } catch (e) {
      assert(() {
        debugPrint("Error refreshing machine details: $e");
        return true;
      }());
      // Just update the error state since we're not using mock data anymore
      state = state.copyWith(
        isLoading: false,
        error: "Failed to refresh machine details. Please try again.", 
      );
    }
  }

// All mock methods have been removed as we're now using real data from Firebase
}