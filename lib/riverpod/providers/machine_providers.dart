// lib/riverpod/providers/machine_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/machine.dart';
import '../notifiers/machine_notifier.dart';

part 'machine_providers.g.dart';

/// Provider for accessing all machines
@riverpod
List<Machine> machines(Ref ref) {
  return ref.watch(machineNotifierProvider).machines;
}

/// Provider for accessing only displayable machines (displayInApp = true)
@riverpod
List<Machine> displayableMachines(Ref ref) {
  final allMachines = ref.watch(machineNotifierProvider).machines;
  return allMachines.where((machine) => machine.displayInApp).toList();
}

/// Provider for checking if machines are loading
@riverpod
bool isMachinesLoading(Ref ref) {
  return ref.watch(machineNotifierProvider).isLoading;
}

/// Provider for machine error state
@riverpod
String? machineError(Ref ref) {
  return ref.watch(machineNotifierProvider).error;
}

/// Provider to get a specific machine by ID
@riverpod
Machine? machineById(Ref ref, String machineId) {
  final machines = ref.watch(machineNotifierProvider).machines;
  try {
    return machines.firstWhere((machine) => machine.machineId == machineId);
  } catch (e) {
    return null;
  }
}

/// Provider for checking if machines are cached
@riverpod
bool machinesCached(Ref ref) {
  final notifier = ref.watch(machineNotifierProvider.notifier);
  return notifier.hasCachedMachines;
}