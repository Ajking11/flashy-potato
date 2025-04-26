import 'package:flutter/foundation.dart';

/// A logger service that provides standardized logging functionality 
/// for the Costa Toolbox application.
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  
  factory LoggerService() {
    return _instance;
  }
  
  LoggerService._internal();
  
  // Log levels
  static const int _kVerbose = 0;
  static const int _kDebug = 1;
  static const int _kInfo = 2;
  static const int _kWarning = 3;
  static const int _kError = 4;
  static const int _kWtf = 5; // "What a Terrible Failure"
  
  // Current log level - adjust this to control verbosity
  int _currentLogLevel = kDebugMode ? _kVerbose : _kInfo;
  
  set logLevel(int level) {
    _currentLogLevel = level;
  }
  
  // Helper method to format log messages
  String _formatLogMessage(String tag, String message) {
    final now = DateTime.now();
    final timestamp = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}";
    return "[$timestamp] $tag: $message";
  }
  
  /// Log a verbose message
  void v(String tag, String message) {
    if (_currentLogLevel <= _kVerbose) {
      debugPrint(_formatLogMessage("VERBOSE/$tag", message));
    }
  }
  
  /// Log a debug message
  void d(String tag, String message) {
    if (_currentLogLevel <= _kDebug) {
      debugPrint(_formatLogMessage("DEBUG/$tag", message));
    }
  }
  
  /// Log an info message
  void i(String tag, String message) {
    if (_currentLogLevel <= _kInfo) {
      debugPrint(_formatLogMessage("INFO/$tag", message));
    }
  }
  
  /// Log a warning message
  void w(String tag, String message) {
    if (_currentLogLevel <= _kWarning) {
      debugPrint(_formatLogMessage("WARNING/$tag", message));
    }
  }
  
  /// Log an error message
  void e(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    if (_currentLogLevel <= _kError) {
      final errorMsg = error != null ? "\nError: $error" : "";
      final stackMsg = stackTrace != null ? "\nStackTrace: $stackTrace" : "";
      debugPrint(_formatLogMessage("ERROR/$tag", "$message$errorMsg$stackMsg"));
    }
  }
  
  /// Log a "What a Terrible Failure" message - for truly exceptional problems
  void wtf(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    if (_currentLogLevel <= _kWtf) {
      final errorMsg = error != null ? "\nError: $error" : "";
      final stackMsg = stackTrace != null ? "\nStackTrace: $stackTrace" : "";
      debugPrint(_formatLogMessage("WTF/$tag", "$message$errorMsg$stackMsg"));
    }
  }
  
  // Static helpers for easier migration from debugPrint
  static void logVerbose(String tag, String message) => _instance.v(tag, message);
  static void logDebug(String tag, String message) => _instance.d(tag, message);
  static void logInfo(String tag, String message) => _instance.i(tag, message);
  static void logWarning(String tag, String message) => _instance.w(tag, message);
  static void logError(String tag, String message, [dynamic error, StackTrace? stackTrace]) => 
      _instance.e(tag, message, error, stackTrace);
  static void logWtf(String tag, String message, [dynamic error, StackTrace? stackTrace]) => 
      _instance.wtf(tag, message, error, stackTrace);
}

// Global instance for easy access
final logger = LoggerService();