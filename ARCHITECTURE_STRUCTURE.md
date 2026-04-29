# Clean Architecture Structure Guide

## 📁 Complete Folder Structure

```
lib/
├── core/
│   ├── error/                    # ✅ Custom exceptions and failure classes
│   │   ├── exceptions.dart       # AppException, ServerException, etc.
│   │   └── failures.dart         # Failure classes (ServerFailure, etc.)
│   │
│   ├── network/                  # ✅ Network connectivity checking utilities
│   │   └── network_info.dart     # NetworkInfo interface & implementation
│   │
│   ├── utils/                    # ✅ Common utilities, constants, and helpers
│   │   ├── constants.dart        # AppConstants (consolidated)
│   │   ├── helpers.dart          # Helper functions
│   │   ├── validators.dart       # Input validation utilities
│   │   └── responsive.dart       # Responsive utilities (consolidate duplicates)
│   │
│   ├── injections.dart           # ✅ Dependency injection setup (get_it)
│   │
│   ├── constants/                # (Can be removed - moved to utils/constants.dart)
│   ├── navigation/               # ✅ Navigation (app_router, route_paths)
│   ├── responsive/               # (Keep or merge with utils/responsive.dart)
│   ├── services/                 # Core services (UserService, NotificationService, etc.)
│   ├── theme/                    # App theming
│   └── widgets/                  # Shared widgets
│
├── features/
│   ├── <feature_name>/           # E.g., 'auth', 'marketplace', 'wellness_hub'
│   │   ├── data/
│   │   │   ├── models/           # ✅ Data models (DTOs - map to API/Firebase)
│   │   │   ├── repositories/     # ✅ Repository implementations (concrete classes)
│   │   │   └── datasources/      # ✅ Remote and local data sources
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/         # ✅ Pure business objects (framework-independent)
│   │   │   ├── repositories/     # ✅ Repository interfaces/abstract classes
│   │   │   └── usecases/         # ✅ Application-specific business logic
│   │   │
│   │   └── presentation/
│   │       ├── bloc/             # ⚠️ State management (BLoC pattern)
│   │       ├── viewmodels/       # ⚠️ State management (Provider/ChangeNotifier)
│   │       ├── providers/        # ⚠️ Current state management (can move to viewmodels/)
│   │       ├── pages/            # ✅ Full screen widgets
│   │       └── widgets/          # ✅ Reusable UI components
│
├── shared/                       # Shared widgets/components
└── contents/                     # App content (strings, colors, fonts)
```

## ✅ Completed Structure

### Core Layer ✓
- ✅ `core/error/` - Custom exceptions and failures
- ✅ `core/network/` - Network connectivity utilities
- ✅ `core/utils/` - Consolidated utilities and constants
- ✅ `core/injections.dart` - Dependency injection with get_it
- ✅ `core/navigation/` - Navigation configuration

### Features - Already Following Pattern ✓
- ✅ `features/marketplace/` - Complete (data, domain, presentation)
- ✅ `features/wellness_hub/` - Complete (data, domain, presentation)
- ⚠️ `features/community/` - Has presentation, needs data/domain
- ⚠️ `features/chat/` - Has presentation, needs data/domain
- ⚠️ `features/verification/` - Has presentation, needs data/domain

## 🔄 Reorganization Needed

### 1. Feature Data Layer Order

**Current** (varies by feature):
```
data/
├── datasources/
├── models/
└── repositories/
```

**Target** (as per your spec):
```
data/
├── models/          # Data models first
├── repositories/    # Repository implementations
└── datasources/     # Data sources last
```

**Note**: This is primarily for organizational consistency. Functionally, the order doesn't matter.

### 2. Presentation Layer - State Management

**Current**: Providers in `presentation/providers/`

**Options**:
- **Option A**: Move to `presentation/viewmodels/` (if using Provider/ChangeNotifier)
- **Option B**: Move to `presentation/bloc/` (if using BLoC pattern)
- **Option C**: Keep `presentation/providers/` (current approach)

**Recommendation**: Since you're using Provider, use `presentation/viewmodels/` or keep `providers/`.

### 3. Core Utils Consolidation

**Duplicate Files to Consolidate**:
- `core/utils/responsive.dart` vs `core/responsive/responsive.dart`
- `core/constants/app_constants.dart` → Merged into `core/utils/constants.dart` ✓

## 📝 Feature Migration Checklist

For each feature module:

### Data Layer
- [ ] `data/models/` - DTOs (Firebase/API models)
- [ ] `data/repositories/` - Repository implementations
- [ ] `data/datasources/` - Remote & local data sources

### Domain Layer
- [ ] `domain/entities/` - Pure Dart business objects
- [ ] `domain/repositories/` - Repository interfaces (abstract)
- [ ] `domain/usecases/` - Single-purpose business logic

### Presentation Layer
- [ ] `presentation/viewmodels/` or `presentation/providers/` - State management
- [ ] `presentation/pages/` - Screens
- [ ] `presentation/widgets/` - Feature-specific widgets

## 🎨 Icon Setup Location

### App Icon Files Location

**Current Configuration** (`pubspec.yaml`):
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web: true
  image_path: "assets/images/app_icon.png"
```

**Where to Place Icon**:
1. **Source Icon**: `assets/images/app_icon.png` (1024x1024px recommended)
   - This is the source file you create/upload

2. **Generated Icons** (auto-generated by `flutter_launcher_icons`):
   - **Android**: `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - **iOS**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
   - **Web**: `web/icons/`

**Steps**:
1. Visit https://icon.kitchen/
2. Upload your logo (`assets/images/logo.png`)
3. Download generated `app_icon.png`
4. Place at: `assets/images/app_icon.png`
5. Run: `flutter pub run flutter_launcher_icons`

### Icon Configuration Files

**Files that reference icons**:
- `pubspec.yaml` - Icon configuration
- `android/app/src/main/AndroidManifest.xml` - Android icon reference
- `ios/Runner/Info.plist` - iOS icon reference (auto-generated)
- `web/manifest.json` - Web icon references (auto-generated)

**No manual changes needed** - `flutter_launcher_icons` handles everything!

## 🔑 Key Principles

1. **Domain Layer** = Pure Dart (no Flutter, no Firebase)
   - Entities, Repository Interfaces, Use Cases

2. **Data Layer** = Implements Domain Interfaces
   - Models (DTOs), Repository Implementations, Data Sources

3. **Presentation Layer** = UI & State Management
   - ViewModels/Providers, Pages, Widgets

4. **Core Layer** = Shared Infrastructure
   - Error Handling, Network, Utils, Dependency Injection

## 📦 Dependencies Added

- ✅ `get_it: ^7.7.0` - Dependency injection
- ✅ `connectivity_plus: ^6.0.5` - Network connectivity checking
- ✅ `shared_preferences: ^2.3.2` - Local storage

## 🚀 Next Steps

1. ✅ Core structure created (error, network, injections)
2. ⏳ Consolidate duplicate utils/responsive files
3. ⏳ Migrate remaining modules to features/ (following pattern)
4. ⏳ Reorganize presentation state management (providers → viewmodels/)
5. ⏳ Reorder data layer folders (models, repositories, datasources)
6. ✅ Set up app icon (waiting for user to add icon file)

