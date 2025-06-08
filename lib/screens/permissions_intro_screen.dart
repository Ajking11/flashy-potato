// lib/screens/permissions_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../services/permissions_service.dart';

class PermissionsIntroScreen extends StatefulWidget {
  const PermissionsIntroScreen({super.key});

  @override
  State<PermissionsIntroScreen> createState() => _PermissionsIntroScreenState();
}

class _PermissionsIntroScreenState extends State<PermissionsIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isRequesting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage == 0) {
      // Welcome page -> Storage permission page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 1) {
      // Storage permission page -> Request storage permission and go to notifications
      _requestStoragePermission();
    } else if (_currentPage == 2) {
      // Notifications page -> Request notification permission and finish
      _requestNotificationPermission();
    }
  }

  Future<void> _requestStoragePermission() async {
    if (!mounted) return;
    
    setState(() {
      _isRequesting = true;
    });

    try {
      debugPrint('🔐 Requesting external storage permission...');
      
      // Request MANAGE_EXTERNAL_STORAGE for Android 30+
      final storageStatus = await Permission.manageExternalStorage.request();
      debugPrint('🔐 Storage permission result: $storageStatus');
      
      if (!mounted) return;
      
      // Show result feedback
      String message;
      Color backgroundColor;
      if (storageStatus.isGranted) {
        message = 'Storage access granted! 📁';
        backgroundColor = Colors.green;
      } else {
        message = 'Storage access denied. You can grant it later in settings.';
        backgroundColor = Colors.orange;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Wait a moment for user to see the feedback, then proceed to next page
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      debugPrint('❌ Error requesting storage permission: $e');
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting storage permission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    if (!mounted) return;
    
    setState(() {
      _isRequesting = true;
    });

    try {
      debugPrint('🔔 Requesting notification permission...');
      
      // Request notification permission
      final notificationStatus = await Permission.notification.request();
      debugPrint('🔔 Notification permission result: $notificationStatus');
      
      if (!mounted) return;
      
      // Show result feedback
      String message;
      Color backgroundColor;
      if (notificationStatus.isGranted) {
        message = 'Notifications enabled! 🔔';
        backgroundColor = Colors.green;
      } else {
        message = 'Notifications disabled. You can enable them later in settings.';
        backgroundColor = Colors.orange;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Mark that user has seen the intro screen and permissions were requested
      await PermissionsService.markPermissionIntroSeen();
      await PermissionsService.markPermissionsAsked();
      
      // Wait a moment for user to see the feedback, then navigate to login
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) return;
      
      // Navigate to login screen
      context.go('/login');
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting notification permission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _isRequesting ? null : () {
                    final navigator = GoRouter.of(context);
                    PermissionsService.markPermissionIntroSeen().then((_) {
                      if (mounted) {
                        navigator.go('/login');
                      }
                    });
                  },
                  child: const Text('Skip'),
                ),
              ),
            ),
            
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? costaRed : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  // Welcome page
                  _buildPage(
                    icon: Icons.info_outline,
                    title: 'Welcome to Costa Toolbox',
                    description: 'This app needs a few permissions to work properly. Let us explain why.',
                  ),
                  
                  // Storage permission page
                  _buildPage(
                    icon: Icons.folder_outlined,
                    title: 'External Storage Access',
                    description: 'We need access to external storage to transfer software to USB drives and save documents for offline use.\n\nTap "Grant Storage Access" to open the Android permission dialog.',
                  ),
                  
                  // Notifications permission page
                  _buildPage(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    description: 'We use notifications to alert you about new documents, software updates, and important maintenance reminders.\n\nTap "Grant Notifications" to open the Android permission dialog.',
                  ),
                ],
              ),
            ),
            
            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _isRequesting ? null : _goToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: costaRed,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isRequesting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_getButtonText()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (_currentPage) {
      case 0:
        return 'Next';
      case 1:
        return 'Grant Storage Access';
      case 2:
        return 'Grant Notifications';
      default:
        return 'Next';
    }
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            icon,
            size: 100,
            color: costaRed,
          ),
          const SizedBox(height: 32),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'CostaDisplayO',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'CostaTextO',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}