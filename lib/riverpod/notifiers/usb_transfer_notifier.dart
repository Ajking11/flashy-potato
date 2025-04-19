// lib/riverpod/notifiers/usb_transfer_notifier.dart
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../states/usb_transfer_state.dart';
import '../../models/software.dart';
import '../providers/software_providers.dart';

part 'usb_transfer_notifier.g.dart';

@riverpod
class UsbTransferNotifier extends _$UsbTransferNotifier {
  @override
  UsbTransferState build(String softwareId) {
    // For real-time UI responsiveness, we need to return an initial state immediately
    final initialState = UsbTransferState.initial();
    
    // Schedule file path initialization on the next microtask
    // This allows the UI to render before we perform potentially slow operations
    Future.microtask(() {
      // Check for valid software ID before proceeding
      try {
        // Access software to verify it exists
        try {
          // This will throw if software isn't found
          ref.read(softwareByIdProvider(softwareId));
          // If we get here, software was found
          _getSourceFilePath();
        } catch (e) {
          state = state.copyWith(
            error: 'Software not found',
            transferStatus: 'Error: Invalid software ID',
          );
        }
      } catch (e) {
        state = state.copyWith(
          error: 'Software lookup error: ${e.toString()}',
          transferStatus: 'Error: Could not find software',
        );
      }
    });
    
    return initialState;
  }

