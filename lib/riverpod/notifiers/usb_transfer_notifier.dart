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
    debugPrint('🔄 UsbTransferNotifier.nextStep() - Current: ${state.currentStep}');
    if (state.currentStep < 2) {
      final newStep = state.currentStep + 1;
      debugPrint('📈 Moving from step ${state.currentStep} to step $newStep');
      state = state.copyWith(currentStep: newStep);

      // If moving to the USB detection step, start detection
      if (state.currentStep == 1) {
        debugPrint('🔍 Step 1 reached - starting USB detection automatically');
        detectUsb();
      }
    } else {
      debugPrint('⚠️ Cannot advance step - already at maximum step ${state.currentStep}');
    }
  }

  // Go back to the previous step
  void previousStep() {
    debugPrint('🔄 UsbTransferNotifier.previousStep() - Current: ${state.currentStep}');
    if (state.currentStep > 0) {
      final newStep = state.currentStep - 1;
      debugPrint('📉 Moving from step ${state.currentStep} to step $newStep');
      state = state.copyWith(currentStep: newStep);
    } else {
      debugPrint('⚠️ Cannot go back - already at minimum step ${state.currentStep}');
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
    debugPrint('🔍 UsbTransferNotifier.detectUsb() - Starting USB detection');
    debugPrint('📱 Current state - Step: ${state.currentStep}, USB detected: ${state.usbDetected}');
    
    // Reset any previous transfer state
    state = state.copyWith(
      transferStarted: false,
      transferComplete: false,
      transferProgress: 0.0,
      transferStatus: 'Preparing to access external storage...',
    );
    debugPrint('🔄 State reset for USB detection');

    try {
      // Check if we have storage permissions
      debugPrint('🔐 Checking storage permissions...');
      final permissionStatus = await _checkAndRequestPermissions();
      debugPrint('🔐 Permission status: $permissionStatus');
      
      if (!permissionStatus) {
        debugPrint('❌ Storage permissions denied');
        state = state.copyWith(
          transferStatus: 'Storage permissions are required to access USB drives',
          error: 'Storage permission denied',
        );
        return;
      }

      debugPrint('📱 Android 30+ SAF approach - Select your USB drive or external storage location');
      
      state = state.copyWith(transferStatus: 'Select your USB drive or external storage location');

      // Use FilePicker for all Android versions - it handles SAF for 10+ and direct access for older
      debugPrint('📂 Opening directory picker dialog...');
      final result = await FilePicker.platform.getDirectoryPath();
      debugPrint('📂 Directory picker result: $result');

      if (result == null) {
        // User canceled the picker
        debugPrint('❌ User canceled file picker');
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
      debugPrint('📁 Directory name extracted: $directoryName');

      // Check if this looks like an external storage path
      final bool isLikelyUsbDrive = _isLikelyUsbDrivePath(result);
      debugPrint('💾 Is likely USB drive: $isLikelyUsbDrive');

      final finalStatusMessage = isLikelyUsbDrive 
          ? 'USB drive detected: $directoryName. Ready to transfer files.'
          : 'Selected: $directoryName. Ready to transfer files.';
      debugPrint('✅ USB detection completed - Status: $finalStatusMessage');

      state = state.copyWith(
        usbDetected: true,
        usbMountPath: result,
        usbDisplayName: directoryName,
        transferStatus: finalStatusMessage,
        safAccessGranted: true, // Always true for Android 30+
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


  // Simplified permission checking for Android 30+ with SAF focus
  Future<bool> _checkAndRequestPermissions() async {
    debugPrint('🔐 _checkAndRequestPermissions() - Android 30+ SAF-only approach');
    if (!Platform.isAndroid) {
      debugPrint('📱 Platform is not Android, permissions automatically granted');
      return true;
    }
    
    try {
      // For Android 30+, SAF handles most access, but check MANAGE_EXTERNAL_STORAGE for better UX
      debugPrint('🔐 Android 30+, checking MANAGE_EXTERNAL_STORAGE permission');
      try {
        final externalStorage = await Permission.manageExternalStorage.status;
        debugPrint('🔐 Manage external storage permission status: $externalStorage');
        
        if (!externalStorage.isGranted) {
          debugPrint('🔐 MANAGE_EXTERNAL_STORAGE not granted, requesting...');
          final newStatus = await Permission.manageExternalStorage.request();
          debugPrint('🔐 MANAGE_EXTERNAL_STORAGE after request: $newStatus');
          
          // SAF will handle access even without this permission
          if (!newStatus.isGranted) {
            debugPrint('⚠️ MANAGE_EXTERNAL_STORAGE denied, using SAF file picker');
          } else {
            debugPrint('✅ MANAGE_EXTERNAL_STORAGE granted');
          }
        } else {
          debugPrint('✅ MANAGE_EXTERNAL_STORAGE already granted');
        }
      } catch (e) {
        debugPrint('❌ Error checking MANAGE_EXTERNAL_STORAGE permission: $e');
        debugPrint('📱 Continuing with SAF file picker approach');
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
    debugPrint('🎭 simulateUsbDetected() - Simulating USB detection');
    // Add a short delay to make the simulation more realistic
    Future.delayed(const Duration(milliseconds: 500), () {
      debugPrint('🎭 Setting simulated USB state');
      state = state.copyWith(
        usbDetected: true,
        usbMountPath: '/storage/usb',
        transferStatus: 'USB drive detected. Ready to transfer files.',
      );
      debugPrint('✅ Simulated USB detection complete');
    });
  }

  // Enhanced file transfer operation with SAF and direct file access based on Android version
  Future<void> startTransfer() async {
    debugPrint('🚀 UsbTransferNotifier.startTransfer() - Starting file transfer');
    debugPrint('📁 Source path: ${state.sourcePath}');
    debugPrint('💾 USB mount path: ${state.usbMountPath}');
    debugPrint('🔍 USB detected: ${state.usbDetected}');
    
    // Validate prerequisites with more specific error messages
    if (state.sourcePath == null) {
      debugPrint('❌ Transfer failed - Source file not found');
      state = state.copyWith(
        transferStatus: 'Error: Source file not found. Please redownload the software.',
        error: 'Source file not found',
      );
      return;
    }
    
    if (!state.usbDetected || state.usbMountPath == null) {
      debugPrint('❌ Transfer failed - No storage location selected');
      state = state.copyWith(
        transferStatus: 'Error: No storage location selected. Please select a destination and try again.',
        error: 'Storage location not selected',
      );
      return;
    }
    
    // Reset any previous error state and start transfer
    debugPrint('🔄 Resetting transfer state and starting...');
    state = state.copyWith(
      transferStarted: true,
      transferProgress: 0.05,
      transferStatus: 'File Validated',
      error: null, // Clear any previous errors
    );

    try {
      // Step 1: Scan destination and wait for user confirmation if needed
      debugPrint('📂 Step 1: Scanning destination files...');
      await _scanDestinationFiles();
      
      // If confirmation is needed, exit here - user must call confirmDeletion()
      if (state.needsDeleteConfirmation) {
        debugPrint('⏸️ Transfer paused - waiting for user confirmation to delete existing files');
        return;
      }
      
      debugPrint('✅ Destination scan complete - proceeding with transfer');
      state = state.copyWith(
        transferProgress: 0.15,
        transferStatus: 'Destination Set',
      );

      final Software software = ref.read(softwareByIdProvider(softwareId));
      debugPrint('💾 Software: ${software.name} - Using SAF-only approach for Android 30+');

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
          debugPrint('🔍 Calculating SHA256 hash for integrity check...');
          debugPrint('🔍 File size: ${fileBytes.length} bytes');
          final calculatedHash = sha256.convert(fileBytes).toString();
          debugPrint('🔍 Expected hash: ${software.sha256FileHash}');
          debugPrint('🔍 Calculated hash: $calculatedHash');
          
          if (calculatedHash.toLowerCase() != software.sha256FileHash!.toLowerCase()) {
            debugPrint('❌ Hash mismatch - file integrity check failed');
            throw Exception('File integrity check failed - corrupted download');
          } else {
            debugPrint('✅ Hash verification successful');
          }
        } else {
          debugPrint('⚠️ No SHA256 hash provided, skipping integrity check');
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

      // Step 5: Content Extraction & Transfer (55% - 75%) - SAF Only
      String? outputPath;
      
      if (isZipFile) {
        // Extract ZIP contents using SAF
        _checkCancellation();
        _updateTimeEstimate(fileSizeBytes, 0.55);
        state = state.copyWith(
          transferProgress: 0.55,
          transferStatus: 'Extracting ZIP contents...',
        );
        
        outputPath = await _extractZipToDestinationSAF(
          fileBytes, 
          state.usbMountPath!, 
          software.name,
        );
      } else {
        // Regular file transfer using SAF
        final fileName = software.filePath.split('/').last;
        
        state = state.copyWith(
          transferProgress: 0.55,
          transferStatus: 'Transferring file...',
        );

        // Use SAF for file transfer
        outputPath = await _transferFileWithSAF(fileName, fileBytes);
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
  
  // Extract ZIP contents using SAF (Android 30+ only)
  Future<String?> _extractZipToDestinationSAF(
    Uint8List zipBytes, 
    String destinationPath, 
    String softwareName,
  ) async {
    debugPrint('📦 _extractZipToDestinationSAF() - Extracting ZIP for SAF transfer');
    try {
      // Decode the ZIP archive
      final archive = ZipDecoder().decodeBytes(zipBytes);
      debugPrint('📦 ZIP contains ${archive.length} files');
      
      // Extract to temporary directory first
      final tempDir = await getTemporaryDirectory();
      final extractionDir = Directory('${tempDir.path}/costa_extraction_${DateTime.now().millisecondsSinceEpoch}');
      await extractionDir.create(recursive: true);
      debugPrint('📁 Created temp extraction dir: ${extractionDir.path}');
      
      state = state.copyWith(
        transferProgress: 0.75,
        transferStatus: 'Extracting ZIP contents...',
      );
      
      int extractedFiles = 0;
      final totalFiles = archive.length;
      
      // Extract each file to temporary directory
      for (final file in archive) {
        _checkCancellation();
        
        // Update progress granularly from 75% to 90%
        final extractionProgress = 0.75 + (0.15 * (extractedFiles / totalFiles));
        state = state.copyWith(
          transferProgress: extractionProgress,
          transferStatus: 'Extracting: ${file.name} (${extractedFiles + 1}/$totalFiles)',
        );
        
        if (file.isFile) {
          // Create the full output path in temp directory
          final outputPath = '${extractionDir.path}/${file.name}';
          final outputFile = File(outputPath);
          
          // Create parent directories if they don't exist
          final parentDir = outputFile.parent;
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }
          
          // Write the file content
          await outputFile.writeAsBytes(file.content as List<int>);
          debugPrint('📝 Extracted: ${file.name} (${file.size} bytes)');
        } else if (file.isDirectory) {
          // Create directory in temp
          final dirPath = '${extractionDir.path}/${file.name}';
          final directory = Directory(dirPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          debugPrint('📁 Created directory: ${file.name}');
        }
        
        extractedFiles++;
        
        // Small delay to prevent UI blocking
        if (extractedFiles % 5 == 0) {
          await Future.delayed(const Duration(milliseconds: 10));
        }
      }
      
      // Create a README file with extraction info
      await _createExtractionReadmeInTemp(extractionDir.path, softwareName, totalFiles);
      
      // Now copy the extracted files directly to the destination directory
      state = state.copyWith(
        transferProgress: 0.90,
        transferStatus: 'Transferring extracted files to USB...',
      );
      
      debugPrint('📱 Transferring $totalFiles extracted files to destination: $destinationPath');
      
      // Try directory selection approach first (better UX)
      final extractedFilesList = await extractionDir.list().toList();
      int transferredFiles = 0;
      String? lastOutputPath;
      
      state = state.copyWith(
        transferProgress: 0.90,
        transferStatus: 'Please select destination folder for extracted files...',
      );
      
      debugPrint('📁 Attempting directory selection for batch file save...');
      
      try {
        // Try to pick a directory first
        final DirectoryLocation? selectedDirectory = await FlutterFileDialog.pickDirectory();
        
        if (selectedDirectory != null) {
          debugPrint('✅ Directory selected, saving files to directory...');
          
          // Save all files to the selected directory
          bool foundDuplicates = false;
          
          for (final entity in extractedFilesList) {
            if (entity is File && !entity.path.endsWith('COSTA_EXTRACTION_INFO.txt')) {
              try {
                final fileName = entity.path.split('/').last;
                final fileBytes = await entity.readAsBytes();
                
                debugPrint('📝 Saving file to directory: $fileName');
                
                final outputPath = await FlutterFileDialog.saveFileToDirectory(
                  directory: selectedDirectory,
                  data: fileBytes,
                  fileName: fileName,
                  mimeType: 'application/octet-stream',
                  replace: true, // Try to replace existing files
                );
                
                if (outputPath != null) {
                  // Check if the system created a duplicate name (e.g., "file(1).cud")
                  final savedFileName = outputPath.split('/').last;
                  if (savedFileName != fileName) {
                    debugPrint('⚠️ File was renamed to avoid conflict: $fileName → $savedFileName');
                    foundDuplicates = true;
                  }
                  
                  transferredFiles++;
                  lastOutputPath = outputPath;
                  debugPrint('✅ Saved to directory: $fileName → $outputPath');
                  
                  // Update progress
                  final transferProgress = 0.90 + (0.10 * (transferredFiles / totalFiles));
                  state = state.copyWith(
                    transferProgress: transferProgress,
                    transferStatus: 'Saved $transferredFiles of $totalFiles files to selected folder',
                  );
                } else {
                  debugPrint('⚠️ saveFileToDirectory returned null for $fileName');
                }
              } catch (e) {
                debugPrint('❌ Failed to save file ${entity.path} to directory: $e');
                // Continue with other files
              }
            }
          }
          
          if (transferredFiles > 0) {
            if (foundDuplicates) {
              debugPrint('⚠️ Some files were renamed due to conflicts - consider using individual saves for better control');
            }
            debugPrint('✅ Successfully saved $transferredFiles files to selected directory');
          }
        } else {
          debugPrint('❌ User cancelled directory selection');
          throw Exception('Directory selection cancelled');
        }
      } catch (e) {
        debugPrint('⚠️ Directory selection failed: $e');
        debugPrint('📱 Falling back to individual file saves...');
        
        // Fallback: Individual file saves (current approach)
        transferredFiles = 0;
        lastOutputPath = null;
        
        state = state.copyWith(
          transferProgress: 0.90,
          transferStatus: 'Please select save location for each extracted file...',
        );
        
        for (final entity in extractedFilesList) {
          if (entity is File && !entity.path.endsWith('COSTA_EXTRACTION_INFO.txt')) {
            try {
              final fileName = entity.path.split('/').last;
              
              debugPrint('📝 Saving extracted file individually: $fileName');
              
              // Use SAF to save each extracted file
              final params = SaveFileDialogParams(
                sourceFilePath: entity.path,
                fileName: fileName,
              );
              
              final outputPath = await FlutterFileDialog.saveFile(params: params);
              if (outputPath != null) {
                transferredFiles++;
                lastOutputPath = outputPath;
                debugPrint('✅ Saved individually: $fileName to $outputPath');
                
                // Update progress
                final transferProgress = 0.90 + (0.10 * (transferredFiles / totalFiles));
                state = state.copyWith(
                  transferProgress: transferProgress,
                  transferStatus: 'Saved $transferredFiles of $totalFiles files individually',
                );
              } else {
                debugPrint('❌ User cancelled save for file: $fileName');
                // Clean up temp directory before returning null
                if (await extractionDir.exists()) {
                  await extractionDir.delete(recursive: true);
                }
                return null;
              }
            } catch (e) {
              debugPrint('❌ Failed to save file ${entity.path}: $e');
              // Continue with other files instead of failing completely
            }
          }
        }
      }
      
      // Clean up temp directory
      if (await extractionDir.exists()) {
        await extractionDir.delete(recursive: true);
        debugPrint('🗑️ Cleaned up temp extraction directory');
      }
      
      if (transferredFiles > 0) {
        debugPrint('✅ Successfully saved $transferredFiles individual files to USB drive');
        return lastOutputPath;
      } else {
        debugPrint('❌ No files were saved');
        return null;
      }
      
    } catch (e, stack) {
      debugPrintError(e, stack);
      state = state.copyWith(
        transferStatus: 'Error extracting ZIP file: ${e.toString()}',
        error: 'ZIP extraction failed: $e',
      );
      return null;
    }
  }
  
  // Create a README file in temp directory
  Future<void> _createExtractionReadmeInTemp(String destinationPath, String softwareName, int fileCount) async {
    debugPrint('📝 Creating extraction README in temp directory');
    try {
      final readmePath = '$destinationPath/COSTA_EXTRACTION_INFO.txt';
      final readmeFile = File(readmePath);
      
      final now = DateTime.now();
      final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      final readmeContent = '''
Costa Coffee FSE Toolbox - Software Extraction Information (SAF Transfer)
====================================================================

Software Name: $softwareName
Extraction Date: $formattedDate
Total Files Extracted: $fileCount
Transfer Method: Storage Access Framework (SAF)

This directory contains the extracted contents of the software package.
Use your device's file manager to copy these files to your desired location.

For installation instructions, please refer to the documentation provided
with this software package or contact Costa Coffee technical support.

Generated by Costa FSE Toolbox v${_getAppVersion()}
''';

      await readmeFile.writeAsString(readmeContent);
      debugPrint('✅ Created extraction README at: $readmePath');
    } catch (e) {
      debugPrint('⚠️ Warning: Could not create README file: $e');
      // Don't fail the transfer if README creation fails
    }
  }

  
  // Get app version (simplified for now)
  String _getAppVersion() {
    return '0.5.272'; // This would normally come from package info
  }
  
  // SAF-only file transfer for Android 30+
  Future<String?> _transferFileWithSAF(String fileName, Uint8List fileBytes) async {
    debugPrint('📱 _transferFileWithSAF() - Using SAF for file transfer');
    debugPrint('📝 File: $fileName, Size: ${fileBytes.length} bytes');
    
    try {
      // Create temporary file for SAF
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(fileBytes);
      debugPrint('📝 Created temp file: ${tempFile.path}');
      
      // Use SAF to save the file
      final params = SaveFileDialogParams(
        sourceFilePath: tempFile.path,
        fileName: fileName,
      );
      
      debugPrint('📱 Opening SAF save dialog...');
      final outputPath = await FlutterFileDialog.saveFile(params: params);
      debugPrint('📱 SAF result: $outputPath');
      
      // Clean up temp file
      if (await tempFile.exists()) {
        await tempFile.delete();
        debugPrint('🗑️ Cleaned up temp file');
      }
      
      return outputPath;
    } catch (e, stack) {
      debugPrint('❌ SAF file transfer failed');
      debugPrintError(e, stack);
      return null;
    }
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
      
      // Create a proper subdirectory for the software instead of using root directory
      final Software software = ref.read(softwareByIdProvider(softwareId));
      final softwareSubdir = software.name.replaceAll(RegExp(r'[^\w\s-]'), '').trim(); // Clean filename
      final destinationPath = '${state.usbMountPath}/Costa_Software/$softwareSubdir';
      
      debugPrint('📁 Target directory path: $destinationPath');
      
      // Check if we're dealing with external storage (e.g., /storage/XXXX-XXXX)
      final isExternalStorage = state.usbMountPath!.startsWith('/storage/');
      
      if (isExternalStorage) {
        // For external storage, skip direct filesystem operations due to permission restrictions
        // SAF will handle directory creation automatically during file transfer
        debugPrint('📁 External storage detected - skipping direct directory operations, SAF will handle structure');
        state = state.copyWith(usbMountPath: destinationPath);
        return;
      }
      
      // For internal storage or other accessible paths, perform normal directory operations
      final destinationDir = Directory(destinationPath);
      
      if (!await destinationDir.exists()) {
        debugPrint('📁 Creating directory structure...');
        await destinationDir.create(recursive: true);
        // Update the mount path to point to the software-specific directory
        state = state.copyWith(usbMountPath: destinationPath);
        return;
      }
      
      // Update the mount path to the software-specific directory for all subsequent operations
      state = state.copyWith(usbMountPath: destinationPath);
      
      // Scan for existing files in the software directory
      final existingFiles = await destinationDir.list().toList();
      
      if (existingFiles.isNotEmpty) {
        final fileNames = existingFiles
            .map((e) => e.path.split('/').last)
            .where((name) => name.isNotEmpty)
            .toList();
        
        debugPrint('📁 Found ${fileNames.length} existing files in software directory: $fileNames');
        
        // Update state to show confirmation needed
        state = state.copyWith(
          filesToDelete: fileNames,
          needsDeleteConfirmation: true,
          transferStatus: 'Found ${fileNames.length} existing files in software directory. Confirm deletion to proceed.',
        );
        
        // Pause here - user must call confirmDeletion() to proceed
        return;
      } else {
        debugPrint('✅ Software directory is empty, proceeding with transfer');
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
          debugPrint('🔍 Calculating SHA256 hash for integrity check...');
          debugPrint('🔍 File size: ${fileBytes.length} bytes');
          final calculatedHash = sha256.convert(fileBytes).toString();
          debugPrint('🔍 Expected hash: ${software.sha256FileHash}');
          debugPrint('🔍 Calculated hash: $calculatedHash');
          
          if (calculatedHash != software.sha256FileHash) {
            debugPrint('❌ Hash mismatch - file integrity check failed');
            throw Exception('File integrity check failed - corrupted download');
          } else {
            debugPrint('✅ Hash verification successful');
          }
        } else {
          debugPrint('⚠️ No SHA256 hash provided, skipping integrity check');
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
        
        outputPath = await _extractZipToDestinationSAF(
          fileBytes, 
          state.usbMountPath!, 
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

        // Use SAF for file transfer
        outputPath = await _transferFileWithSAF(fileName, fileBytes);
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
    debugPrint('❌ cancelTransfer() - User cancelled transfer');
    debugPrint('📊 Previous state - Progress: ${state.transferProgress}, Status: ${state.transferStatus}');
    state = state.copyWith(
      isCancelled: true,
      isCancellable: false,
      transferStatus: 'Transfer cancelled by user',
      transferProgress: 0.0,
      transferStarted: false,
    );
    debugPrint('✅ Transfer cancellation complete');
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
    
    // Check if we're dealing with external storage (e.g., /storage/XXXX-XXXX)
    final isExternalStorage = state.usbMountPath!.startsWith('/storage/');
    
    if (isExternalStorage) {
      // For external storage, skip direct filesystem operations due to permission restrictions
      // SAF operations will overwrite existing files automatically, so cleanup isn't needed
      debugPrint('📁 External storage detected - skipping cleanup, SAF will handle file overwrites');
      return;
    }
    
    // For internal storage or other accessible paths, perform normal cleanup
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
