// lib/riverpod/providers/usb_transfer_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../notifiers/usb_transfer_notifier.dart';

part 'usb_transfer_providers.g.dart';

// Utility providers for UsbTransferState
// These help access specific parts of the state and avoid unnecessary rebuilds

@riverpod
int currentStep(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.currentStep));
}

@riverpod
bool isUsbDetected(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.usbDetected));
}

@riverpod
bool isTransferStarted(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferStarted));
}

@riverpod
bool isTransferComplete(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferComplete));
}

@riverpod
double transferProgress(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferProgress));
}

@riverpod
String transferStatus(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.transferStatus));
}

@riverpod
String? transferError(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.error));
}

// A more comprehensive provider that tells if there's an error state
@riverpod
bool hasTransferError(Ref ref, String softwareId) {
  final error = ref.watch(transferErrorProvider(softwareId));
  return error != null && error.isNotEmpty;
}

// A provider that combines status information for better UI decisions
@riverpod
Map<String, dynamic> transferStatusInfo(Ref ref, String softwareId) {
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