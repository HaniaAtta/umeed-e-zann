# Package Installation Required

## Issue
The `sensors_plus` package has been added to `pubspec.yaml` but needs to be installed.

## Solution
Run the following command in your terminal:

```bash
flutter pub get
```

This will install the `sensors_plus` package and resolve the import errors.

## After Installation
Once `flutter pub get` completes successfully:
- The `sensors_plus` import errors will be resolved
- Shake detection will work properly
- All accelerometer-related code will function correctly

## Note
If you're using an IDE (VS Code, Android Studio), you may need to:
1. Run `flutter pub get` in the terminal
2. Restart the IDE or Dart Analysis Server
3. Hot restart your app (not just hot reload)

