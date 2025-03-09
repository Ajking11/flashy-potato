import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../navigation/app_navigator.dart';
import '../constants.dart';
import '../services/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordIncorrect = false;
  bool _isLoading = false;
  bool _isUnlocked = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // Store the SHA-256 hash of "costa_coffee_techy"
  final String _hashedPassword = "58f92f9e3bbdd06d88a85ec7a09b8e88a17e1f63b0d42917f8006119c0259d6a";

  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Create the slide animation
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Add listener to navigate after animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to app after animation completes
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AppNavigator()),
          );
        }
      }
    });
  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _hashPassword(String password) {
    // Add a salt prefix to the password
    final saltedPassword = "costa_coffee_$password";
    
    // Convert the salted password to bytes
    final bytes = utf8.encode(saltedPassword);
    
    // Generate the SHA-256 hash
    final digest = sha256.convert(bytes);
    
    // Return the hash as a hexadecimal string
    return digest.toString();
  }

  void _validatePassword() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      
      // Hash the user input and compare with stored hash
      final inputHash = _hashPassword(_passwordController.text);
      
      if (inputHash == _hashedPassword) {
        // Set logged in status
        SessionManager.setLoggedIn();
        
        // Trigger unlock animation
        setState(() {
          _isLoading = false;
          _isUnlocked = true;
        });
        
        // Start the slide animation after unlocking
        _animationController.forward();
      } else {
        // Password incorrect - show error
        setState(() {
          _isPasswordIncorrect = true;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Use the same gradient as SplashScreen for consistency
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lock Icon with Animation
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value * 500),
                        child: Container(
                          padding: const EdgeInsets.all(24),
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
                          child: Icon(
                            _isUnlocked ? Icons.lock_open : Icons.lock_outline,
                            size: 80,
                            color: costaRed,
                          ),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 40),
                  
                  // Login card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title text
                        const Text(
                          'FSE TOOLBOX',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CostaDisplayO',
                            color: deepRed,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Password message
                        const Text(
                          'A technician\'s key is present',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'CostaTextO',
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'Please enter the password:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'CostaTextO',
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          enabled: !_isUnlocked,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            errorText: _isPasswordIncorrect 
                                ? 'Incorrect password' 
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, 
                              vertical: 16,
                            ),
                          ),
                          onSubmitted: _isUnlocked ? null : (_) => _validatePassword(),
                        ),
                        const SizedBox(height: 24),
                        
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_isLoading || _isUnlocked) ? null : _validatePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: costaRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: _isUnlocked ? Colors.green : Colors.grey,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isUnlocked ? 'Authenticated' : 'Login',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}