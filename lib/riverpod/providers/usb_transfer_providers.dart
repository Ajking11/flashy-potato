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

@riverpod
bool needsDeleteConfirmation(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.needsDeleteConfirmation));
}

@riverpod
List<String> filesToDelete(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.filesToDelete));
}

// A more comprehensive provider that tells if there's an error state
@riverpod
bool hasTransferError(Ref ref, String softwareId) {
  final error = ref.watch(transferErrorProvider(softwareId));
  return error != null && error.isNotEmpty;
}

// Enhanced UX providers for new features

@riverpod
bool isCancelled(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.isCancelled));
}

@riverpod
bool isCancellable(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.isCancellable));
}

@riverpod
int? estimatedTimeRemaining(Ref ref, String softwareId) {
  return ref.watch(usbTransferNotifierProvider(softwareId).select((state) => state.estimatedTimeRemainingSeconds));
}


// Helper provider to format time remaining in a human-readable way
@riverpod
String? timeRemainingFormatted(Ref ref, String softwareId) {
  final seconds = ref.watch(estimatedTimeRemainingProvider(softwareId));
  if (seconds == null) return null;
  
  if (seconds < 60) {
    return '${seconds}s remaining';
  } else if (seconds < 3600) {
    final minutes = (seconds / 60).round();
    return '${minutes}m remaining';
  } else {
    final hours = (seconds / 3600).floor();
    final remainingMinutes = ((seconds % 3600) / 60).round();
    return '${hours}h ${remainingMinutes}m remaining';
  }
}

// A provider that combines status information for better UI decisions
@riverpod
Map<String, dynamic> transferStatusInfo(Ref ref, String softwareId) {
  final status = ref.watch(transferStatusProvider(softwareId));
  final error = ref.watch(transferErrorProvider(softwareId));
  final hasError = error != null && error.isNotEmpty;
  final isStarted = ref.watch(isTransferStartedProvider(softwareId));
  final isComplete = ref.watch(isTransferCompleteProvider(softwareId));
  final isCancelled = ref.watch(isCancelledProvider(softwareId));
  final needsConfirmation = ref.watch(needsDeleteConfirmationProvider(softwareId));
  final timeRemaining = ref.watch(timeRemainingFormattedProvider(softwareId));
  
  return {
    'status': status,
    'error': error,
    'hasError': hasError,
    'isStarted': isStarted,
    'isComplete': isComplete,
    'isCancelled': isCancelled,
    'needsConfirmation': needsConfirmation,
    'timeRemaining': timeRemaining,
    'displayColor': hasError ? Colors.red : 
                   (isCancelled ? Colors.orange : 
                   (isComplete ? Colors.green : Colors.blue)),
    'icon': hasError ? Icons.error_outline : 
           (isCancelled ? Icons.cancel : 
           (isComplete ? Icons.check_circle : Icons.sync)),
  };
}