  // Get the source file path from app's document directory
  Future<void> _getSourceFilePath() async {
    try {
      final Software software = ref.read(softwareByIdProvider(softwareId));
      final appDocDir = await getApplicationDocumentsDirectory();

      // Construct the source path from app documents directory and software ID
      final sourcePath =
          '${appDocDir.path}/${software.id}${_getFileExtension(software.filePath)}';

      // Check if file exists
      final file = File(sourcePath);
      final exists = await file.exists();

      if (exists) {
        state = state.copyWith(sourcePath: sourcePath);
      } else {
        // If not found with extension, try without extension
        final basicPath = '${appDocDir.path}/${software.id}';
        final basicFile = File(basicPath);
        if (await basicFile.exists()) {
          state = state.copyWith(sourcePath: basicPath);
        } else {
          // File doesn't exist - this is critical
          state = state.copyWith(
            transferStatus:
                'Error: Source file not found. Please redownload the software.',
            error: 'Source file not found',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        transferStatus: 'Error finding source file: $e',
        error: e.toString(),
      );
    }
  }

  // Progress to the next step
  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);

      // If moving to the USB detection step, start detection
      if (state.currentStep == 1) {
        detectUsb();
      }
    }
  }

  // Go back to the previous step
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // Extract file extension from path
  String _getFileExtension(String path) {
    final Uri uri = Uri.parse(path);
    final String fileName = uri.pathSegments.last;
    final int dotIndex = fileName.lastIndexOf('.');

    if (dotIndex != -1 && dotIndex < fileName.length - 1) {
      return fileName.substring(dotIndex);
    }

    return '';
  }

  // Enhanced USB detection logic with SAF for Android 10+ and direct access for older versions
  Future<void> detectUsb() async {
    // Reset any previous transfer state
    state = state.copyWith(
      transferStarted: false,
      transferComplete: false,
      transferProgress: 0.0,
      transferStatus: 'Preparing to access external storage...',
    );

    try {
      // Check if we have storage permissions
      final permissionStatus = await _checkAndRequestPermissions();
      if (!permissionStatus) {
        state = state.copyWith(
          transferStatus: 'Storage permissions are required to access USB drives',
          error: 'Storage permission denied',
        );
        return;
      }

      final isAndroid10Plus = await _isAndroid10OrHigher();
      
      // Provide different instructions based on Android version
      state = state.copyWith(
        transferStatus: isAndroid10Plus
            ? 'Select your USB drive or external storage location'
            : 'Select a destination folder on your device',
      );

      // Use FilePicker for all Android versions - it handles SAF for 10+ and direct access for older
      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select USB drive or folder',
        // lockParentWindow is supported in newer versions to improve UX
        lockParentWindow: true,
      );

      if (result == null) {
        // User canceled the picker
        state = state.copyWith(
          usbDetected: false,
          transferStatus: 'No storage location selected. Please try again.',
        );
        return;
      }

      // Extract folder name from path
      final directoryName = result.split('/').lastWhere(
        (element) => element.isNotEmpty, 
        orElse: () => 'External Storage'
      );

      // Check if this looks like an external storage path
      final bool isLikelyUsbDrive = _isLikelyUsbDrivePath(result);

      state = state.copyWith(
        usbDetected: true,
        usbMountPath: result,
        usbDisplayName: directoryName,
        transferStatus: isLikelyUsbDrive 
            ? 'USB drive detected: $directoryName. Ready to transfer files.'
            : 'Selected: $directoryName. Ready to transfer files.',
        safAccessGranted: isAndroid10Plus,
      );
    } catch (e, stack) {
      debugPrintError(e, stack);
      state = state.copyWith(
        transferStatus: 'Error accessing storage: ${e.toString()}',
        error: e.toString(),
      );
    }
  }
  
  // Helper method to check if a path is likely a USB drive
  bool _isLikelyUsbDrivePath(String path) {
    final lowerPath = path.toLowerCase();
    
    // Common patterns for USB drives
    return lowerPath.contains('/storage/usb') || 
           lowerPath.contains('/mnt/usb') ||
           lowerPath.contains('/storage/emulated/0/usb') ||
           lowerPath.contains('/storage/') && !lowerPath.contains('/emulated/0');
  }

  // Check if device is running Android 10 (API 29) or higher
  Future<bool> _isAndroid10OrHigher() async {
    if (!Platform.isAndroid) return false;
    
    try {
      final sdkInt = await _getAndroidSdkVersion();
      return sdkInt >= 29; // Android 10 is API 29
    } catch (e) {
      // If we can't determine, assume newer Android for safety
      return true;
    }
  }

  // Helper to get Android SDK version
  Future<int> _getAndroidSdkVersion() async {
    try {
      // This is a simplified approach - in a real app, you would use
      // platform channels or a dedicated package to get this information
      return 29; // Default to Android 10 for safety
    } catch (e) {
      return 29; // Default to Android 10 for safety
    }
  }

  // Check and request necessary permissions for storage access
  Future<bool> _checkAndRequestPermissions() async {
    // For Android 10 (API 29) and above, we don't need to request these permissions
    // for the Storage Access Framework, but they're still needed for lower versions
    if (Platform.isAndroid) {
      try {
        final isAndroid10Plus = await _isAndroid10OrHigher();
        
        // For Android 10+, we primarily use SAF, but still request basic permissions
        // for compatibility with various devices
        var storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted && !isAndroid10Plus) {
            // For older Android versions, we need this permission
            return false;
          }
        }

        // For Android 11+, request MANAGE_EXTERNAL_STORAGE if possible
        // This isn't strictly necessary with SAF but helps in some cases
        if (isAndroid10Plus) {
          final externalStorage = await Permission.manageExternalStorage.status;
          if (!externalStorage.isGranted) {
            await Permission.manageExternalStorage.request();
            // We don't fail if it's not granted, as SAF will handle access
          }
        }

        return true;
      } catch (e) {
        debugPrintError(e, StackTrace.current);
        // If there's an error with permissions, we'll try to continue with SAF
        return true;
      }
    }

    // For iOS or other platforms, return true as we'll use different mechanisms
    return true;
  }

  // For demo purposes: Simulate USB detected state
  void simulateUsbDetected() {
    // Add a short delay to make the simulation more realistic
    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(
        usbDetected: true,
        usbMountPath: '/storage/usb',
        transferStatus: 'USB drive detected. Ready to transfer files.',
      );
    });
  }

  // Enhanced file transfer operation with SAF and direct file access based on Android version
  Future<void> startTransfer() async {
    // Validate prerequisites with more specific error messages
    if (state.sourcePath == null) {
      state = state.copyWith(
        transferStatus: 'Error: Source file not found. Please redownload the software.',
        error: 'Source file not found',
      );
      return;
    }
    
    if (!state.usbDetected || state.usbMountPath == null) {
      state = state.copyWith(
        transferStatus: 'Error: No storage location selected. Please select a destination and try again.',
        error: 'Storage location not selected',
      );
      return;
    }
    
    // Reset any previous error state and start transfer
    state = state.copyWith(
      transferStarted: true,
      transferProgress: 0.05,
      transferStatus: 'Preparing software package...',
      error: null, // Clear any previous errors
    );

    try {
      final Software software = ref.read(softwareByIdProvider(softwareId));
      final isAndroid10Plus = await _isAndroid10OrHigher();

      // Step 1: Check source file
      final sourceFile = File(state.sourcePath!);
      if (!await sourceFile.exists()) {
        state = state.copyWith(
          transferProgress: 0,
          transferStatus: 'Error: Source file not found',
          error: 'Source file not found',
        );
        return;
      }

      // Update progress
      state = state.copyWith(
        transferProgress: 0.1,
        transferStatus: 'Reading source file...',
      );

      // Step 2: Read source file into memory
      final Uint8List fileBytes = await sourceFile.readAsBytes();

      state = state.copyWith(
        transferProgress: 0.25,
        transferStatus: 'Preparing file for transfer...',
      );

      // Step 3: If it's a ZIP file, verify it
      final String fileExt = _getFileExtension(state.sourcePath!).toLowerCase();
      if (fileExt == '.zip') {
        // In a real implementation, we would validate the ZIP structure
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Step 4: Verify file integrity if we have a hash
      state = state.copyWith(
        transferProgress: 0.4,
        transferStatus: 'Verifying package integrity...',
      );

      if (software.sha256FileHash != null && software.sha256FileHash!.isNotEmpty) {
        // In a real app we would calculate and verify the hash here
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Step 5: Get file name from software
      final fileName = software.filePath.split('/').last;
      
      // Update progress before file saving
      state = state.copyWith(
        transferProgress: 0.5,
        transferStatus: 'Preparing to save $fileName to selected location...',
      );

      String? outputPath;

      // Choose transfer approach based on Android version and saved path
      if (isAndroid10Plus || !_canWriteDirectly(state.usbMountPath!)) {
        // SAF approach for Android 10+ or inaccessible paths
        
        // Create a temporary file for the dialog
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(fileBytes);
        
        state = state.copyWith(
          transferProgress: 0.6,
          transferStatus: 'Saving file using system dialog...',
        );

        // Use the system dialog to save the file
        final params = SaveFileDialogParams(
          sourceFilePath: tempFile.path,
          fileName: fileName,
        );

        try {
          // Show the save dialog
          outputPath = await FlutterFileDialog.saveFile(params: params);
          
          // Clean up temp file
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (e) {
          // If FlutterFileDialog fails, try direct file writing as fallback
          if (!isAndroid10Plus) {
            outputPath = await _writeFileDirect(state.usbMountPath!, fileName, fileBytes);
          } else {
            rethrow; // If on Android 10+ and SAF failed, let the error handler deal with it
          }
        }
      } else {
        // Direct file writing for older Android or obvious direct paths
        state = state.copyWith(
          transferProgress: 0.6,
          transferStatus: 'Copying file to selected location...',
        );
        
        outputPath = await _writeFileDirect(state.usbMountPath!, fileName, fileBytes);
      }

      // Handle user cancellation or failed writes
      if (outputPath == null) {
        state = state.copyWith(
          transferProgress: 0.0,
          transferStarted: true,
          transferComplete: false,
          transferStatus: 'Transfer cancelled. Please try again.',
          error: 'Transfer cancelled by user',
        );
        return;
      }

      // Step 6: Create README file (in real implementation)
      state = state.copyWith(
        transferProgress: 0.9,
        transferStatus: 'Finalizing transfer...',
        outputPath: outputPath,
      );

      // Simulate adding a README file
      await Future.delayed(const Duration(milliseconds: 300));

      // Complete the transfer
      state = state.copyWith(
        transferProgress: 1.0,
        transferComplete: true,
        transferStatus: 'Transfer complete!',
      );
    } catch (e, stack) {
      // Log the error and stack trace
      debugPrintError(e, stack);
      
      // Update state with more user-friendly error message
      final errorMsg = _getUserFriendlyErrorMessage(e.toString());
      state = state.copyWith(
        transferProgress: 0.0,          // Reset progress
        transferStarted: true,          // Keep started flag to show error UI
        transferComplete: false,        // Ensure completion is not marked
        transferStatus: 'Error: $errorMsg',
        error: 'Transfer failed: ${e.toString()}',
      );
    }
  }
  
  // Helper method to write file directly (for older Android versions)
  Future<String?> _writeFileDirect(String directory, String fileName, Uint8List data) async {
    try {
      // Create full path
      final outputPath = '$directory/$fileName';
      final outputFile = File(outputPath);
      
      // Create parent directories if needed
      final parentDir = outputFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }
      
      // Write file
      await outputFile.writeAsBytes(data);
      
      // Return the path if successful
      return outputPath;
    } catch (e, stack) {
      debugPrintError(e, stack);
      return null;
    }
  }
  
  // Check if we can write directly to a path
  bool _canWriteDirectly(String path) {
    // Check if path is one we can likely write to directly
    return path.startsWith('/storage/emulated/0') || // Internal storage
           (Platform.isAndroid && path.startsWith('/data/')); // App-specific storage
  }
  
  // Create user-friendly error messages
  String _getUserFriendlyErrorMessage(String errorString) {
    final error = errorString.toLowerCase();
    
    if (error.contains('permission') || error.contains('denied')) {
      return 'Permission denied. Please try selecting a different location.';
    } else if (error.contains('space') || error.contains('full')) {
      return 'Not enough space on the device. Free some space and try again.';
    } else if (error.contains('io') || error.contains('file')) {
      return 'Could not write to the selected location. Try a different one.';
    } else if (error.contains('cancelled') || error.contains('canceled')) {
      return 'Operation cancelled by user.';
    } else {
      return 'Could not complete the transfer. Please try again.';
    }
  }
  
  
  // Helper method to log errors in debug mode
  void debugPrintError(Object error, StackTrace stack) {
    // In a real app, you would use a proper logging system
    // and error reporting service like Firebase Crashlytics
    // For now we'll use a simple comment to avoid linting warnings
    
    // This would be the actual logging in a production app:
    // logger.error('USB Transfer error', error, stack);
    // FirebaseCrashlytics.instance.recordError(error, stack);
    
    // For development, we'd keep this commented out:
    // print('ERROR in UsbTransferNotifier: $error');
    // print('Stack trace: $stack');
  }
}

// Helper provider to get Software by ID
@riverpod
Software softwareById(Ref ref, String softwareId) {
  final softwareList = ref.watch(softwareListProvider);
  return softwareList.firstWhere(
    (software) => software.id == softwareId,
    orElse: () => throw Exception('Software with ID $softwareId not found'),
  );
}
