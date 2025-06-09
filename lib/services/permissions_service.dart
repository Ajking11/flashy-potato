// lib/services/permissions_service.dart
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger_service.dart';

/// Service to handle app permissions and initial permission requests
class PermissionsService {
  static const String _hasAskedForPermissions = 'has_asked_for_permissions';
  static const String _hasSeenPermissionIntro = 'has_seen_permission_intro';

  /// Check if the app has shown the permissions intro screen
  static Future<bool> hasSeenPermissionIntro() async {
    final prefs = SharedPreferencesAsync();
    return await prefs.getBool(_hasSeenPermissionIntro) ?? false;
  }

  /// Mark that the user has seen the permissions intro screen
  static Future<void> markPermissionIntroSeen() async {
    final prefs = SharedPreferencesAsync();
    await prefs.setBool(_hasSeenPermissionIntro, true);
  }

  /// Check if the app has already asked for permissions
  static Future<bool> hasAskedForPermissions() async {
    final prefs = SharedPreferencesAsync();
    return await prefs.getBool(_hasAskedForPermissions) ?? false;
  }

  /// Mark that the app has asked for permissions
  static Future<void> markPermissionsAsked() async {
    final prefs = SharedPreferencesAsync();
    await prefs.setBool(_hasAskedForPermissions, true);
  }

  /// Check if the device is running Android 10 (API 29) or higher
  static Future<bool> isAndroid10OrHigher() async {
    if (!Platform.isAndroid) return false;
    
    try {
      // In a real implementation, we'd use a platform channel or 
      // a dedicated package to get this information accurately
      // For this implementation, we'll assume API 29+
      return true;
    } catch (e) {
      // If we can't determine, assume newer Android for safety
      return true;
    }
  }

  /// Request all required permissions for the app
  static Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    final permissionsToRequest = <Permission>[];
    
    // Always request storage permissions
    permissionsToRequest.add(Permission.storage);
    
    // On Android, also request notification permission
    if (Platform.isAndroid) {
      permissionsToRequest.add(Permission.notification);
      
      // On Android 11+, try to request MANAGE_EXTERNAL_STORAGE
      final isAndroid10Plus = await isAndroid10OrHigher();
      if (isAndroid10Plus) {
        try {
          permissionsToRequest.add(Permission.manageExternalStorage);
        } catch (e) {
          logger.e('PermissionsService', 'Error adding manageExternalStorage permission', e);
        }
      }
    }
    
    // Request permissions
    final results = await permissionsToRequest.request();
    
    // Mark that we've asked for permissions
    await markPermissionsAsked();
    
    return results;
  }

  /// Check the status of all permissions
  static Future<Map<Permission, PermissionStatus>> checkPermissionStatus() async {
    final results = <Permission, PermissionStatus>{};
    
    // Check storage permission
    results[Permission.storage] = await Permission.storage.status;
    
    // Check notification permission on Android
    if (Platform.isAndroid) {
      results[Permission.notification] = await Permission.notification.status;
      
      // Check MANAGE_EXTERNAL_STORAGE on Android 11+
      final isAndroid10Plus = await isAndroid10OrHigher();
      if (isAndroid10Plus) {
        try {
          results[Permission.manageExternalStorage] = 
              await Permission.manageExternalStorage.status;
        } catch (e) {
          logger.e('PermissionsService', 'Error checking manageExternalStorage status', e);
        }
      }
    }
    
    return results;
  }
}