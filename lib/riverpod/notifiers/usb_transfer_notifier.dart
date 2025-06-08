// lib/riverpod/notifiers/usb_transfer_notifier.dart
import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

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

  // Enhanced permission checking with better error handling
  Future<bool> _checkAndRequestPermissions() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final isAndroid10Plus = await _isAndroid10OrHigher();
      
      // Check basic storage permissions first
      var storageStatus = await Permission.storage.status;
      debugPrint('Storage permission status: $storageStatus');
      
      if (!storageStatus.isGranted) {
        debugPrint('Requesting storage permission...');
        storageStatus = await Permission.storage.request();
        debugPrint('Storage permission after request: $storageStatus');
        
        if (!storageStatus.isGranted && !isAndroid10Plus) {
          // Critical for older Android versions
          state = state.copyWith(
            error: 'Storage permission required for USB transfer',
            transferStatus: 'Permission denied - storage access required',
          );
          return false;
        }
      }

      // For Android 11+, try to get MANAGE_EXTERNAL_STORAGE permission
      if (isAndroid10Plus) {
        try {
          final externalStorage = await Permission.manageExternalStorage.status;
          debugPrint('Manage external storage permission status: $externalStorage');
          
          if (!externalStorage.isGranted) {
            debugPrint('Requesting manage external storage permission...');
            final newStatus = await Permission.manageExternalStorage.request();
            debugPrint('Manage external storage permission after request: $newStatus');
            
            // Don't fail if this permission is denied - SAF will handle most cases
            if (!newStatus.isGranted) {
              debugPrint('MANAGE_EXTERNAL_STORAGE denied, will rely on SAF');
            }
          }
        } catch (e) {
          debugPrint('Error checking MANAGE_EXTERNAL_STORAGE permission: $e');
          // Continue without this permission - SAF should work
        }
      }

      return true;
    } catch (e, stack) {
      debugPrintError(e, stack);
      
      // Enhanced error handling for permission issues
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('permission')) {
        state = state.copyWith(
          error: 'Permission error: ${e.toString()}',
          transferStatus: 'Storage permission error - please check app settings',
        );
      } else {
        state = state.copyWith(
          error: 'Permission check failed: ${e.toString()}',
          transferStatus: 'Could not verify permissions - attempting to continue with SAF',
        );
      }
      
      // Try to continue with SAF even if permission check fails
      return true;
    }
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
      transferStatus: 'File Validated',
      error: null, // Clear any previous errors
    );

    try {
      // Step 1: Scan destination and wait for user confirmation if needed
      await _scanDestinationFiles();
      
      // If confirmation is needed, exit here - user must call confirmDeletion()
      if (state.needsDeleteConfirmation) {
        return;
      }
      
      state = state.copyWith(
        transferProgress: 0.15,
        transferStatus: 'Destination Set',
      );

      final Software software = ref.read(softwareByIdProvider(softwareId));
      final isAndroid10Plus = await _isAndroid10OrHigher();

      // Step 2: Check source file exists
      final sourceFile = File(state.sourcePath!);
      if (!await sourceFile.exists()) {
        state = state.copyWith(
          transferProgress: 0,
          transferStatus: 'Error: Source file not found',
          error: 'Source file not found',
        );
        return;
      }

      // Step 3: Read source file into memory
      _checkCancellation();
      final Uint8List fileBytes = await sourceFile.readAsBytes();
      final fileSizeBytes = fileBytes.length;
      
      // Initialize time estimation
      _updateTimeEstimate(fileSizeBytes, 0.25);

      // Step 4: ZIP Verification Phase (25% - 35%)
      _checkCancellation();
      state = state.copyWith(
        transferProgress: 0.25,
        transferStatus: 'Preparing ZIP Verification',
      );

      final String fileExt = _getFileExtension(state.sourcePath!).toLowerCase();
      final bool isZipFile = fileExt == '.zip';
      
      if (isZipFile) {
        // Calculate and verify ZIP SHA256 hash
        if (software.sha256FileHash != null && software.sha256FileHash!.isNotEmpty) {
          final calculatedHash = sha256.convert(fileBytes).toString();
          if (calculatedHash != software.sha256FileHash) {
            throw Exception('File integrity check failed - corrupted download');
          }
        }
        
        // Validate ZIP structure
        try {
          final archive = ZipDecoder().decodeBytes(fileBytes);
          if (archive.isEmpty) {
            throw Exception('ZIP file is empty or corrupted');
          }
          debugPrint('ZIP validation successful: ${archive.length} files found');
        } catch (e) {
          throw Exception('Invalid ZIP file: $e');
        }
        
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.35);
        state = state.copyWith(
          transferProgress: 0.35,
          transferStatus: 'ZIP Verified',
        );
      } else {
        // For non-ZIP files, still verify integrity if hash available
        if (software.sha256FileHash != null && software.sha256FileHash!.isNotEmpty) {
          final calculatedHash = sha256.convert(fileBytes).toString();
          if (calculatedHash != software.sha256FileHash) {
            throw Exception('File integrity check failed - corrupted download');
          }
        }
        
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.35);
        state = state.copyWith(
          transferProgress: 0.35,
          transferStatus: 'File Verified',
        );
      }

      // Step 5: Content Extraction & Transfer (55% - 75%)
      String? outputPath;
      
      if (isZipFile) {
        // Extract ZIP contents and create directory structure
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.55);
        state = state.copyWith(
          transferProgress: 0.55,
          transferStatus: 'Structure Created',
        );
        
        outputPath = await _extractZipToDestination(
          fileBytes, 
          state.usbMountPath!, 
          isAndroid10Plus,
          software.name,
        );
      } else {
        // Regular file transfer (non-ZIP files)
        final fileName = software.filePath.split('/').last;
        
        state = state.copyWith(
          transferProgress: 0.55,
          transferStatus: 'Structure Created',
        );

        // Try multiple fallback methods for file transfer
        outputPath = await _transferFileWithFallbacks(fileName, fileBytes, isAndroid10Plus);
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

      // Step 6: Finalize transfer (100%)
      // outputPath should not be null at this point due to earlier validation
      
      state = state.copyWith(
        transferProgress: 1.0,
        transferComplete: true,
        transferStatus: 'Success',
        outputPath: outputPath,
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
  
  // Extract ZIP contents to destination directory
  Future<String?> _extractZipToDestination(
    Uint8List zipBytes, 
    String destinationPath, 
    bool isAndroid10Plus,
    String softwareName,
  ) async {
    try {
      // Decode the ZIP archive
      final archive = ZipDecoder().decodeBytes(zipBytes);
      
      state = state.copyWith(
        transferProgress: 0.75,
        transferStatus: 'Content Moved',
      );
      
      int extractedFiles = 0;
      final totalFiles = archive.length;
      
      // Extract each file in the archive
      for (final file in archive) {
        _checkCancellation();
        
        // Update progress granularly from 75% to 95%
        final extractionProgress = 0.75 + (0.20 * (extractedFiles / totalFiles));
        state = state.copyWith(
          transferProgress: extractionProgress,
          transferStatus: 'Extracting: ${file.name} (${extractedFiles + 1}/$totalFiles)',
        );
        
        if (file.isFile) {
          // Create the full output path
          final outputPath = '$destinationPath/${file.name}';
          final outputFile = File(outputPath);
          
          // Create parent directories if they don't exist
          final parentDir = outputFile.parent;
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }
          
          // Write the file content
          await outputFile.writeAsBytes(file.content as List<int>);
          debugPrint('Extracted: ${file.name} (${file.size} bytes)');
        } else if (file.isDirectory) {
          // Create directory
          final dirPath = '$destinationPath/${file.name}';
          final directory = Directory(dirPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          debugPrint('Created directory: ${file.name}');
        }
        
        extractedFiles++;
        
        // Small delay to prevent UI blocking
        if (extractedFiles % 5 == 0) {
          await Future.delayed(const Duration(milliseconds: 10));
        }
      }
      
      // Create a README file with extraction info
      await _createExtractionReadme(destinationPath, softwareName, totalFiles);
      
      // Return the destination path as success indicator
      return destinationPath;
      
    } catch (e, stack) {
      debugPrintError(e, stack);
      state = state.copyWith(
        transferStatus: 'Error extracting ZIP file: ${e.toString()}',
        error: 'ZIP extraction failed: $e',
      );
      return null;
    }
  }
  
  // Create a README file with extraction information
  Future<void> _createExtractionReadme(String destinationPath, String softwareName, int fileCount) async {
    try {
      final readmePath = '$destinationPath/COSTA_EXTRACTION_INFO.txt';
      final readmeFile = File(readmePath);
      
      final now = DateTime.now();
      final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      final readmeContent = '''
Costa Coffee FSE Toolbox - Software Extraction Information
========================================================

Software Name: $softwareName
Extraction Date: $formattedDate
Total Files Extracted: $fileCount

This directory contains the extracted contents of the software package.
All files have been placed directly in the root of your selected storage location.

For installation instructions, please refer to the documentation provided
with this software package or contact Costa Coffee technical support.

Generated by Costa FSE Toolbox v${_getAppVersion()}
''';

      await readmeFile.writeAsString(readmeContent);
      debugPrint('Created extraction README at: $readmePath');
    } catch (e) {
      debugPrint('Warning: Could not create README file: $e');
      // Don't fail the transfer if README creation fails
    }
  }
  
  // Get app version (simplified for now)
  String _getAppVersion() {
    return '0.5.272'; // This would normally come from package info
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
  
  // Enhanced user-friendly error messages based on common issues
  String _getUserFriendlyErrorMessage(String errorString) {
    final error = errorString.toLowerCase();
    
    if (error.contains('permission') || error.contains('denied')) {
      return 'Storage permission denied. Please grant storage access in app settings and try again.';
    } else if (error.contains('space') || error.contains('full')) {
      return 'Not enough space on the device. Free some space and try again.';
    } else if (error.contains('io') || error.contains('file') || error.contains('broken pipe')) {
      return 'File access error. Please check USB connection and try a different location.';
    } else if (error.contains('cancelled') || error.contains('canceled')) {
      return 'Operation cancelled by user.';
    } else if (error.contains('network') || error.contains('connection') || error.contains('ssl')) {
      return 'Network connection issue detected. Please ensure you have a stable connection.';
    } else if (error.contains('background') || error.contains('lifecycle')) {
      return 'Transfer interrupted by app going to background. Please keep app open during transfer.';
    } else if (error.contains('manifest') || error.contains('permissions found')) {
      return 'App permissions not properly configured. Please reinstall the app or contact support.';
    } else {
      return 'Transfer failed. Please check USB connection and try again.';
    }
  }
  
  // Enhanced debugging with structured error logging
  void debugPrintError(Object error, StackTrace stack) {
    if (kDebugMode) {
      final errorInfo = {
        'timestamp': DateTime.now().toIso8601String(),
        'error': error.toString(),
        'error_type': error.runtimeType.toString(),
        'stack_preview': stack.toString().split('\n').take(3).join('\n'),
        'transfer_state': {
          'progress': state.transferProgress,
          'status': state.transferStatus,
          'started': state.transferStarted,
          'complete': state.transferComplete,
          'cancelled': state.isCancelled,
        }
      };
      
      print('=== USB Transfer Error ===');
      print('Time: ${errorInfo['timestamp']}');
      print('Error: ${errorInfo['error']}');
      print('Type: ${errorInfo['error_type']}');
      print('State: ${errorInfo['transfer_state']}');
      print('Stack: ${errorInfo['stack_preview']}');
      print('========================');
    }
  }
  
  // Scan destination for existing files and prepare for cleanup confirmation
  Future<void> _scanDestinationFiles() async {
    try {
      if (state.usbMountPath == null) return;
      
      final destinationDir = Directory(state.usbMountPath!);
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
        return;
      }
      
      // Scan for existing files
      final existingFiles = await destinationDir.list().toList();
      
      if (existingFiles.isNotEmpty) {
        final fileNames = existingFiles
            .map((e) => e.path.split('/').last)
            .where((name) => name.isNotEmpty)
            .toList();
        
        // Update state to show confirmation needed
        state = state.copyWith(
          filesToDelete: fileNames,
          needsDeleteConfirmation: true,
          transferStatus: 'Found ${fileNames.length} existing files. Confirm deletion to proceed.',
        );
        
        // Pause here - user must call confirmDeletion() to proceed
        return;
      }
    } catch (e) {
      throw Exception('Could not scan destination directory: $e');
    }
  }
  
  // User confirms deletion of existing files and continues transfer
  Future<void> confirmDeletion() async {
    try {
      await _performCleanup();
      
      state = state.copyWith(
        transferProgress: 0.15,
        transferStatus: 'Destination Set',
        needsDeleteConfirmation: false,
        filesToDelete: [],
      );
      
      // Continue with the transfer process
      await _continueTransferAfterCleanup();
    } catch (e) {
      state = state.copyWith(
        error: 'Cleanup failed: Could not prepare destination directory',
        transferStatus: 'Error: ${e.toString()}',
      );
    }
  }
  
  // Continue transfer process after cleanup is complete
  Future<void> _continueTransferAfterCleanup() async {
    try {
      final Software software = ref.read(softwareByIdProvider(softwareId));
      final isAndroid10Plus = await _isAndroid10OrHigher();

      // Step 2: Check source file exists
      final sourceFile = File(state.sourcePath!);
      if (!await sourceFile.exists()) {
        state = state.copyWith(
          transferProgress: 0,
          transferStatus: 'Error: Source file not found',
          error: 'Source file not found',
        );
        return;
      }

      // Step 3: Read source file into memory
      _checkCancellation();
      final Uint8List fileBytes = await sourceFile.readAsBytes();
      final fileSizeBytes = fileBytes.length;
      
      // Initialize time estimation
      _updateTimeEstimate(fileSizeBytes, 0.25);

      // Step 4: ZIP Verification Phase (25% - 35%)
      _checkCancellation();
      state = state.copyWith(
        transferProgress: 0.25,
        transferStatus: 'Preparing ZIP Verification',
      );

      final String fileExt = _getFileExtension(state.sourcePath!).toLowerCase();
      final bool isZipFile = fileExt == '.zip';
      
      if (isZipFile) {
        // Calculate and verify ZIP SHA256 hash
        if (software.sha256FileHash != null && software.sha256FileHash!.isNotEmpty) {
          final calculatedHash = sha256.convert(fileBytes).toString();
          if (calculatedHash != software.sha256FileHash) {
            throw Exception('File integrity check failed - corrupted download');
          }
        }
        
        // Validate ZIP structure
        try {
          final archive = ZipDecoder().decodeBytes(fileBytes);
          if (archive.isEmpty) {
            throw Exception('ZIP file is empty or corrupted');
          }
          debugPrint('ZIP validation successful: ${archive.length} files found');
        } catch (e) {
          throw Exception('Invalid ZIP file: $e');
        }
        
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.35);
        state = state.copyWith(
          transferProgress: 0.35,
          transferStatus: 'ZIP Verified',
        );
      } else {
        // For non-ZIP files, still verify integrity if hash available
        if (software.sha256FileHash != null && software.sha256FileHash!.isNotEmpty) {
          final calculatedHash = sha256.convert(fileBytes).toString();
          if (calculatedHash != software.sha256FileHash) {
            throw Exception('File integrity check failed - corrupted download');
          }
        }
        
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.35);
        state = state.copyWith(
          transferProgress: 0.35,
          transferStatus: 'File Verified',
        );
      }

      // Step 5: Content Extraction & Transfer (55% - 75%)
      String? outputPath;
      
      if (isZipFile) {
        // Extract ZIP contents and create directory structure
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.55);
        state = state.copyWith(
          transferProgress: 0.55,
          transferStatus: 'Structure Created',
        );
        
        outputPath = await _extractZipToDestination(
          fileBytes, 
          state.usbMountPath!, 
          isAndroid10Plus,
          software.name,
        );
      } else {
        // Regular file transfer (non-ZIP files)
        final fileName = software.filePath.split('/').last;
        
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.55);
        state = state.copyWith(
          transferProgress: 0.55,
          transferStatus: 'Structure Created',
        );

        // Try multiple fallback methods for file transfer
        outputPath = await _transferFileWithFallbacks(fileName, fileBytes, isAndroid10Plus);
      }

      // Step 6: Finalize transfer (100%)
      // outputPath should not be null at this point due to earlier validation
      if (outputPath == null) {
        throw Exception('Transfer failed - no output path returned');
      }
      
      _updateTimeEstimate(fileSizeBytes, 1.0);
      state = state.copyWith(
        transferProgress: 1.0,
        transferComplete: true,
        transferStatus: 'Success',
        outputPath: outputPath,
        estimatedTimeRemainingSeconds: null,
      );
    } catch (e, stack) {
      // Log the error and stack trace
      debugPrintError(e, stack);
      
      // Update state with more user-friendly error message
      final errorMsg = _getUserFriendlyErrorMessage(e.toString());
      state = state.copyWith(
        transferProgress: 0.0,
        transferStarted: true,
        transferComplete: false,
        transferStatus: 'Error: $errorMsg',
        error: 'Transfer failed: ${e.toString()}',
        estimatedTimeRemainingSeconds: null,
      );
    }
  }
  
  // User cancels deletion - they can choose different destination
  void cancelDeletion() {
    state = state.copyWith(
      needsDeleteConfirmation: false,
      filesToDelete: [],
      usbDetected: false,
      usbMountPath: null,
      transferStatus: 'Please select a different destination or empty folder.',
    );
  }
  
  // Cancel the transfer operation
  void cancelTransfer() {
    state = state.copyWith(
      isCancelled: true,
      isCancellable: false,
      transferStatus: 'Transfer cancelled by user',
      transferProgress: 0.0,
      transferStarted: false,
    );
  }
  
  // Check if transfer was cancelled by user or app lifecycle issues
  void _checkCancellation() {
    if (state.isCancelled) {
      throw Exception('Transfer cancelled by user');
    }
  }
  
  // Handle app lifecycle changes during transfer
  void handleAppLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App going to background - mark transfer as pausable but don't auto-cancel
        if (this.state.transferStarted && !this.state.transferComplete) {
          debugPrint('App backgrounded during transfer - transfer continues');
          this.state = this.state.copyWith(
            transferStatus: '${this.state.transferStatus} (background)',
          );
        }
        break;
      case AppLifecycleState.resumed:
        // App returning to foreground - restore normal status
        if (this.state.transferStarted && !this.state.transferComplete) {
          debugPrint('App foregrounded during transfer - restoring status');
          final status = this.state.transferStatus.replaceAll(' (background)', '');
          this.state = this.state.copyWith(transferStatus: status);
        }
        break;
      case AppLifecycleState.inactive:
        // Brief inactive state - no action needed
        break;
      case AppLifecycleState.hidden:
        // iOS specific - treat like paused
        break;
    }
  }
  
  // Calculate estimated time remaining based on file size and progress
  void _updateTimeEstimate(int fileSizeBytes, double currentProgress) {
    if (currentProgress <= 0 || currentProgress >= 1.0) {
      state = state.copyWith(estimatedTimeRemainingSeconds: null);
      return;
    }
    
    // Simple estimation based on progress rate
    // In a real app, you'd track actual transfer speeds
    final remainingProgress = 1.0 - currentProgress;
    const avgBytesPerSecond = 1024 * 1024; // Assume 1MB/s average
    final estimatedSeconds = (fileSizeBytes * remainingProgress / avgBytesPerSecond).round();
    
    state = state.copyWith(
      estimatedTimeRemainingSeconds: estimatedSeconds.clamp(1, 300), // 1s to 5min max
    );
  }
  
  // Perform the actual cleanup after user confirmation
  Future<void> _performCleanup() async {
    if (state.usbMountPath == null) return;
    
    final destinationDir = Directory(state.usbMountPath!);
    final existingFiles = await destinationDir.list().toList();
    
    for (final entity in existingFiles) {
      try {
        if (entity is File) {
          await entity.delete();
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      } catch (e) {
        debugPrint('Warning: Could not delete ${entity.path}: $e');
      }
    }
  }
  
  // Transfer file with multiple fallback methods
  Future<String?> _transferFileWithFallbacks(
    String fileName, 
    Uint8List fileBytes, 
    bool isAndroid10Plus
  ) async {
    String? outputPath;
    
    _checkCancellation();
    _updateTimeEstimate(fileBytes.length, 0.75);
    state = state.copyWith(
      transferProgress: 0.75,
      transferStatus: 'Content Moved',
    );
    
    // Fallback Method 1: SAF or Direct Write (primary method)
    try {
      if (isAndroid10Plus || !_canWriteDirectly(state.usbMountPath!)) {
        // SAF approach for Android 10+ or inaccessible paths
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(fileBytes);
        
        final params = SaveFileDialogParams(
          sourceFilePath: tempFile.path,
          fileName: fileName,
        );
        
        outputPath = await FlutterFileDialog.saveFile(params: params);
        
        // Clean up temp file
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } else {
        // Direct file writing
        outputPath = await _writeFileDirect(state.usbMountPath!, fileName, fileBytes);
      }
      
      if (outputPath != null) return outputPath;
    } catch (e) {
      debugPrint('Fallback Method 1 failed: $e');
    }
    
    // Fallback Method 2: Force direct write
    try {
      outputPath = await _writeFileDirect(state.usbMountPath!, fileName, fileBytes);
      if (outputPath != null) return outputPath;
    } catch (e) {
      debugPrint('Fallback Method 2 failed: $e');
    }
    
    // If both fallback methods fail, throw error
    throw Exception('All transfer methods failed');
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
