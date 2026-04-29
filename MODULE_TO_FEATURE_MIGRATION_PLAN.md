# Module to Feature Migration Plan

## Target Structure for Each Feature

```
features/<feature_name>/
├── data/
│   ├── models/              # Data Transfer Objects (DTOs)
│   ├── repositories/        # Repository implementations
│   └── datasources/         # Remote & Local data sources
├── domain/
│   ├── entities/            # Pure business objects
│   ├── repositories/        # Repository interfaces (abstract)
│   └── usecases/            # Business logic
└── presentation/
    ├── viewmodels/          # State management (Provider/ChangeNotifier)
    ├── pages/               # Screens
    └── widgets/             # Feature widgets
```

## Modules to Migrate

### 1. Auth Module
**Current**: `modules/auth/`
**Target**: `features/auth/`

**Files to Move**:
- `modules/auth/screens/` → `features/auth/presentation/pages/`
- `modules/auth/widgets/` → `features/auth/presentation/widgets/`

**Need to Create**:
- Domain: entities, repositories, usecases
- Data: models, repositories, datasources
- Presentation: viewmodels (auth_provider)

**Existing Service**: `data/services/auth_service.dart` → Move to `features/auth/data/datasources/`

### 2. Home Module
**Current**: `modules/home/`
**Target**: `features/home/`

**Files to Move**:
- `modules/home/screens/` → `features/home/presentation/pages/`
- `modules/home/widgets/` → `features/home/presentation/widgets/`

**Need to Create**:
- Domain layer
- Data layer
- Presentation: viewmodels

### 3. Profile Module
**Current**: `modules/profile/`
**Target**: `features/profile/`

**Files to Move**:
- `modules/profile/screens/` → `features/profile/presentation/pages/`
- `modules/profile/widgets/` → `features/profile/presentation/widgets/`

**Need to Create**:
- Domain layer
- Data layer
- Presentation: viewmodels

### 4. Growth Module
**Current**: `modules/growth/`
**Target**: `features/growth/`

**Files to Move**:
- `modules/growth/screens/` → `features/growth/presentation/pages/`
- `modules/growth/widgets/` → `features/growth/presentation/widgets/`
- `modules/growth/data/` → `features/growth/data/models/` (convert)
- `modules/growth/providers/` → `features/growth/presentation/viewmodels/`

**Existing Service**: `data/services/growth_service.dart` → Move to `features/growth/data/datasources/`

**Need to Create**:
- Domain layer (entities, repositories, usecases)
- Data: repositories, datasources

### 5. Legal Module
**Current**: `modules/legal/`
**Target**: `features/legal/`

**Files to Move**:
- `modules/legal/screens/` → `features/legal/presentation/pages/`
- `modules/legal/widgets/` → `features/legal/presentation/widgets/`
- `modules/legal/providers/` → `features/legal/presentation/viewmodels/`

**Existing Service**: `data/services/legal_service.dart` → Move to `features/legal/data/datasources/`

**Need to Create**:
- Domain layer
- Data: models, repositories, datasources

### 6. Safety Module
**Current**: `modules/safety/`
**Target**: `features/safety/`

**Files to Move**:
- `modules/safety/screens/` → `features/safety/presentation/pages/`
- `modules/safety/widgets/` → `features/safety/presentation/widgets/`
- `modules/safety/providers/` → `features/safety/presentation/viewmodels/`

**Existing Service**: `data/services/safety_service.dart` → Move to `features/safety/data/datasources/`

**Need to Create**:
- Domain layer
- Data: models, repositories, datasources

### 7. Wellness Module
**Current**: `modules/wellness/`
**Target**: Merge into `features/wellness_hub/` (already exists)

**Files to Move**:
- `modules/wellness/screens/` → `features/wellness_hub/presentation/pages/`
- `modules/wellness/widgets/` → `features/wellness_hub/presentation/widgets/`

**Note**: `features/wellness_hub/` already has clean architecture structure

## Migration Steps

1. Create feature folder structure
2. Move files to presentation layer first
3. Create domain layer (entities, repositories, usecases)
4. Move/create data layer (models, repositories, datasources)
5. Create viewmodels in presentation
6. Update all imports
7. Update app_router.dart
8. Update main.dart providers
9. Test the feature
10. Delete old module folder

