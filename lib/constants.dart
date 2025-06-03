import 'package:flutter/material.dart';

// Costa color palette - unified from both apps
const Color accentRed = Color.fromARGB(255, 252, 37, 47); // #FC252F
const Color deepRed = Color.fromARGB(255, 66, 0, 30);    // #42001E
const Color costaRed = Color(0xff6b1831);                // #6B1831
const Color italianPorcelain = Color.fromARGB(255, 255, 251, 245); // #FFFBF5
const Color latte = Color.fromARGB(255, 242, 226, 218);  // #F2E2DA

// App version (accessible throughout the app)
const String appVersion = "0.5.270";

// TYPOGRAPHY SYSTEM
// Based on Costa Coffee Brand Guidelines
// Using full range of Costa fonts

class CostaTextStyle {
  // Impact headline using Costa Display Wave (for large, impactful one-word headlines)
  static const TextStyle impactHeadline = TextStyle(
    fontFamily: 'CostaDisplayWaveO',
    fontWeight: FontWeight.bold,
    fontSize: 36.0,
    letterSpacing: 0.25,
    color: deepRed,
    height: 1.1,
  );

  // Primary headline style (for major headlines)
  static const TextStyle headline1 = TextStyle(
    fontFamily: 'CostaDisplayO',
    fontWeight: FontWeight.bold,
    fontSize: 32.0,
    letterSpacing: 0.25,
    color: deepRed,
    height: 1.2,
  );

  // Secondary headline style (for section headers)
  static const TextStyle headline2 = TextStyle(
    fontFamily: 'CostaDisplayO',
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    letterSpacing: 0.15,
    color: deepRed,
    height: 1.3,
  );

  // AppBar title style
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'CostaDisplayO',
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: Colors.white,
    letterSpacing: 0.15,
  );

  // Sub-heading - Costa Display Regular/Bold
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: 'CostaDisplayO',
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: deepRed,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Smaller sub-heading
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: 'CostaDisplayO',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: deepRed,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // Body text - Costa Text Light
  static const TextStyle bodyText1 = TextStyle(
    fontFamily: 'CostaTextO',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: Colors.black87,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Smaller body text
  static const TextStyle bodyText2 = TextStyle(
    fontFamily: 'CostaTextO',
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: Colors.black87,
    letterSpacing: 0.25,
    height: 1.5,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: 'CostaTextO',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    letterSpacing: 1.0,
    height: 1.5,
  );

  // Caption text
  static const TextStyle caption = TextStyle(
    fontFamily: 'CostaTextO',
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: Colors.black54,
    letterSpacing: 0.4,
    height: 1.4,
  );

  // Special elements (for highlighted info)
  static const TextStyle special = TextStyle(
    fontFamily: 'CostaDisplayO',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: accentRed,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // Light variant for body text
  static const TextStyle bodyTextLight = TextStyle(
    fontFamily: 'CostaTextO',
    fontWeight: FontWeight.w300, // Light weight
    fontSize: 16.0,
    color: Colors.black87,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Wave regular for decorative elements
  static const TextStyle decorative = TextStyle(
    fontFamily: 'CostaDisplayWaveO',
    fontWeight: FontWeight.normal,
    fontSize: 18.0,
    color: costaRed,
    letterSpacing: 0.5,
    height: 1.3,
  );
}

// Button styles with integrated typography
ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: costaRed,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: CostaTextStyle.button,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
);

ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: costaRed,
  side: const BorderSide(color: costaRed),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: CostaTextStyle.button,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
);

// Card and container decorations
BoxDecoration cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ],
);