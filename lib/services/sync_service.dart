import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'connectivity_service.dart';
import 'offline_storage_service.dart';
import 'firebase_document_service.dart';
import 'firebase_software_service.dart';
import 'firebase_machine_service.dart';

enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
}

class SyncResult {
  final bool success;
  final String? error;
  final Map<String, int> syncedCounts;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    this.error,
    required this.syncedCounts,
    required this.timestamp,
  });
}

class SyncService {
  static SyncService? _instance;
  static SyncService get instance {
    _instance ??= SyncService._internal();
    return _instance!;
  }
  
  SyncService._internal();
  
  final _connectivityService = ConnectivityService.instance;
  final _offlineStorage = OfflineStorageService();
  FirebaseDocumentService? _documentService;
  FirebaseSoftwareService? _softwareService;
  FirebaseMachineService? _machineService;
  bool _firebaseAvailable = false;
  
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  final _syncResultController = StreamController<SyncResult>.broadcast();
  
  SyncStatus _currentStatus = SyncStatus.idle;
  StreamSubscription? _connectivitySubscription;
  Timer? _periodicSyncTimer;
  
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  Stream<SyncResult> get syncResultStream => _syncResultController.stream;
  SyncStatus get currentStatus => _currentStatus;
  bool get isSyncing => _currentStatus == SyncStatus.syncing;
  
  // Initialize Firebase services when available
  void initializeFirebaseServices() {
    try {
      _documentService = FirebaseDocumentService();
      _softwareService = FirebaseSoftwareService();
      _machineService = FirebaseMachineService();
      _firebaseAvailable = true;
      debugPrint('Firebase services initialized for sync');
    } catch (e) {
      debugPrint('Failed to initialize Firebase services: $e');
      _firebaseAvailable = false;
    }
  }
  
  // Start background sync service
  void startBackgroundSync({
    Duration syncInterval = const Duration(minutes: 15),
    bool syncOnConnectivity = true,
  }) {
    debugPrint('Starting background sync service');
    
    // Listen for connectivity changes
    if (syncOnConnectivity) {
      _connectivitySubscription = _connectivityService.connectivityStream.listen(
        _onConnectivityChanged,
      );
    }
    
    // Set up periodic sync
    _periodicSyncTimer = Timer.periodic(syncInterval, (_) {
      if (_connectivityService.isOnline && !isSyncing) {
        syncAll();
      }
    });
    
    // Perform initial sync if online
    if (_connectivityService.isOnline) {
      Timer(const Duration(seconds: 2), () => syncAll());
    }
  }
  
  // Stop background sync service
  void stopBackgroundSync() {
    debugPrint('Stopping background sync service');
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }
  
  // Handle connectivity changes
  void _onConnectivityChanged(ConnectivityStatus status) {
    if (status == ConnectivityStatus.online && !isSyncing) {
      debugPrint('Device came online - starting sync');
      Timer(const Duration(seconds: 1), () => syncAll());
    }
  }
  
