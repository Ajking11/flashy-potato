# Storage Access Framework Implementation for USB Transfer

This document outlines how to implement USB file transfer using the Storage Access Framework (SAF) for the Costa Toolbox app.

## 1. Background

The current implementation uses direct file access via path_provider which has limitations:

- Cannot access USB drives reliably on Android 10+ due to Scoped Storage restrictions
- No standard way to access external storage across platforms
- Permission issues with external storage access

## 2. Recommended Solution: Storage Access Framework (SAF)

The Storage Access Framework is the recommended approach for accessing USB and external storage:

- Works on newer Android versions with Scoped Storage
- User-friendly file picking experience
- Works with all types of storage including USB drives
- Cross-platform compatibility with equivalent APIs on iOS

## 3. Required Packages

Add these packages to pubspec.yaml:

```yaml
dependencies:
  # Existing packages
  # ...
  
  # For SAF implementation
  file_picker: ^10.1.2  # For picking directories/files (SAF compatible)
  permission_handler: ^12.0.0+1  # For handling permissions
  flutter_file_dialog: ^3.0.2  # For saving files through system dialog
```

## 4. Android Configuration

### AndroidManifest.xml

Add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <!-- Other existing declarations -->
    
    <!-- Basic storage permissions -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <!-- For Android 10+ -->
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" 
                     tools:ignore="ScopedStorage" />
                     
    <!-- For USB device detection -->
    <uses-feature android:name="android.hardware.usb.host" />
</manifest>
```

## 5. Implementation Changes

### 1. Update UsbTransferState

Add new fields for SAF support:

```dart
class UsbTransferState {
  // Existing fields
  
  // New fields for SAF
  final String? selectedUsbUri;  // Content URI for selected USB location
  final String? selectedUsbName; // User-friendly name of selected location
  
  // Updated constructor and copyWith method
}
```

### 2. Update USB Detection

Replace current detection with SAF approach:

```dart
Future<void> detectUsb() async {
  state = state.copyWith(
    transferStarted: false,
    transferComplete: false,
    transferProgress: 0.0,
    transferStatus: 'Please select a USB drive location...',
  );
  
  try {
    // Request storage permission first
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      state = state.copyWith(
        transferStatus: 'Storage permission is required to access USB drives.',
        error: 'Permission denied',
      );
      return;
    }
    
    // Use file_picker to select a directory on USB
    final result = await FilePicker.platform.getDirectoryPath();
    
    if (result == null) {
      // User canceled selection
      state = state.copyWith(
        usbDetected: false,
        transferStatus: 'USB drive selection canceled.',
      );
    } else {
      // User selected a directory
      state = state.copyWith(
        usbDetected: true,
        usbMountPath: result,
        selectedUsbName: result.split('/').last,
        transferStatus: 'USB location selected. Ready for transfer.',
      );
    }
  } catch (e, stack) {
    debugPrintError(e, stack);
    state = state.copyWith(
      transferStatus: 'Error selecting USB location: $e',
      error: e.toString(),
    );
  }
}
```

### 3. Update File Transfer

Replace direct file operations with SAF:

```dart
Future<void> startTransfer() async {
  // Validation checks
  
  try {
    final Software software = ref.read(softwareByIdProvider(softwareId));
    final sourceFile = File(state.sourcePath!);
    
    if (!await sourceFile.exists()) {
      // Handle error
      return;
    }
    
    // Progress updates
    state = state.copyWith(/* progress updates */);
    
    // Get file data
    final fileBytes = await sourceFile.readAsBytes();
    final fileName = software.filePath.split('/').last;
    
    // Create destination file path
    final destinationPath = '${state.usbMountPath}/$fileName';
    
    // Write to destination using File API (simplified for demo)
    final outputFile = File(destinationPath);
    await outputFile.writeAsBytes(fileBytes);
    
    // For a real SAF implementation, use DocumentFile from a plugin
    // or the Android platform channel to access the content URI
    
    // Create README file
    final readmeFile = File('${state.usbMountPath}/README.txt');
    await readmeFile.writeAsString('''
COSTA COFFEE SOFTWARE PACKAGE
-----------------------------
Software: ${software.name}
Version: ${software.version}
Date: ${DateTime.now().toString().substring(0, 10)}

INSTALLATION INSTRUCTIONS:
1. Insert this USB drive into the machine's USB port
2. Navigate to the software installation menu
3. Select the file $fileName
${software.password != null ? '4. When prompted, enter password: ${software.password}' : ''}

For support, contact Costa Technical Support.
''');
    
    // Success!
    state = state.copyWith(
      transferProgress: 1.0,
      transferComplete: true,
      transferStatus: 'Transfer complete!',
    );
    
  } catch (e, stack) {
    debugPrintError(e, stack);
    state = state.copyWith(
      transferProgress: 0.0,
      transferStatus: 'Error during transfer: $e',
      error: e.toString(),
    );
  }
}
```

## 6. UI Changes

Update UsbTransferWizard UI to support SAF:

1. Replace the automated USB detection with a "Select USB Drive" button
2. Show the selected location name prominently
3. Add information about the SAF process

## 7. Testing Considerations

1. Test on Android 10+ devices with actual USB drives
2. Test with different USB drive formats (FAT32, exFAT, NTFS)
3. Test cancel scenarios during file selection
4. Test with very large files to ensure progress tracking works

## 8. Alternative Approaches

If SAF causes issues, consider these alternatives:

1. Use platform channels for direct USB access
2. Use USB Host API via platform-specific code
3. Have users mount USB drives via the system UI first, then use file_picker

## 9. Implementation Timeline

1. Add required packages
2. Update state class
3. Implement SAF-based directory selection
4. Modify transfer method
5. Update UI for better user guidance
6. Test on physical devices with USB drives

## Next Steps

Once this is implemented, consider enhancing with:

1. USB device detection through platform channels
2. Multiple file transfer with batch operations
3. Resumable transfers for large files
4. Verification of successful writes using checksums