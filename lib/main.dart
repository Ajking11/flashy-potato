import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'providers/filter_provider.dart';
import 'providers/document_provider.dart';
import 'providers/preferences_provider.dart';
import 'constants.dart';
import 'screens/login_screen.dart';
import 'services/session_manager.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        FilterProvider.initialize(),
        DocumentProvider.initialize(),
        PreferencesProvider.initialize(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final filterProvider = snapshot.data?[0] as FilterProvider? ?? FilterProvider();
          final documentProvider = snapshot.data?[1] as DocumentProvider? ?? DocumentProvider();
          final preferencesProvider = snapshot.data?[2] as PreferencesProvider? ?? PreferencesProvider();
          
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<FilterProvider>.value(
                value: filterProvider,
              ),
              ChangeNotifierProvider<DocumentProvider>.value(
                value: documentProvider,
              ),
              ChangeNotifierProvider<PreferencesProvider>.value(
                value: preferencesProvider,
              ),
            ],
            child: Consumer<PreferencesProvider>(
              builder: (context, prefsProvider, child) {
                return MaterialApp(
                  title: 'Costa Coffee FSE Toolbox',
                  theme: ThemeService.getLightTheme(),
                  darkTheme: ThemeService.getDarkTheme(),
                  themeMode: prefsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  debugShowCheckedModeBanner: false,
                  home: const SplashScreen(),
                );
              },
            ),
          );
        } else {
          // Return a loading screen while initializing
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(costaRed),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

// SplashScreen now navigates to LoginScreen instead of AppNavigator
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Clear any existing session
    SessionManager.clearSession();
    
    // Set a timer to navigate to the login page after a delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {  // Check if widget is still mounted before using context
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Use a gradient from deep red to lighter red
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