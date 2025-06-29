// lib/riverpod/states/usb_transfer_state.dart
import 'package:flutter/foundation.dart';

enum UsbTransferStep {
  preparation,
  detection,
  transfer
}

@immutable
class UsbTransferState {
  final int currentStep;
  final bool usbDetected;
  final bool transferStarted;
  final bool transferComplete;
  final double transferProgress;
  final String transferStatus;
  
  // Original path fields
  final String? usbMountPath;
  final String? outputPath;
  final String? sourcePath;
  
  // SAF-specific fields
  final String? sourceUri;       // URI for the source file
  final String? destinationUri;  // URI for the destination file/directory on external storage
  final String? usbDisplayName;  // User-friendly name of the USB drive
  final bool safAccessGranted;   // Whether user has granted SAF permission
  
  // Enhanced UX fields
  final bool isCancelled;        // Whether transfer was cancelled by user
  final bool isCancellable;      // Whether transfer can be cancelled at current stage
  final int? estimatedTimeRemainingSeconds; // Estimated time remaining in seconds
  final List<String> filesToDelete; // Files found that will be deleted
  final bool needsDeleteConfirmation; // Whether user needs to confirm file deletion
  
  final String? error;

  const UsbTransferState({
    this.currentStep = 0,
    this.usbDetected = false,
    this.transferStarted = false,
    this.transferComplete = false,
    this.transferProgress = 0.0,
    this.transferStatus = '',
    this.usbMountPath,
    this.outputPath,
    this.sourcePath,
    this.sourceUri,
    this.destinationUri,
    this.usbDisplayName,
    this.safAccessGranted = false,
    this.isCancelled = false,
    this.isCancellable = true,
    this.estimatedTimeRemainingSeconds,
    this.filesToDelete = const [],
    this.needsDeleteConfirmation = false,
    this.error,
  });

  factory UsbTransferState.initial() {
    return const UsbTransferState();
  }

  UsbTransferState copyWith({
    int? currentStep,
    bool? usbDetected,
    bool? transferStarted,
    bool? transferComplete,
    double? transferProgress,
    String? transferStatus,
    String? usbMountPath,
    String? outputPath,
    String? sourcePath,
    String? sourceUri,
    String? destinationUri,
    String? usbDisplayName,
    bool? safAccessGranted,
    bool? isCancelled,
    bool? isCancellable,
    int? estimatedTimeRemainingSeconds,
    List<String>? filesToDelete,
    bool? needsDeleteConfirmation,
    String? error,
  }) {
    return UsbTransferState(
      currentStep: currentStep ?? this.currentStep,
      usbDetected: usbDetected ?? this.usbDetected,
      transferStarted: transferStarted ?? this.transferStarted,
      transferComplete: transferComplete ?? this.transferComplete,
      transferProgress: transferProgress ?? this.transferProgress,
      transferStatus: transferStatus ?? this.transferStatus,
      usbMountPath: usbMountPath ?? this.usbMountPath,
      outputPath: outputPath ?? this.outputPath,
      sourcePath: sourcePath ?? this.sourcePath,
      sourceUri: sourceUri ?? this.sourceUri,
      destinationUri: destinationUri ?? this.destinationUri,
      usbDisplayName: usbDisplayName ?? this.usbDisplayName,
      safAccessGranted: safAccessGranted ?? this.safAccessGranted,
      isCancelled: isCancelled ?? this.isCancelled,
      isCancellable: isCancellable ?? this.isCancellable,
      estimatedTimeRemainingSeconds: estimatedTimeRemainingSeconds ?? this.estimatedTimeRemainingSeconds,
      filesToDelete: filesToDelete ?? this.filesToDelete,
      needsDeleteConfirmation: needsDeleteConfirmation ?? this.needsDeleteConfirmation,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsbTransferState &&
        other.currentStep == currentStep &&
        other.usbDetected == usbDetected &&
        other.transferStarted == transferStarted &&
        other.transferComplete == transferComplete &&
        other.transferProgress == transferProgress &&
        other.transferStatus == transferStatus &&
        other.usbMountPath == usbMountPath &&
        other.outputPath == outputPath &&
        other.sourcePath == sourcePath &&
        other.sourceUri == sourceUri &&
        other.destinationUri == destinationUri &&
        other.usbDisplayName == usbDisplayName &&
        other.safAccessGranted == safAccessGranted &&
        other.isCancelled == isCancelled &&
        other.isCancellable == isCancellable &&
        other.estimatedTimeRemainingSeconds == estimatedTimeRemainingSeconds &&
        listEquals(other.filesToDelete, filesToDelete) &&
        other.needsDeleteConfirmation == needsDeleteConfirmation &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentStep,
      usbDetected,
      transferStarted,
      transferComplete,
      transferProgress,
      transferStatus,
      usbMountPath,
      outputPath,
      sourcePath,
      sourceUri,
      destinationUri,
      usbDisplayName,
      safAccessGranted,
      isCancelled,
      isCancellable,
      estimatedTimeRemainingSeconds,
      Object.hashAll(filesToDelete),
      needsDeleteConfirmation,
      error,
    );
  }
}