# Repository Guidelines

## Project Structure & Module Organization
Main Flutter code lives in `lib/`, organized by feature folders combining GetX controllers, views, and data services; `lib/main.dart` wires routing and dependency setup. Shared images, fonts, and JSON live under `assets/` and must be declared in `pubspec.yaml`. Platform integrations remain inside `android/`, `ios/`, `macos/`, `windows/`, `linux/`, and `web/`, while generated build outputs stay in `build/`. Keep tests mirrored in `test/feature/...` with one `*_test.dart` per widget or service.

## Build, Test, and Development Commands
```bash
flutter pub get             # sync dependencies declared in pubspec.yaml
flutter run -d chrome       # run the app locally; swap chrome with any device id
flutter analyze             # static analysis using flutter_lints rules
flutter test --coverage     # execute unit/widget suites and emit coverage data
flutter build apk --release # create a production Android artifact
```
Run `flutter clean` when changing Flutter channels or large dependency updates.

## Coding Style & Naming Conventions
The analyzer is configured through `analysis_options.yaml` to use `package:flutter_lints`. Use two-space indentation, prefer `const` constructors, and embrace Dart null safety (`?`, `late`, `required`) deliberately. Classes and enums use UpperCamelCase, methods and fields use lowerCamelCase, while file names (including tests) stay snake_case. GetX controllers should follow the `FeatureController` suffix, and any reusable UI lives in `lib/widgets/`. Run `dart format .` plus `flutter analyze` before opening a pull request.

## Testing Guidelines
Tests rely on `package:flutter_test` and mirror the `lib/` hierarchy. Name specs `{feature}_test.dart` or `{widget}_test.dart`, use `testWidgets` for UI, and isolate Appwrite or network calls behind abstractions so they can be faked with in-memory adapters. Aim for at least 80 percent coverage on new code paths and always include a regression test for bug fixes. CI expectations are `flutter analyze` followed by `flutter test --coverage`.

## Commit & Pull Request Guidelines
No shared Git history ships with this template, so adopt Conventional Commit prefixes such as `feat:`, `fix:`, or `chore:` with imperative subjects under 72 characters and optional detail in the body. Reference task ids (for example `CW-123`) in the footer when applicable. Open pull requests with a clear summary, checklist of validations (`flutter pub get`, `flutter analyze`, `flutter test`), and screenshots or screen recordings for UI work. Request reviewers for every platform you touched and wait for green checks before merging.

## Configuration & Secrets
The Appwrite SDK and any future service keys belong in secure runtime configuration (platform keychains, CI secrets, or runtime environment variables), never in tracked Dart files. Document required configuration variables in the pull request description and update `pubspec.yaml` whenever assets or fonts change so teammates can rerun `flutter pub get`.
