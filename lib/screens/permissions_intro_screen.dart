// lib/screens/permissions_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    if (!mounted) return;
    
    setState(() {
      _isRequesting = true;
    });

    try {
      // Request permissions
      await PermissionsService.requestPermissions();
      
      // Mark that user has seen the intro screen
      await PermissionsService.markPermissionIntroSeen();
      
      if (!mounted) return;
      
      // Navigate to login screen
      context.go('/login');
    } catch (e) {
      if (!mounted) return;
      
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting permissions: $e'),
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
                    description: 'We need access to external storage to transfer software to USB drives and save documents for offline use.',
                  ),
                  
                  // Notifications permission page
                  _buildPage(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    description: 'We use notifications to alert you about new documents, software updates, and important maintenance reminders.',
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
                    : Text(_currentPage < 2 ? 'Next' : 'Grant Permissions'),
              ),
            ),
          ],
        ),
      ),
    );
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