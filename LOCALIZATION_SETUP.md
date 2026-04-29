# Localization Setup Guide

## Overview
This project now supports **6 languages**:
- English (en_US)
- Urdu (ur_PK)
- Punjabi (pa_PK)
- Turkish (tr_TR)
- Sindhi (sd_PK)
- Balochi (bal_PK)

## Setup Instructions

### 1. Install Dependencies
Run the following command to install localization dependencies:
```bash
flutter pub get
```

### 2. Generate Localization Files
After installing dependencies, generate the localization code:
```bash
flutter gen-l10n
```

This will create the generated localization files in `.dart_tool/flutter_gen/gen_l10n/`.

### 3. Verify Setup
- The ARB files are located in `lib/l10n/`
- The configuration file is `l10n.yaml` in the root directory
- Localization service is in `lib/core/services/locale_service.dart`

## How to Use

### Changing Language
1. Open the side drawer (hamburger menu)
2. Tap on "Language"
3. Select your preferred language
4. The app will immediately switch to the selected language

### Using Localized Strings in Code
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In your widget:
final l10n = AppLocalizations.of(context);
Text(l10n?.home ?? 'Home');
```

### Adding New Translations
1. Edit the ARB files in `lib/l10n/`
2. Add your new key-value pairs to `app_en.arb` (template)
3. Add translations to all other language files
4. Run `flutter gen-l10n` to regenerate
5. Use the new keys in your code

## RTL Support
The app automatically supports Right-to-Left (RTL) languages:
- Urdu
- Sindhi
- Balochi

Flutter will automatically flip the UI layout for these languages.

## Responsive Design
All UI components are responsive and work correctly with:
- Different screen sizes (mobile, tablet, desktop)
- RTL languages
- Different text lengths in various languages

## Files Created/Modified

### New Files:
- `lib/l10n/app_en.arb` - English translations
- `lib/l10n/app_ur.arb` - Urdu translations
- `lib/l10n/app_pa.arb` - Punjabi translations
- `lib/l10n/app_tr.arb` - Turkish translations
- `lib/l10n/app_sd.arb` - Sindhi translations
- `lib/l10n/app_bal.arb` - Balochi translations
- `lib/core/services/locale_service.dart` - Language switching service
- `lib/core/widgets/language_selector.dart` - Language selection UI
- `l10n.yaml` - Localization configuration

### Modified Files:
- `pubspec.yaml` - Added localization dependencies
- `lib/main.dart` - Added localization delegates and locale support
- `lib/core/widgets_shared/side_drawer.dart` - Added language selector option
- `lib/features/home/presentation/pages/home_screen.dart` - Updated to use localized strings

## Testing
1. Run `flutter gen-l10n` to generate localization files
2. Run the app: `flutter run`
3. Open the side drawer and select "Language"
4. Try switching between different languages
5. Verify that:
   - Text changes to the selected language
   - RTL languages display correctly
   - UI remains responsive
   - All strings are properly translated

## Notes
- The app remembers your language preference using SharedPreferences
- Language preference persists across app restarts
- If a translation is missing, the English fallback is used
- All UI components are responsive and work with RTL languages

