// lib/riverpod/states/machine_detail_state.dart
import 'package:flutter/foundation.dart';
import '../../models/machine_detail.dart';

@immutable
class MachineDetailState {
  final bool isLoading;
  final MachineDetail? machineDetail;
  final String? error;

  const MachineDetailState({
    this.isLoading = true,
    this.machineDetail,
    this.error,
  });

  factory MachineDetailState.initial() {
    return const MachineDetailState();
  }

  MachineDetailState copyWith({
    bool? isLoading,
    MachineDetail? machineDetail,
    String? error,
  }) {
    return MachineDetailState(
      isLoading: isLoading ?? this.isLoading,
      machineDetail: machineDetail ?? this.machineDetail,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MachineDetailState &&
        other.isLoading == isLoading &&
        other.machineDetail == machineDetail &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        machineDetail,
        error,
      );
}