  // Sync all data types
  Future<SyncResult> syncAll() async {
    if (isSyncing) {
      debugPrint('Sync already in progress, skipping');
      return SyncResult(
        success: false,
        error: 'Sync already in progress',
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
    
    if (!_connectivityService.isOnline) {
      debugPrint('Device offline, skipping sync');
      return SyncResult(
        success: false,
        error: 'Device is offline',
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
    
    if (!_firebaseAvailable) {
      debugPrint('Firebase services not available, skipping sync');
      return SyncResult(
        success: false,
        error: 'Firebase services not available',
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
    
    _updateSyncStatus(SyncStatus.syncing);
    
    try {
      debugPrint('Starting full data sync');
      final syncStartTime = DateTime.now();
      final syncedCounts = <String, int>{};
      
      // Sync documents
      try {
        final documents = await _documentService?.getAllDocuments() ?? [];
        await _offlineStorage.saveDocumentsOffline(documents);
        syncedCounts['documents'] = documents.length;
        debugPrint('Synced ${documents.length} documents');
      } catch (e) {
        debugPrint('Failed to sync documents: $e');
        syncedCounts['documents'] = 0;
      }
      
      // Sync software
      try {
        final software = await _softwareService?.getAllSoftware() ?? [];
        await _offlineStorage.saveSoftwareOffline(software);
        syncedCounts['software'] = software.length;
        debugPrint('Synced ${software.length} software items');
      } catch (e) {
        debugPrint('Failed to sync software: $e');
        syncedCounts['software'] = 0;
      }
      
      // Sync machines
      try {
        final machines = await _machineService?.getAllMachines() ?? [];
        await _offlineStorage.saveMachinesOffline(machines);
        syncedCounts['machines'] = machines.length;
        debugPrint('Synced ${machines.length} machines');
      } catch (e) {
        debugPrint('Failed to sync machines: $e');
        syncedCounts['machines'] = 0;
      }
      
      // Process pending uploads
      try {
        await _processPendingUploads();
        debugPrint('Processed pending uploads');
      } catch (e) {
        debugPrint('Failed to process pending uploads: $e');
      }
      
      // Update sync timestamp
      await _offlineStorage.updateLastSyncTimestamp();
      
      final syncDuration = DateTime.now().difference(syncStartTime);
      debugPrint('Sync completed in ${syncDuration.inSeconds} seconds');
      
      _updateSyncStatus(SyncStatus.completed);
      
      final result = SyncResult(
        success: true,
        syncedCounts: syncedCounts,
        timestamp: DateTime.now(),
      );
      
      _syncResultController.add(result);
      
      // Reset to idle after a short delay
      Timer(const Duration(seconds: 2), () {
        _updateSyncStatus(SyncStatus.idle);
      });
      
      return result;
      
    } catch (e) {
      debugPrint('Sync failed: $e');
      _updateSyncStatus(SyncStatus.failed);
      
      final result = SyncResult(
        success: false,
        error: e.toString(),
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
      
      _syncResultController.add(result);
      
      // Reset to idle after a short delay
      Timer(const Duration(seconds: 2), () {
        _updateSyncStatus(SyncStatus.idle);
      });
      
      return result;
    }
  }
  
  // Sync only documents
  Future<SyncResult> syncDocuments() async {
    if (!_connectivityService.isOnline) {
      return SyncResult(
        success: false,
        error: 'Device is offline',
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
    
    try {
      final documents = await _documentService?.getAllDocuments() ?? [];
      await _offlineStorage.saveDocumentsOffline(documents);
      
      return SyncResult(
        success: true,
        syncedCounts: {'documents': documents.length},
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return SyncResult(
        success: false,
        error: e.toString(),
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
  }
  
  // Sync only software
  Future<SyncResult> syncSoftware() async {
    if (!_connectivityService.isOnline) {
      return SyncResult(
        success: false,
        error: 'Device is offline',
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
    
    try {
      final software = await _softwareService?.getAllSoftware() ?? [];
      await _offlineStorage.saveSoftwareOffline(software);
      
      return SyncResult(
        success: true,
        syncedCounts: {'software': software.length},
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return SyncResult(
        success: false,
        error: e.toString(),
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
  }
  
  // Sync only machines
  Future<SyncResult> syncMachines() async {
    if (!_connectivityService.isOnline) {
      return SyncResult(
        success: false,
        error: 'Device is offline',
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
    
    try {
      final machines = await _machineService?.getAllMachines() ?? [];
      await _offlineStorage.saveMachinesOffline(machines);
      
      return SyncResult(
        success: true,
        syncedCounts: {'machines': machines.length},
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return SyncResult(
        success: false,
        error: e.toString(),
        syncedCounts: {},
        timestamp: DateTime.now(),
      );
    }
  }
  
  // Process pending uploads when back online
  Future<void> _processPendingUploads() async {
    final pendingUploads = await _offlineStorage.getPendingUploads();
    
    if (pendingUploads.isEmpty) {
      return;
    }
    
    debugPrint('Processing ${pendingUploads.length} pending uploads');
    
    final List<Map<String, dynamic>> failedUploads = [];
    
    for (final upload in pendingUploads) {
      try {
        // Process different types of uploads
        final type = upload['type'] as String?;
        
        switch (type) {
          case 'document_download':
            // Re-attempt document download
            final documentId = upload['documentId'] as String;
            // This would need to be implemented based on your download logic
            debugPrint('Re-attempting document download: $documentId');
            break;
            
          case 'software_download':
            // Re-attempt software download
            final softwareId = upload['softwareId'] as String;
            // This would need to be implemented based on your download logic
            debugPrint('Re-attempting software download: $softwareId');
            break;
            
          case 'analytics_event':
            // Re-send analytics event
            debugPrint('Re-sending analytics event');
            break;
            
          default:
            debugPrint('Unknown upload type: $type');
        }
      } catch (e) {
        debugPrint('Failed to process upload: $e');
        failedUploads.add(upload);
      }
    }
    
    // Update pending uploads list with only failed ones
    if (failedUploads.isEmpty) {
      await _offlineStorage.clearPendingUploads();
    } else {
      // Save failed uploads back for retry later
      await _offlineStorage.clearPendingUploads();
      for (final failedUpload in failedUploads) {
        await _offlineStorage.addPendingUpload(failedUpload);
      }
    }
  }
  
  // Update sync status and notify listeners
  void _updateSyncStatus(SyncStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _syncStatusController.add(newStatus);
      debugPrint('Sync status changed to: ${newStatus.name}');
    }
  }
  
  // Enhanced sync information including database stats
  Future<Map<String, dynamic>> getSyncInfo() async {
    final lastSync = await _offlineStorage.getLastSyncTimestamp();
    final pendingUploads = await _offlineStorage.getPendingUploads();
    final storageInfo = await _offlineStorage.getStorageInfo();
    
    // Get enhanced sync info from database
    final documentsLastSync = await _offlineStorage.getLastSyncTimestampFromDb('documents');
    final softwareLastSync = await _offlineStorage.getLastSyncTimestampFromDb('software');
    final machinesLastSync = await _offlineStorage.getLastSyncTimestampFromDb('machines');
    
    return {
      'lastSyncTimestamp': lastSync?.toIso8601String(),
      'pendingUploadsCount': pendingUploads.length,
      'currentStatus': _currentStatus.name,
      'isOnline': _connectivityService.isOnline,
      'offlineStorageInfo': storageInfo,
      'enhancedSyncInfo': {
        'documents': {
          'lastSync': documentsLastSync?.toIso8601String(),
          'count': storageInfo['database']?['documents'] ?? 0,
        },
        'software': {
          'lastSync': softwareLastSync?.toIso8601String(),
          'count': storageInfo['database']?['software'] ?? 0,
        },
        'machines': {
          'lastSync': machinesLastSync?.toIso8601String(),
          'count': storageInfo['database']?['machines'] ?? 0,
        },
      },
    };
  }
  
  // Force sync regardless of conditions (with user confirmation)
  Future<SyncResult> forceSyncAll() async {
    debugPrint('Force sync requested');
    
    if (!_connectivityService.isOnline) {
      throw Exception('Cannot force sync while offline');
    }
    
    return await syncAll();
  }
  
  // Clean up resources including database
  void dispose() {
    debugPrint('Disposing sync service');
    stopBackgroundSync();
    _syncStatusController.close();
    _syncResultController.close();
    
    // Dispose offline storage database resources
    _offlineStorage.dispose().catchError((e) {
      debugPrint('Error disposing offline storage in sync service: $e');
    });
  }
}