// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'services/permissions_service.dart';
import 'services/theme_service.dart';
import 'services/logger_service.dart';
import 'services/notification_service.dart';
import 'navigation/app_router.dart';

// Background FCM handler - must be defined outside of any class
// This is required for background message handling to work properly
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase since this is running in a separate isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // We don't need to manually show notifications - FCM will do this automatically
  // for messages received in the background
  
  // Log for debugging purposes
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
  }
}

Future<void> main() async {
  // Set up error handling for the entire app
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.e('FlutterError', 'Flutter error caught', details.exception, details.stack);
  };

  // Handle other async errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    try {
      // Initialize Firebase with error handling
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Set up background message handler for FCM
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Request notification permissions
      await FirebaseMessaging.instance.requestPermission();
      
      // Initialize notification service
      await notificationService.initialize();
      
      logger.i('Firebase', 'Firebase initialized successfully');
    } catch (e) {
      logger.e('Firebase', 'Error initializing Firebase', e);
      // Continue anyway to allow app to run with local data
    }
    
    // Simple provider container without extra observers that might cause errors
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stack) {
    logger.e('App', 'Caught error in runZonedGuarded', error, stack);
  });
}

/// Provider to track permissions intro state
final permissionIntroProvider = StateProvider<bool>((ref) => false);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isLoading = true;
  bool _hasSeenPermissionIntro = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionIntroStatus();
  }

  Future<void> _checkPermissionIntroStatus() async {
    try {
      final hasSeenIntro = await PermissionsService.hasSeenPermissionIntro();
      
      if (mounted) {
        setState(() {
          _hasSeenPermissionIntro = hasSeenIntro;
          _isLoading = false;
        });
        
        // Update the provider state
        ref.read(permissionIntroProvider.notifier).state = hasSeenIntro;
      }
    } catch (e) {
      // If there's an error, we'll assume the user hasn't seen the intro
      if (mounted) {
        setState(() {
          _hasSeenPermissionIntro = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while checking permissions status
    if (_isLoading) {
      return MaterialApp(
        title: 'Costa Coffee FSE Toolbox',
        theme: ThemeService.getLightTheme(),
        debugShowCheckedModeBanner: true,
        home: const SplashScreen(),
      );
    }

    // Redirect to permissions intro if needed
    if (!_hasSeenPermissionIntro) {
      // Delayed redirect to permissions intro to avoid router conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          // Override the initial location
          AppRouter.router.go('/permissions');
        }
      });
    }

    return MaterialApp.router(
      title: 'Costa Coffee FSE Toolbox',
      theme: ThemeService.getLightTheme(),
      debugShowCheckedModeBanner: true,
      routerConfig: AppRouter.router,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Splash screen UI remains the same
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              costaRed,
              Color(0xFF8C2341), // Lighter shade of Costa red
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with container for better visibility
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icons/trans_cclogo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 40),
              // App name
              const Text(
                'FSE Toolbox',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CostaDisplayO',
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                'Your complete Costa maintenance companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'CostaTextO',
                ),
              ),
              const SizedBox(height: 60),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}