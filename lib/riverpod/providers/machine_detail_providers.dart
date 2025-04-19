// lib/riverpod/providers/machine_detail_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

typedef Ref = AutoDisposeProviderRef;
import '../../models/machine_detail.dart';
import '../notifiers/machine_detail_notifier.dart';

part 'machine_detail_providers.g.dart';

// Add explicit Ref typedef to fix undefined class error
typedef Ref = AutoDisposeProviderRef;

/// Provider for checking if machine details are loading
@riverpod
bool isMachineDetailLoading(Ref ref, String machineId) {
  return ref.watch(machineDetailNotifierProvider(machineId)).isLoading;
}

/// Provider for accessing machine details
@riverpod
MachineDetail? machineDetail(Ref ref, String machineId) {
  return ref.watch(machineDetailNotifierProvider(machineId)).machineDetail;
}

/// Provider for machine detail error state
@riverpod
String? machineDetailError(Ref ref, String machineId) {
  return ref.watch(machineDetailNotifierProvider(machineId)).error;
}