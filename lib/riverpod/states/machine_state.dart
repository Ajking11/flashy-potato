// lib/riverpod/states/machine_state.dart
import 'package:flutter/foundation.dart';
import '../../models/machine.dart';

@immutable
class MachineState {
  final List<Machine> machines;
  final bool isLoading;
  final String? error;

  const MachineState({
    this.machines = const [],
    this.isLoading = true,
    this.error,
  });

  factory MachineState.initial() {
    return const MachineState();
  }

  MachineState copyWith({
    List<Machine>? machines,
    bool? isLoading,
    Object? error = _undefined,
  }) {
    return MachineState(
      machines: machines ?? this.machines,
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
    );
  }

  static const Object _undefined = Object();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MachineState &&
        other.isLoading == isLoading &&
        other.error == error &&
        listEquals(other.machines, machines);
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      error,
      Object.hashAll(machines),
    );
  }
}