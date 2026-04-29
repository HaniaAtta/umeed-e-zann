# Clean Architecture Structure

## ✅ Folder Organization (Clean Architecture Compliant)

### Root Level (`lib/`)
- **`assets/`** - Static resources (images, fonts, icons, videos)
  - ✅ **Correct**: Resources stay at root level
  - Contains: `fonts/`, `IconKitchen-Output/`, `icons/`, `images/`, `videos/`

- **`contents/`** - App constants and configurations
  - ✅ **Correct**: Contains app-wide constants
  - Contains: `app_strings.dart`, `assets.dart`, `colors.dart`, `fonts.dart`, `textstyles.dart`

### Core Layer (`lib/core/`)
- **`core/extensions/`** - Extension methods
  - ✅ **Moved from**: `lib/extensions/`
  - Contains: `extensions.dart` (BuildContext extensions, responsive helpers)

- **`core/widgets/`** - Core reusable widgets
  - ✅ **Correct**: Core widgets used across the app
  - Contains: `custom_appbar.dart`, `custom_button.dart`, `custom_dialog.dart`, `custom_textfield.dart`, etc.

- **`core/widgets_shared/`** - Shared navigation widgets
  - ✅ **Moved from**: `lib/widgets/`
  - Contains: `side_drawer.dart`, `bottom_nav_bar.dart`

- **`core/services/`** - Core services
  - Contains: `user_service.dart`, `notification_service.dart`, etc.

- **`core/navigation/`** - Navigation configuration
- **`core/theme/`** - Theme configuration
- **`core/utils/`** - Utility functions
- **`core/constants/`** - Core constants
- **`core/error/`** - Error handling
- **`core/network/`** - Network configuration
- **`core/responsive/`** - Responsive utilities

### Shared Layer (`lib/shared/`)
- **`shared/widgets/`** - Shared widgets across features
  - ✅ **Correct**: Widgets used by multiple features
  - Contains: `banner_carousel.dart`, `custom_app_bar.dart`, `custom_search_bar.dart`, `empty_state.dart`, `gradient_button.dart`, `gradient_card.dart`

### Features Layer (`lib/features/`)
Each feature follows clean architecture:
```
features/
  {feature_name}/
    domain/
      entities/       # Pure Dart entities
      repositories/   # Repository interfaces
      usecases/       # Business logic
    data/
      datasources/    # Data sources (Firebase, API)
      models/         # Data models (DTOs)
      repositories/   # Repository implementations
    presentation/
      pages/          # UI screens
      viewmodels/     # State management (Providers)
      widgets/        # Feature-specific widgets
```

## ✅ Summary of Changes

1. **Extensions Folder**: Moved from `lib/extensions/` → `lib/core/extensions/`
   - All imports updated automatically

2. **Widgets Folder**: Moved from `lib/widgets/` → `lib/core/widgets_shared/`
   - Contains: `side_drawer.dart`, `bottom_nav_bar.dart`
   - All imports updated automatically

3. **Shared Folder**: ✅ Already in correct location
   - `lib/shared/widgets/` - Shared widgets across features

4. **Contents Folder**: ✅ Already in correct location
   - `lib/contents/` - App constants, colors, text styles

5. **Assets Folder**: ✅ Already in correct location
   - `lib/assets/` - Static resources

## ✅ Import Paths Updated

All import paths have been automatically updated:
- `../../../../extensions/extensions` → `../../../../core/extensions/extensions`
- `../../../../widgets/side_drawer` → `../../../../core/widgets_shared/side_drawer`
- `../../../../widgets/bottom_nav_bar` → `../../../../core/widgets_shared/bottom_nav_bar`

## ✅ Structure is Clean Architecture Compliant

The project now follows clean architecture principles:
- **Separation of Concerns**: Domain, Data, Presentation layers
- **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)
- **Core Layer**: Shared utilities, widgets, and services
- **Shared Layer**: Cross-feature widgets
- **Features Layer**: Self-contained feature modules
