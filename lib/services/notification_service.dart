// lib/services/notification_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../navigation/app_router.dart';
import 'logger_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final String _tag = 'NotificationService';
  
  // FCM topic names
  static const String topicNewDocuments = 'new_documents';
  static const String topicSoftwareUpdates = 'software_updates';
  
  // Preference keys
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyDocumentsNotificationsEnabled = 'documents_notifications_enabled';
  static const String _keySoftwareNotificationsEnabled = 'software_notifications_enabled';
  
  factory NotificationService() {
    return _instance;
  }
  
  NotificationService._internal();
  
  /// Initialize notification service
  Future<void> initialize() async {
    logger.i(_tag, 'Initializing notification service');
    
    // Request permission (this uses the permission_handler in permissions_service.dart)
    await _requestPermissions();
    
    // Configure FCM foreground notifications
    await _configureForegroundNotifications();
    
    // Setup notification channels for Android
    if (Platform.isAndroid) {
      await _setupNotificationChannels();
    }
    
    // Initialize notification settings from preferences
    await _initializeSettings();
    
    // Register FCM handlers
    _registerFCMHandlers();
    
    // Set FCM foreground notification presentation options (iOS)
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Get FCM token, log it, and save it to Firestore
    try {
      final token = await _messaging.getToken();
      logger.i(_tag, 'FCM Token: $token');
      
      if (kDebugMode) {
        print('FCM Token (for testing): $token');
      }
      
      // Listen for token refreshes
      _messaging.onTokenRefresh.listen((newToken) {
        logger.i(_tag, 'FCM Token refreshed');
        saveTokenToFirestore();
      });
      
      // Save the token to Firestore
      await saveTokenToFirestore();
    } catch (e) {
      logger.e(_tag, 'Error getting FCM token', e);
    }
  }
  
  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // We use permission_handler in permissions_service.dart
    // This is just a fallback for iOS
    if (Platform.isIOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      logger.i(_tag, 'iOS Notification permission status: ${settings.authorizationStatus}');
    }
  }
  
  /// Configure foreground notifications
  Future<void> _configureForegroundNotifications() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@drawable/notification_icon');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationTap(details.payload);
      },
    );
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });
  }
  
  /// Setup notification channels for Android
  Future<void> _setupNotificationChannels() async {
    // Document updates channel
    const AndroidNotificationChannel documentsChannel = AndroidNotificationChannel(
      'new_documents_channel',
      'New Documents',
      description: 'Notifications for new document updates',
      importance: Importance.high,
    );
    
    // Software updates channel
    const AndroidNotificationChannel softwareChannel = AndroidNotificationChannel(
      'software_updates_channel',
      'Software Updates', 
      description: 'Notifications for new software updates',
      importance: Importance.high,
    );
    
    // High importance channel for general notifications
    const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel for important notifications',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );
    
    // Create notification channels one by one
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(documentsChannel);
      await androidPlugin.createNotificationChannel(softwareChannel);
      await androidPlugin.createNotificationChannel(highImportanceChannel);
      
      // Request notification permission for Android 13+ (API level 33+)
      // Note: This method requires flutter_local_notifications >= 9.0.0
      try {
        await androidPlugin.requestNotificationsPermission();
      } catch (e) {
        logger.w(_tag, 'Could not request notification permission: $e');
        // Fall back to Firebase Messaging permission request
      }
    }
  }
  
  /// Initialize notification settings from preferences
  Future<void> _initializeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool(_keyNotificationsEnabled) ?? true;
    final documentsEnabled = prefs.getBool(_keyDocumentsNotificationsEnabled) ?? true;
    final softwareEnabled = prefs.getBool(_keySoftwareNotificationsEnabled) ?? true;
    
    // Subscribe to topics based on saved preferences
    if (notificationsEnabled) {
      if (documentsEnabled) {
        await subscribeToDocumentUpdates();
      }
      
      if (softwareEnabled) {
        await subscribeToSoftwareUpdates();
      }
    }
  }
  
  /// Register FCM message handlers
  void _registerFCMHandlers() {
    // Background message handler is registered in main.dart
    
    // Handle when notification is tapped and app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i(_tag, 'Notification opened app with message: ${message.messageId}');
      _handleNotificationTap(jsonEncode(message.data));
    });
    
    // Check for initial message (app opened from terminated state via notification)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        logger.i(_tag, 'App opened from terminated state via notification');
        _handleNotificationTap(jsonEncode(message.data));
      }
    });
  }
  
  /// Show a foreground notification
  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    
    if (notification != null) {
      String channelId = 'default_channel';
      
      // Determine which channel to use based on the notification type
      if (message.data['type'] == 'document') {
        channelId = 'new_documents_channel';
      } else if (message.data['type'] == 'software') {
        channelId = 'software_updates_channel';
      }
      
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelId.replaceAll('_', ' '),
            icon: android?.smallIcon ?? '@drawable/notification_icon',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }
  
  /// Handle notification tap
  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        logger.i(_tag, 'Notification tapped with data: $data');
        
        // Navigation to correct screen based on notification type
        if (data['type'] == 'document' && data['documentId'] != null) {
          // Navigate to document details screen
          AppRouter.router.push('/documents/${data['documentId']}');
        } else if (data['type'] == 'software' && data['softwareId'] != null) {
          // Navigate to software details screen
          AppRouter.router.push('/software/${data['softwareId']}');
        }
      } catch (e) {
        logger.e(_tag, 'Error parsing notification payload', e);
      }
    }
  }
  
  /// Subscribe to document updates topic
  Future<void> subscribeToDocumentUpdates() async {
    await _messaging.subscribeToTopic(topicNewDocuments);
    await _saveTopicPreference(_keyDocumentsNotificationsEnabled, true);
    logger.i(_tag, 'Subscribed to document updates topic');
  }
  
  /// Unsubscribe from document updates topic
  Future<void> unsubscribeFromDocumentUpdates() async {
    await _messaging.unsubscribeFromTopic(topicNewDocuments);
    await _saveTopicPreference(_keyDocumentsNotificationsEnabled, false);
    logger.i(_tag, 'Unsubscribed from document updates topic');
  }
  
  /// Subscribe to software updates topic
  Future<void> subscribeToSoftwareUpdates() async {
    await _messaging.subscribeToTopic(topicSoftwareUpdates);
    await _saveTopicPreference(_keySoftwareNotificationsEnabled, true);
    logger.i(_tag, 'Subscribed to software updates topic');
  }
  
  /// Unsubscribe from software updates topic
  Future<void> unsubscribeFromSoftwareUpdates() async {
    await _messaging.unsubscribeFromTopic(topicSoftwareUpdates);
    await _saveTopicPreference(_keySoftwareNotificationsEnabled, false);
    logger.i(_tag, 'Unsubscribed from software updates topic');
  }
  
  /// Enable all notifications
  Future<void> enableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, true);
    
    // Re-subscribe to saved topics
    final documentsEnabled = prefs.getBool(_keyDocumentsNotificationsEnabled) ?? true;
    final softwareEnabled = prefs.getBool(_keySoftwareNotificationsEnabled) ?? true;
    
    if (documentsEnabled) {
      await subscribeToDocumentUpdates();
    }
    
    if (softwareEnabled) {
      await subscribeToSoftwareUpdates();
    }
    
    logger.i(_tag, 'Notifications enabled');
  }
  
  /// Disable all notifications
  Future<void> disableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, false);
    
    // Unsubscribe from all topics
    await _messaging.unsubscribeFromTopic(topicNewDocuments);
    await _messaging.unsubscribeFromTopic(topicSoftwareUpdates);
    
    logger.i(_tag, 'Notifications disabled');
  }
  
  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }
  
  /// Check if document notifications are enabled
  Future<bool> areDocumentNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDocumentsNotificationsEnabled) ?? true;
  }
  
  /// Check if software notifications are enabled
  Future<bool> areSoftwareNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySoftwareNotificationsEnabled) ?? true;
  }
  
  /// Save topic subscription preference
  Future<void> _saveTopicPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  
  /// Save FCM token to Firestore
  Future<void> saveTokenToFirestore() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        // Get current user from Firebase Auth
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          try {
            // Try to update the existing document first
            await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
              'fcmToken': token,
              'tokenLastUpdated': FieldValue.serverTimestamp(),
              'deviceInfo': {
                'platform': Platform.operatingSystem,
                'version': Platform.operatingSystemVersion,
              }
            });
          } catch (e) {
            // If update fails (document doesn't exist), create a new document
            await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
              'fcmToken': token,
              'tokenLastUpdated': FieldValue.serverTimestamp(),
              'userId': currentUser.uid,
              'email': currentUser.email,
              'deviceInfo': {
                'platform': Platform.operatingSystem,
                'version': Platform.operatingSystemVersion,
              }
            }, SetOptions(merge: true));
          }
          logger.i(_tag, 'FCM token saved to Firestore');
        } else {
          // User not logged in, just log the token
          logger.i(_tag, 'FCM Token obtained but user not logged in: $token');
        }
      }
    } catch (e) {
      logger.e(_tag, 'Error saving FCM token to Firestore', e);
    }
  }
}

// The background message handler is now defined in main.dart as a top-level function
// This is necessary for it to work correctly with the VM when the app is in background

// Global instance for easy access
final notificationService = NotificationService();