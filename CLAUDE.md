# Costa Filter Checker - Flutter App Guidelines

## Build Commands
- Install dependencies: `flutter pub get`
- Run app: `flutter run`
- Run linter: `flutter analyze`
- Run tests: `flutter test`
- Run specific test: `flutter test test/path_to_test.dart`
- Build release: `flutter build apk` (Android) or `flutter build ios` (iOS)

## Code Style
- Follow Flutter's official style guide
- Use named parameters for widgets and functions
- Organize imports alphabetically (Dart imports first, package imports second, local imports last)
- Use camelCase for variables/methods, PascalCase for classes/widgets
- Wrap widgets with const when possible for performance
- Extract reusable widgets into separate files in the widgets/ directory
- Keep UI and business logic separate (screens vs services)
- Use async/await pattern for asynchronous operations
- Include descriptive comments for complex logic
- Error handling: use try/catch for operations that may fail
- Reference issue numbers where applicable
- Include brief explanations of why changes were made when relevant

### Code Documentation
- Keep a Changelog using https://keepachangelog.com/en/1.1.0/ style CHANGELOG.md