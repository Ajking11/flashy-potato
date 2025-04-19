// lib/riverpod/providers/machine_detail_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/machine_detail.dart';
import '../notifiers/machine_detail_notifier.dart';

part 'machine_detail_providers.g.dart';


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