# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Costa FSE Toolbox - Flutter App Guidelines

## Build Commands
- Install dependencies: `flutter pub get`
- Generate Riverpod code: `flutter pub run build_runner build --delete-conflicting-outputs`
- Run app: `flutter run`
- Run linter: `flutter analyze`
- Run tests: `flutter test`
- Run specific test: `flutter test test/path_to_test.dart`
- Build release: `flutter build apk` (Android) or `flutter build ios` (iOS)

## Code Style
- Follow Flutter's official style guide and linter rules in analysis_options.yaml
- Use named parameters for widgets and functions
- Organize imports: Dart imports first, package imports second, local imports last
- Use camelCase for variables/methods, PascalCase for classes/widgets
- Wrap widgets with const when possible for performance
- Keep UI and business logic separate (screens vs services)
- Use Riverpod patterns with states, notifiers, and providers
- Error handling: use try/catch for operations that may fail
- Ensure type safety - avoid dynamic types when possible
- Include descriptive comments for complex logic
- Reference issue numbers where applicable

### Project Structure
- Place screens in lib/screens/, widgets in lib/widgets/, models in lib/models/
- Store Riverpod code in lib/riverpod/ (states, notifiers, providers)