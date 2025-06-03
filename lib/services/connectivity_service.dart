import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;

enum ConnectivityStatus {
  online,
  offline,
  unknown,
}

class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance {
    _instance ??= ConnectivityService._internal();
    return _instance!;
  }
  
  ConnectivityService._internal();
  
  final _connectivityStreamController = StreamController<ConnectivityStatus>.broadcast();
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;
  Timer? _connectivityTimer;
  
  Stream<ConnectivityStatus> get connectivityStream => _connectivityStreamController.stream;
  ConnectivityStatus get currentStatus => _currentStatus;
  bool get isOnline => _currentStatus == ConnectivityStatus.online;
  bool get isOffline => _currentStatus == ConnectivityStatus.offline;
  
  // Start monitoring connectivity
  void startMonitoring() {
    debugPrint('Starting connectivity monitoring');
    
    // Check connectivity immediately
    _checkConnectivity();
    
    // Set up periodic connectivity checks every 10 seconds
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _checkConnectivity(),
    );
  }
  
  // Stop monitoring connectivity
  void stopMonitoring() {
    debugPrint('Stopping connectivity monitoring');
    _connectivityTimer?.cancel();
    _connectivityTimer = null;
  }
  
  // Manual connectivity check
  Future<ConnectivityStatus> checkConnectivity() async {
    await _checkConnectivity();
    return _currentStatus;
  }
  
  // Internal method to check connectivity
  Future<void> _checkConnectivity() async {
    try {
      // Try to reach Google's DNS server with a 5-second timeout
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _updateConnectivityStatus(ConnectivityStatus.online);
      } else {
        _updateConnectivityStatus(ConnectivityStatus.offline);
      }
    } catch (e) {
      // If lookup fails, we're likely offline
      _updateConnectivityStatus(ConnectivityStatus.offline);
    }
  }
  
  // Update connectivity status and notify listeners
  void _updateConnectivityStatus(ConnectivityStatus newStatus) {
    if (_currentStatus != newStatus) {
      final previousStatus = _currentStatus;
      _currentStatus = newStatus;
      
      debugPrint('Connectivity changed from ${previousStatus.name} to ${newStatus.name}');
      
      // Notify listeners of the change
      _connectivityStreamController.add(newStatus);
      
      // Handle connectivity changes
      _handleConnectivityChange(previousStatus, newStatus);
    }
  }
  
  // Handle connectivity state changes
  void _handleConnectivityChange(
    ConnectivityStatus previousStatus,
    ConnectivityStatus newStatus,
  ) {
    if (previousStatus == ConnectivityStatus.offline && 
        newStatus == ConnectivityStatus.online) {
      debugPrint('Device came back online - triggering sync');
      _onCameOnline();
    } else if (previousStatus == ConnectivityStatus.online && 
               newStatus == ConnectivityStatus.offline) {
      debugPrint('Device went offline');
      _onWentOffline();
    }
  }
  
  // Called when device comes back online
  void _onCameOnline() {
    // This can be used to trigger background sync operations
    // For now, we'll just log it - the actual sync will be handled by notifiers
    debugPrint('Ready for background synchronization');
  }
  
  // Called when device goes offline
  void _onWentOffline() {
    // This can be used to cache current state or prepare for offline mode
    debugPrint('Entering offline mode');
  }
  
  // Test internet connectivity with a specific host
  Future<bool> testConnectivity({
    String host = 'google.com',
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final result = await InternetAddress.lookup(host).timeout(timeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      debugPrint('Connectivity test failed: $e');
      return false;
    }
  }
  
  // Get detailed connectivity information
  Future<Map<String, dynamic>> getConnectivityDetails() async {
    try {
      final startTime = DateTime.now();
      
      // Test multiple hosts for more reliable connectivity detection
      final hosts = ['google.com', 'cloudflare.com', '8.8.8.8'];
      final results = <String, bool>{};
      
      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(host)
              .timeout(const Duration(seconds: 3));
          results[host] = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        } catch (e) {
          results[host] = false;
        }
      }
      
      final endTime = DateTime.now();
      final latency = endTime.difference(startTime).inMilliseconds;
      
      final successfulTests = results.values.where((success) => success).length;
      final isConnected = successfulTests > 0;
      
      return {
        'isConnected': isConnected,
        'latencyMs': latency,
        'testResults': results,
        'successfulTests': successfulTests,
        'totalTests': hosts.length,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting connectivity details: $e');
      return {
        'isConnected': false,
        'latencyMs': -1,
        'testResults': <String, bool>{},
        'successfulTests': 0,
        'totalTests': 0,
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }
  
  // Wait for connectivity to become available
  Future<void> waitForConnectivity({
    Duration maxWait = const Duration(minutes: 5),
    Duration checkInterval = const Duration(seconds: 5),
  }) async {
    if (isOnline) {
      return; // Already online
    }
    
    final completer = Completer<void>();
    Timer? timeoutTimer;
    StreamSubscription? connectivitySubscription;
    
    // Set up timeout
    timeoutTimer = Timer(maxWait, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('Connectivity timeout after ${maxWait.inSeconds} seconds'),
        );
      }
    });
    
    // Listen for connectivity changes
    connectivitySubscription = connectivityStream.listen((status) {
      if (status == ConnectivityStatus.online && !completer.isCompleted) {
        completer.complete();
      }
    });
    
    try {
      await completer.future;
    } finally {
      timeoutTimer.cancel();
      connectivitySubscription.cancel();
    }
  }
  
  // Clean up resources
  void dispose() {
    debugPrint('Disposing connectivity service');
    stopMonitoring();
    _connectivityStreamController.close();
  }
}

class TimeoutException implements Exception {
  final String message;
  
  const TimeoutException(this.message);
  
  @override
  String toString() => 'TimeoutException: $message';
}