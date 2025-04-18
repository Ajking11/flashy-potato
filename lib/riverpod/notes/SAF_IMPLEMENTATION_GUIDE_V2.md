# Storage Access Framework Implementation for USB Transfer (Enhanced Version)

This document outlines the enhanced implementation of USB file transfer using the Storage Access Framework (SAF) for the Costa Toolbox app, with backward compatibility for older Android versions.

## 1. Approach Overview

Our enhanced implementation provides a robust solution that:

- Uses SAF for Android 10+ (API 29+) for full compatibility with Scoped Storage restrictions
- Falls back to direct file access for older Android versions when possible
- Provides a consistent user experience across all Android versions
- Handles edge cases and errors gracefully with user-friendly messages
- Detects Android version at runtime to apply the appropriate strategy

## 2. Latest Required Packages

```yaml
dependencies:
  # For SAF implementation
  file_picker: ^10.1.2  # For picking directories/files (SAF compatible)
  permission_handler: ^12.0.0+1  # For handling permissions
  flutter_file_dialog: ^3.0.2  # For saving files through system dialog
```

## 3. Key Implementation Components

### 3.1 Android Version Detection

Added runtime detection of Android version to adapt the behavior appropriately:

```dart
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
```

### 3.2 Smarter Permission Handling

Improved permission handling with different approaches based on Android version:

```dart
Future<bool> _checkAndRequestPermissions() async {
  if (Platform.isAndroid) {
    try {
      final isAndroid10Plus = await _isAndroid10OrHigher();
      
      // Base storage permissions
      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted && !isAndroid10Plus) {
        // For older Android versions, we need this permission
        return false;
      }

      // For Android 11+, try to request MANAGE_EXTERNAL_STORAGE
      if (isAndroid10Plus) {
        final externalStorage = await Permission.manageExternalStorage.status;
        if (!externalStorage.isGranted) {
          await Permission.manageExternalStorage.request();
          // Continue even if not granted, as SAF will handle access
        }
      }

      return true;
    } catch (e) {
      // If there's an error with permissions, try to continue with SAF
      return true;
    }
  }

  // For iOS or other platforms
  return true;
}
```

### 3.3 Enhanced USB Detection

Improved detection with better path analysis and version-specific messaging:

```dart
Future<void> detectUsb() async {
  // Reset state
  state = state.copyWith(/* reset state */);

  try {
    // Check permissions
    final permissionStatus = await _checkAndRequestPermissions();
    if (!permissionStatus) {
      // Handle permission denied
      return;
    }

    final isAndroid10Plus = await _isAndroid10OrHigher();
    
    // Different instructions based on Android version
    state = state.copyWith(
      transferStatus: isAndroid10Plus
          ? 'Select your USB drive or external storage location'
          : 'Select a destination folder on your device',
    );

    // Use FilePicker with improved options
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select USB drive or folder',
      lockParentWindow: true,
    );

    if (result == null) {
      // User canceled
      return;
    }

    // Extract directory name and check if it looks like a USB drive
    final directoryName = _getDirectoryNameFromPath(result);
    final isLikelyUsbDrive = _isLikelyUsbDrivePath(result);

    // Update state with better messaging
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
    // Error handling
  }
}

// Helper to identify likely USB paths
bool _isLikelyUsbDrivePath(String path) {
  final lowerPath = path.toLowerCase();
  
  return lowerPath.contains('/storage/usb') || 
         lowerPath.contains('/mnt/usb') ||
         lowerPath.contains('/storage/emulated/0/usb') ||
         lowerPath.contains('/storage/') && !lowerPath.contains('/emulated/0');
}
```

### 3.4 Improved File Transfer

Added a hybrid approach that chooses the best method based on Android version and path:

