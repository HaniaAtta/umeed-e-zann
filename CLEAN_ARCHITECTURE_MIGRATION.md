# Clean Architecture Migration Plan

## Current Structure

- `lib/modules/` - Mixed structure (screens, widgets, providers, data)
- `lib/data/services/` - Service layer (direct Firebase access)
- `lib/data/models/` - Data models
- `lib/features/wellness_hub/` - ✅ Already follows Clean Architecture

## Target Structure (Clean Architecture)

Each feature/module should follow this structure:

```
lib/features/{feature_name}/
├── domain/
│   ├── entities/          # Business objects (pure Dart, no dependencies)
│   ├── repositories/      # Abstract repository interfaces
│   ├── usecases/          # Business logic (single responsibility)
│   └── services/          # Domain services (if needed)
├── data/
│   ├── models/            # Data Transfer Objects (DTOs) with serialization
│   ├── datasources/       # Remote/Local data sources (Firebase, API, etc.)
│   └── repositories/      # Repository implementations
└── presentation/
    ├── providers/         # State management (Provider, BLoC, etc.)
    ├── screens/           # UI screens
    └── widgets/           # UI widgets
```

## Migration Strategy

1. **Keep wellness_hub** - Already follows clean architecture ✅
2. **Migrate modules to features/** - Move and restructure
3. **Separate concerns** - Domain logic independent of data/presentation
4. **Create use cases** - Extract business logic from services

## Module Migration Status

- ✅ `features/wellness_hub/` - Complete
- ✅ `features/marketplace/` - Complete (Domain, Data, Presentation layers)
- ⏳ `features/safety/` - Pending (use marketplace as reference)
- ⏳ `features/growth/` - Pending
- ⏳ `features/legal/` - Pending
- ⏳ `features/community/` - Pending
- ⏳ `features/auth/` - Pending
- ⏳ `features/profile/` - Pending
- ⏳ `features/home/` - Pending

## Principles

1. **Domain Layer**: Pure Dart, no Flutter/Firebase dependencies
2. **Data Layer**: Handles all external dependencies (Firebase, API)
3. **Presentation Layer**: UI only, delegates to domain layer via use cases
4. **Dependency Rule**: Outer layers depend on inner layers, never reverse












