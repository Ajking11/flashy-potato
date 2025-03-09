# Changelog
All notable changes to the Costa FSE Toolbox project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Document Repository feature with searchable technical documents
- Category filtering for documents
- PDF document viewer with paging support
- Offline document access with download capability
- Machine-specific document filtering
- Implemented machine detail screens with comprehensive information
- Added technical specifications tab for machine details
- Created maintenance procedures tab with step-by-step instructions
- Implemented troubleshooting guides with prioritized solutions
- Added parts diagrams tab with interactive parts list
- Created data models for machine details and related information
- Implemented tab navigation within machine detail screen
- Enhanced mock data for troubleshooting guides with real-world coffee machine issues
- Added comprehensive mock parts diagrams for machine components
- Integrated actual part numbers and descriptions for grinder assembly components
- Added login screen that appears after splash screen, mimicking machine technician access with password protection
- Implemented session management to require login each time the app starts

### Fixed
- Removed unused `_isRunningOnEmulator` and `_getDeviceBrand` methods in document_viewer_screen.dart
- Eliminated dead code in `_loadDocument` method in document_viewer_screen.dart
- Removed unnecessary 'this.' qualifier in machine.dart
- Removed unnecessary `toList()` call in spread operator in document_repository_screen.dart
- Fixed RangeError in parts_diagram_tab.dart when diagrams list is empty
- Fixed potential Flutter error in SplashScreen by adding mounted check before navigation
- Fixed missing implementation of State.build method in main.dart
- Fixed syntax errors and missing brackets in main.dart

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