```dart
Future<void> startTransfer() async {
  // Validation and setup
  
  try {
    // Prepare file data
    final software = ref.read(softwareByIdProvider(softwareId));
    final fileBytes = await File(state.sourcePath!).readAsBytes();
    final fileName = software.filePath.split('/').last;
    
    // Choose best approach based on Android version and path
    String? outputPath;
    final isAndroid10Plus = await _isAndroid10OrHigher();
    
    if (isAndroid10Plus || !_canWriteDirectly(state.usbMountPath!)) {
      // SAF approach with FlutterFileDialog
      final tempFile = await _createTempFile(fileName, fileBytes);
      
      try {
        // Use system dialog
        outputPath = await FlutterFileDialog.saveFile(params: SaveFileDialogParams(
          sourceFilePath: tempFile.path,
          fileName: fileName,
        ));
        
        await _cleanupTempFile(tempFile);
      } catch (e) {
        // Try direct writing as fallback for older Android
        if (!isAndroid10Plus) {
          outputPath = await _writeFileDirect(state.usbMountPath!, fileName, fileBytes);
        } else {
          rethrow;
        }
      }
    } else {
      // Direct file writing for older Android or app-specific paths
      outputPath = await _writeFileDirect(state.usbMountPath!, fileName, fileBytes);
    }
    
    // Handle result and finalize
    if (outputPath == null) {
      // Handle cancellation
      return;
    }
    
    // Success
    state = state.copyWith(
      transferProgress: 1.0,
      transferComplete: true,
      transferStatus: 'Transfer complete!',
      outputPath: outputPath,
    );
  } catch (e, stack) {
    // Enhanced error handling with user-friendly messages
    final errorMsg = _getUserFriendlyErrorMessage(e.toString());
    state = state.copyWith(
      transferStatus: 'Error: $errorMsg',
      error: 'Transfer failed: ${e.toString()}',
    );
  }
}

// Helper for direct file writing (for older Android or specific paths)
Future<String?> _writeFileDirect(String directory, String fileName, Uint8List data) async {
  try {
    final outputPath = '$directory/$fileName';
    final outputFile = File(outputPath);
    
    // Create parent directories if needed
    await outputFile.parent.create(recursive: true);
    
    // Write file
    await outputFile.writeAsBytes(data);
    return outputPath;
  } catch (e) {
    // Handle errors
    return null;
  }
}

// Check if a path is likely to be directly writeable 
bool _canWriteDirectly(String path) {
  return path.startsWith('/storage/emulated/0') ||  // Internal storage
         (Platform.isAndroid && path.startsWith('/data/'));  // App-specific
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
```

## 4. UI Improvements

We've enhanced the UI to be more informative and responsive:

1. Changed terminology from "USB detection" to "Storage selection"
2. Added clearer instructions based on Android version
3. Improved status messages with more specific information
4. Enhanced error messages to be more user-friendly
5. Added visual indicators for storage type (USB vs. internal storage)

## 5. Progressive Enhancement

Our implementation follows a progressive enhancement approach:

- Full SAF implementation for Android 10+
- Direct file access fallback for older versions
- Helpful error messages and recovery options
- Clear user guidance throughout the process

## 6. Testing Strategy

When testing this implementation, focus on:

1. Test on both Android 10+ and older Android versions
2. Test with and without USB OTG adapters
3. Test permissions scenarios (granted, denied, partial)
4. Test error cases (disconnect during transfer, insufficient storage)
5. Test with various file sizes and types
6. Test on different manufacturer devices (Samsung, Xiaomi, Google)

## 7. Alternative Approaches

For specific challenging scenarios, consider:

1. Using android.hardware.usb.* APIs through a platform channel for direct USB access
2. Using adb to debug USB device connections if testing encounters issues
3. Testing with USB debugging enabled to get more detailed logs

## 8. Future Enhancements

Consider these enhancements for future versions:

1. Add proper progress reporting during file transfer using more sophisticated APIs
2. Add MD5/SHA256 verification of transferred files
3. Support for batch transfers of multiple files
4. Add USB device information (manufacturer, capacity, filesystem)
5. Add metadata to transferred files for better tracking