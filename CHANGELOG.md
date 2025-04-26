# Changelog
All notable changes to the Costa FSE Toolbox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Firebase integration for backend services
- User authentication system with Firebase Auth
- Cloud Firestore database for storing app data
- Firebase Cloud Storage for document files
- User preferences system with persistent storage
- Dark/light theme toggle option
- Favorite machines and filters functionality
- Custom dashboard with updates and favorites
- Document update notifications
- Important information notices for engineers
- Quick links to frequently used features
- Settings screen for preferences management
- Last update check tracking
- Download count and management from dashboard
- Migrated from Provider to Riverpod 2.6.1 for improved state management
- Added code generation support with riverpod_generator
- Implemented proper separation of state, notifiers, and providers with Riverpod
- Storage Access Framework implementation for USB file transfers
- Enhanced SAF implementation with fallback for older Android versions
- Advanced permission handling based on device Android version
- Progressive enhancement approach for optimal compatibility
- Intelligent path detection for USB drives
- Hybrid file transfer strategy (SAF or direct based on context)
- User-friendly error messages and recovery options
- File picker for selecting storage locations with SAF
- Permission handling for storage access
- Flutter file dialog for saving files using system APIs
- Interactive permissions intro screen with educational content
- Automatic permission request flow before login
- Firebase Cloud Messaging for push notifications
- Notification service with topic-based subscriptions
- Document and software update notifications
- User-configurable notification preferences
- Image caching system for network images to reduce data usage and improve performance

### Changed
- Updated USB Transfer wizard UI to focus on storage selection instead of detection
- Changed file transfer flow to use SAF APIs for improved Android 10+ compatibility
- Updated UI language to be more inclusive of different storage types
- Improved error handling during file transfer process

### Security
- Implemented secure password hashing with SHA-256 and salt for login system

### Fixed
- Removed unused `_isRunningOnEmulator` and `_getDeviceBrand` methods in document_viewer_screen.dart
- Eliminated dead code in `_loadDocument` method in document_viewer_screen.dart
- Removed unnecessary 'this.' qualifier in machine.dart
- Addressed compatibility issues with Android 10+ scoped storage restrictions
- Fixed potential permission issues when accessing external storage
- Improved file transfer reliability with better error handling
- Removed unnecessary `toList()` call in spread operator in document_repository_screen.dart
- Fixed RangeError in parts_diagram_tab.dart when diagrams list is empty
- Fixed potential Flutter error in SplashScreen by adding mounted check before navigation
- Fixed missing implementation of State.build method in main.dart
- Fixed syntax errors and missing brackets in main.dart
- Fixed BuildContext usage across async gaps in document_repository_screen.dart and permissions_intro_screen.dart
- Applied automated fixes with `dart fix --apply` to update code style
- Improved document and software download animation smoothness with throttled progress updates
- Enhanced download button UI transitions using AnimatedSwitcher for smoother state changes
- Added animated transitions between download states in software download UI
- Fixed Riverpod reference issues in software detail screen
- Fixed unused variable warnings to improve code quality

## [1.0.1] - 2025-03-08
### Added
- Integrated Machine Information functionality with existing Filter Checker
- Created unified navigation system with bottom tab bar
- Added splash screen with Costa branding
- Implemented machine list screen with Costa styling
- Added animated transitions between screens
- Created shared styling constants for consistent UI
- Implemented Provider-based state management across all features
- Added shimmer loading effects for better user experience
- Implemented complete Costa typography system using all font families

### Changed
- Updated folder structure to accommodate both feature sets
- Unified color schemes and component styling across the app
- Redesigned result card UI to consolidate water test results and filter specifications
- Repositioned the "New Search" button to be alongside the "Show More Details" button
- Refactored navigation to use a bottom tab bar
- Modified all screens to use a consistent design language
- Improved error handling with more specific error messages
- Unified help system across all features

### Fixed
- Resolved all deprecation warnings by replacing `withOpacity()` with `withValues(alpha:)`
- Fixed overflow issues in UI components
- Eliminated unused imports in test files
- Improved responsiveness for different screen sizes

## [1.0.0] - 2025-03-01
### Added
- Initial release of the Costa Filter Checker app
- Filter recommendation system based on water parameters (temporary hardness, total hardness, and cups per day)
- JSON-based filter database with support for Fresh, Standard, and Finest filter types
- Responsive UI for both mobile and tablet/desktop layouts
- Detailed filter information with capacity visualization
- Expandable filter details showing installation instructions and benefits
- Help tooltips for explaining water parameter inputs

### Changed
- Redesigned the result card layout to use the full width for the filter capacity section
- Moved capacity visualization out of the two-column layout to improve readability and prevent overflow issues
- Made the filter capacity section stretch across the full width of the card to provide more space for the progress indicator
- Adjusted the spacing between elements for better visual hierarchy

### Fixed
- Fixed overflow issue in the filter capacity visualization on smaller screens
- Eliminated wasted space in the UI to make better use of available screen real estate
- Improved responsiveness for different screen sizes

[Unreleased]: https://github.com/yourusername/costa_fse_toolbox/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/yourusername/costa_fse_toolbox/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/yourusername/costa_fse_toolbox/releases/tag/v1.0.0