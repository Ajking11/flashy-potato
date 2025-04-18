// lib/riverpod/providers/usb_transfer_providers.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../notifiers/usb_transfer_notifier.dart';

part 'usb_transfer_providers.g.dart';

// Utility providers for UsbTransferState
// These help access specific parts of the state and avoid unnecessary rebuilds

@riverpod
int currentStep(CurrentStepRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.currentStep));
}

@riverpod
bool isUsbDetected(IsUsbDetectedRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.usbDetected));
}

@riverpod
bool isTransferStarted(IsTransferStartedRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferStarted));
}

@riverpod
bool isTransferComplete(IsTransferCompleteRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferComplete));
}

@riverpod
double transferProgress(TransferProgressRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferProgress));
}

@riverpod
String transferStatus(TransferStatusRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferStatus));
}

@riverpod
String? transferError(TransferErrorRef ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.error));
}

// A more comprehensive provider that tells if there's an error state
@riverpod
bool hasTransferError(HasTransferErrorRef ref, String softwareId) {
  final error = ref.watch(transferErrorProvider(softwareId));
  return error != null && error.isNotEmpty;
}

// A provider that combines status information for better UI decisions
@riverpod
Map<String, dynamic> transferStatusInfo(TransferStatusInfoRef ref, String softwareId) {
  final status = ref.watch(transferStatusProvider(softwareId));
  final error = ref.watch(transferErrorProvider(softwareId));
  final hasError = error != null && error.isNotEmpty;
  final isStarted = ref.watch(isTransferStartedProvider(softwareId));
  final isComplete = ref.watch(isTransferCompleteProvider(softwareId));
  
  return {
    'status': status,
    'error': error,
    'hasError': hasError,
    'isStarted': isStarted,
    'isComplete': isComplete,
    'displayColor': hasError ? Colors.red : (isComplete ? Colors.green : Colors.blue),
    'icon': hasError ? Icons.error_outline : (isComplete ? Icons.check_circle : Icons.sync),
  };
}