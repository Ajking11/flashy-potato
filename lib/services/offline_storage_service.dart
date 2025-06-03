import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/document.dart';
import '../models/software.dart' as models;
import '../models/machine.dart' as models;
import 'database.dart';

class OfflineStorageService {
  static const String _documentsKey = 'offline_documents';
  static const String _softwareKey = 'offline_software';
  static const String _machinesKey = 'offline_machines';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _pendingUploadsKey = 'pending_uploads';
  
  // Drift database instance
  static AppDatabase? _database;
  static AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }
  
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();
  
  // Enhanced Document operations with Drift
  Future<void> saveDocumentsOffline(List<TechnicalDocument> documents) async {
    try {
      // Save to Drift database for better querying
      await database.insertOrUpdateDocuments(documents);
      
      // Keep SharedPreferences for backward compatibility
      final prefs = await _prefs;
      final documentsJson = documents.map((doc) => doc.toJson()).toList();
      await prefs.setString(_documentsKey, jsonEncode(documentsJson));
      
      // Update sync metadata
      await database.updateSyncMetadata('documents', documents.length);
      
      debugPrint('Saved ${documents.length} documents offline with enhanced querying');
    } catch (e) {
      debugPrint('Error saving documents offline: $e');
      throw Exception('Failed to save documents offline: $e');
    }
  }

  Future<List<TechnicalDocument>> getDocumentsOffline() async {
    try {
      // Try to get from Drift database first for better performance
      final documentsFromDb = await database.getAllDocuments();
      if (documentsFromDb.isNotEmpty) {
        debugPrint('Loaded ${documentsFromDb.length} documents from Drift database');
        return documentsFromDb;
      }
      
      // Fallback to SharedPreferences for backward compatibility
      final prefs = await _prefs;
      final documentsJsonString = prefs.getString(_documentsKey);
      
      if (documentsJsonString == null) {
        debugPrint('No offline documents found');
        return [];
      }
      
      final documentsJson = jsonDecode(documentsJsonString) as List;
      final documents = documentsJson
          .map((json) => TechnicalDocument.fromJson(json))
          .toList();
      
      debugPrint('Loaded ${documents.length} documents from SharedPreferences (fallback)');
      return documents;
    } catch (e) {
      debugPrint('Error loading documents from offline storage: $e');
      return [];
    }
  }

  // Enhanced querying methods for documents
  Future<List<TechnicalDocument>> searchDocuments(String searchTerm) async {
    try {
      return await database.searchDocuments(searchTerm);
    } catch (e) {
      debugPrint('Error searching documents: $e');
      return [];
    }
  }

  Future<List<TechnicalDocument>> getDocumentsByMachine(String machineId) async {
    try {
      return await database.getDocumentsByMachine(machineId);
    } catch (e) {
      debugPrint('Error getting documents by machine: $e');
      return [];
    }
  }

  Future<List<TechnicalDocument>> getDocumentsByCategory(String category) async {
    try {
      return await database.getDocumentsByCategory(category);
    } catch (e) {
      debugPrint('Error getting documents by category: $e');
      return [];
    }
  }

  Future<List<TechnicalDocument>> getDownloadedDocuments() async {
    try {
      return await database.getDownloadedDocuments();
    } catch (e) {
      debugPrint('Error getting downloaded documents: $e');
      return [];
    }
  }

  Future<TechnicalDocument?> getDocumentById(String documentId) async {
    try {
      return await database.getDocumentById(documentId);
    } catch (e) {
      debugPrint('Error getting document by ID: $e');
      return null;
    }
  }

  // Enhanced Software operations with Drift
  Future<void> saveSoftwareOffline(List<models.Software> software) async {
    try {
      // Save to Drift database for better querying
      await database.insertOrUpdateSoftwares(software);
      
      // Keep SharedPreferences for backward compatibility
      final prefs = await _prefs;
      final softwareJson = software.map((sw) => sw.toJson()).toList();
      await prefs.setString(_softwareKey, jsonEncode(softwareJson));
      
      // Update sync metadata
      await database.updateSyncMetadata('software', software.length);
      
      debugPrint('Saved ${software.length} software items offline with enhanced querying');
    } catch (e) {
      debugPrint('Error saving software offline: $e');
      throw Exception('Failed to save software offline: $e');
    }
  }

  Future<List<models.Software>> getSoftwareOffline() async {
    try {
      // Try to get from Drift database first for better performance
      final softwareFromDb = await database.getAllSoftware();
      if (softwareFromDb.isNotEmpty) {
        debugPrint('Loaded ${softwareFromDb.length} software items from Drift database');
        return softwareFromDb;
      }
      
      // Fallback to SharedPreferences for backward compatibility
      final prefs = await _prefs;
      final softwareJsonString = prefs.getString(_softwareKey);
      
      if (softwareJsonString == null) {
        debugPrint('No offline software found');
        return [];
      }
      
      final softwareJson = jsonDecode(softwareJsonString) as List;
      final software = softwareJson
          .map((json) => models.Software.fromJson(json))
          .toList();
      
      debugPrint('Loaded ${software.length} software items from SharedPreferences (fallback)');
      return software;
    } catch (e) {
      debugPrint('Error loading software from offline storage: $e');
      return [];
    }
  }

  // Enhanced querying methods for software
  Future<List<models.Software>> searchSoftware(String searchTerm) async {
    try {
      return await database.searchSoftware(searchTerm);
    } catch (e) {
      debugPrint('Error searching software: $e');
      return [];
    }
  }

  Future<List<models.Software>> getSoftwareByMachine(String machineId) async {
    try {
      return await database.getSoftwareByMachine(machineId);
    } catch (e) {
      debugPrint('Error getting software by machine: $e');
      return [];
    }
  }

  Future<List<models.Software>> getSoftwareByCategory(String category) async {
    try {
      return await database.getSoftwareByCategory(category);
    } catch (e) {
      debugPrint('Error getting software by category: $e');
      return [];
    }
  }

  Future<List<models.Software>> getDownloadedSoftware() async {
    try {
      return await database.getDownloadedSoftware();
    } catch (e) {
      debugPrint('Error getting downloaded software: $e');
      return [];
    }
  }

  Future<models.Software?> getSoftwareById(String softwareId) async {
    try {
      return await database.getSoftwareById(softwareId);
    } catch (e) {
      debugPrint('Error getting software by ID: $e');
      return null;
    }
  }

  // Enhanced Machine operations with Drift
  Future<void> saveMachinesOffline(List<models.Machine> machines) async {
    try {
      // Save to Drift database for better querying
      await database.insertOrUpdateMachines(machines);
      
      // Keep SharedPreferences for backward compatibility
      final prefs = await _prefs;
      final machinesJson = machines.map((machine) => machine.toJson()).toList();
      await prefs.setString(_machinesKey, jsonEncode(machinesJson));
      
      // Update sync metadata
      await database.updateSyncMetadata('machines', machines.length);
      
      debugPrint('Saved ${machines.length} machines offline with enhanced querying');
    } catch (e) {
      debugPrint('Error saving machines offline: $e');
      throw Exception('Failed to save machines offline: $e');
    }
  }

  Future<List<models.Machine>> getMachinesOffline() async {
    try {
      // Try to get from Drift database first for better performance
      final machinesFromDb = await database.getAllMachines();
      if (machinesFromDb.isNotEmpty) {
        debugPrint('Loaded ${machinesFromDb.length} machines from Drift database');
        return machinesFromDb;
      }
      
      // Fallback to SharedPreferences for backward compatibility
      final prefs = await _prefs;
      final machinesJsonString = prefs.getString(_machinesKey);
      
      if (machinesJsonString == null) {
        debugPrint('No offline machines found');
        return [];
      }
      
      final machinesJson = jsonDecode(machinesJsonString) as List;
      final machines = machinesJson
          .map((json) => models.Machine.fromJson(json))
          .toList();
      
      debugPrint('Loaded ${machines.length} machines from SharedPreferences (fallback)');
      return machines;
    } catch (e) {
      debugPrint('Error loading machines from offline storage: $e');
      return [];
    }
  }

  // Enhanced querying methods for machines
  Future<List<models.Machine>> searchMachines(String searchTerm) async {
    try {
      return await database.searchMachines(searchTerm);
    } catch (e) {
      debugPrint('Error searching machines: $e');
      return [];
    }
  }

  Future<models.Machine?> getMachineById(String machineId) async {
    try {
      return await database.getMachineById(machineId);
    } catch (e) {
      debugPrint('Error getting machine by ID: $e');
      return null;
    }
  }

  // Sync timestamp operations
  Future<void> updateLastSyncTimestamp() async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
      debugPrint('Updated last sync timestamp');
    } catch (e) {
      debugPrint('Error updating sync timestamp: $e');
    }
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    try {
      final prefs = await _prefs;
      final timestampString = prefs.getString(_lastSyncKey);
      
      if (timestampString == null) {
        return null;
      }
      
      return DateTime.parse(timestampString);
    } catch (e) {
      debugPrint('Error getting last sync timestamp: $e');
      return null;
    }
  }

  // Pending uploads for when user goes back online
  Future<void> addPendingUpload(Map<String, dynamic> uploadData) async {
    try {
      final prefs = await _prefs;
      final pendingUploadsJson = prefs.getString(_pendingUploadsKey);
      
      List<Map<String, dynamic>> pendingUploads = [];
      if (pendingUploadsJson != null) {
        final decoded = jsonDecode(pendingUploadsJson) as List;
        pendingUploads = decoded.cast<Map<String, dynamic>>();
      }
      
      pendingUploads.add(uploadData);
      await prefs.setString(_pendingUploadsKey, jsonEncode(pendingUploads));
      debugPrint('Added pending upload');
    } catch (e) {
      debugPrint('Error adding pending upload: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingUploads() async {
    try {
      final prefs = await _prefs;
      final pendingUploadsJson = prefs.getString(_pendingUploadsKey);
      
      if (pendingUploadsJson == null) {
        return [];
      }
      
      final decoded = jsonDecode(pendingUploadsJson) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting pending uploads: $e');
      return [];
    }
  }

  Future<void> clearPendingUploads() async {
    try {
      final prefs = await _prefs;
      await prefs.remove(_pendingUploadsKey);
      debugPrint('Cleared pending uploads');
    } catch (e) {
      debugPrint('Error clearing pending uploads: $e');
    }
  }

  // File storage operations for downloaded content
  Future<String> getOfflineFilesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final offlineDir = Directory('${appDir.path}/offline_files');
    
    if (!await offlineDir.exists()) {
      await offlineDir.create(recursive: true);
    }
    
    return offlineDir.path;
  }

  Future<bool> isFileDownloaded(String fileId) async {
    try {
      final offlineDir = await getOfflineFilesDirectory();
      final file = File('$offlineDir/$fileId');
      return await file.exists();
    } catch (e) {
      debugPrint('Error checking if file is downloaded: $e');
      return false;
    }
  }

  Future<String?> getOfflineFilePath(String fileId) async {
    try {
      final offlineDir = await getOfflineFilesDirectory();
      final filePath = '$offlineDir/$fileId';
      final file = File(filePath);
      
      if (await file.exists()) {
        return filePath;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting offline file path: $e');
      return null;
    }
  }

  // Clean up old or unused offline data
  Future<void> cleanupOfflineData({int maxAgeDays = 30}) async {
    try {
      final offlineDir = await getOfflineFilesDirectory();
      final directory = Directory(offlineDir);
      
      if (!await directory.exists()) {
        return;
      }
      
      final now = DateTime.now();
      final cutoffDate = now.subtract(Duration(days: maxAgeDays));
      
      await for (final entity in directory.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
            debugPrint('Deleted old offline file: ${entity.path}');
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up offline data: $e');
    }
  }

  // Enhanced storage usage information including database stats
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final offlineDir = await getOfflineFilesDirectory();
      final directory = Directory(offlineDir);
      
      // Get file storage info
      int totalFiles = 0;
      int totalSizeBytes = 0;
      
      if (await directory.exists()) {
        await for (final entity in directory.list()) {
          if (entity is File) {
            totalFiles++;
            final stat = await entity.stat();
            totalSizeBytes += stat.size;
          }
        }
      }
      
      // Get database storage stats
      final dbStats = await database.getStorageStats();
      final syncInfo = await database.getSyncInfo();
      
      return {
        'totalFiles': totalFiles,
        'totalSizeBytes': totalSizeBytes,
        'totalSizeMB': (totalSizeBytes / (1024 * 1024)),
        'database': {
          'machines': dbStats['machines'],
          'documents': dbStats['documents'],
          'software': dbStats['software'],
          'syncInfo': syncInfo,
        },
      };
    } catch (e) {
      debugPrint('Error getting storage info: $e');
      return {
        'totalFiles': 0,
        'totalSizeBytes': 0,
        'totalSizeMB': 0.0,
        'database': {
          'machines': 0,
          'documents': 0,
          'software': 0,
          'syncInfo': {},
        },
      };
    }
  }

  // Clear all offline data including database
  Future<void> clearAllOfflineData() async {
    try {
      // Clear Drift database
      await database.clearAllData();
      
      // Clear SharedPreferences
      final prefs = await _prefs;
      await prefs.remove(_documentsKey);
      await prefs.remove(_softwareKey);
      await prefs.remove(_machinesKey);
      await prefs.remove(_lastSyncKey);
      await prefs.remove(_pendingUploadsKey);
      
      // Clear offline files
      final offlineDir = await getOfflineFilesDirectory();
      final directory = Directory(offlineDir);
      
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
      
      debugPrint('Cleared all offline data including database');
    } catch (e) {
      debugPrint('Error clearing offline data: $e');
      throw Exception('Failed to clear offline data: $e');
    }
  }

  // Enhanced method to get last sync timestamp from database
  Future<DateTime?> getLastSyncTimestampFromDb(String tableName) async {
    try {
      return await database.getLastSyncTimestamp(tableName);
    } catch (e) {
      debugPrint('Error getting last sync timestamp from database: $e');
      return null;
    }
  }

  // Dispose database resources
  Future<void> dispose() async {
    try {
      await _database?.close();
      _database = null;
      debugPrint('Disposed offline storage database');
    } catch (e) {
      debugPrint('Error disposing offline storage: $e');
    }
  }
}