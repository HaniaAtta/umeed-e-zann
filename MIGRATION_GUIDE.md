# Clean Architecture Migration Guide

This guide explains how to migrate remaining modules to Clean Architecture, using the `marketplace` module as a reference implementation.

## Reference Implementation

The `features/marketplace/` module has been fully migrated to Clean Architecture and serves as a template for other modules.

## Migration Steps

### Step 1: Create Domain Layer

#### 1.1 Create Entities (`domain/entities/`)

Entities are pure Dart classes with no dependencies:

```dart
// Example: features/{module}/domain/entities/{entity}.dart
class EntityName {
  final String id;
  // ... other fields

  EntityName({
    required this.id,
    // ... other parameters
  });

  EntityName copyWith({...}) {
    // Implementation
  }
}
```

**Key Points:**
- No imports from Flutter, Firebase, or any external packages
- Pure business logic
- Immutable (use `copyWith` for modifications)

#### 1.2 Create Repository Interfaces (`domain/repositories/`)

Define abstract repository interfaces:

```dart
// Example: features/{module}/domain/repositories/{module}_repository.dart
abstract class ModuleRepository {
  Future<List<Entity>> getEntities();
  Future<Entity?> getEntityById(String id);
  Future<String> createEntity(Entity entity);
  // ... other methods
}
```

#### 1.3 Create Use Cases (`domain/usecases/`)

Each use case represents a single business operation:

```dart
// Example: features/{module}/domain/usecases/get_entities.dart
class GetEntities {
  final ModuleRepository repository;

  GetEntities(this.repository);

  Future<List<Entity>> execute({String? filter}) async {
    // Business logic validation
    if (filter != null && filter.isEmpty) {
      throw Exception('Filter cannot be empty');
    }
    return await repository.getEntities(filter: filter);
  }
}
```

**Key Points:**
- One use case = one business operation
- Contains validation and business logic
- Calls repository methods

### Step 2: Create Data Layer

#### 2.1 Create Models (`data/models/`)

Models extend entities and add serialization:

```dart
// Example: features/{module}/data/models/{entity}_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/{entity}.dart';

class EntityModel extends Entity {
  EntityModel({required super.id, ...});

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // ... other fields with proper conversion
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory EntityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EntityModel.fromJson({...data, 'id': doc.id});
  }

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['id'] as String,
      // ... map other fields
    );
  }

  // Conversion methods
  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(...);
  }

  Entity toEntity() {
    return Entity(...);
  }
}
```

#### 2.2 Create Data Sources (`data/datasources/`)

Data sources handle external data operations:

```dart
// Example: features/{module}/data/datasources/{module}_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/{entity}_model.dart';

abstract class ModuleRemoteDataSource {
  Future<List<EntityModel>> getEntities();
  // ... other methods
}

class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  final FirebaseFirestore firestore;

  ModuleRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<EntityModel>> getEntities() async {
    // Firebase implementation
  }
}
```

#### 2.3 Create Repository Implementation (`data/repositories/`)

Repository implementations bridge domain and data:

```dart
// Example: features/{module}/data/repositories/{module}_repository_impl.dart
import '../../domain/entities/{entity}.dart';
import '../../domain/repositories/{module}_repository.dart';
import '../datasources/{module}_remote_datasource.dart';
import '../models/{entity}_model.dart';

class ModuleRepositoryImpl implements ModuleRepository {
  final ModuleRemoteDataSource remoteDataSource;

  ModuleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Entity>> getEntities() async {
    final models = await remoteDataSource.getEntities();
    return models.map((model) => model.toEntity()).toList();
  }
}
```

### Step 3: Update Presentation Layer

#### 3.1 Update Provider (`presentation/providers/`)

Update providers to use use cases instead of services:

```dart
// Example: features/{module}/presentation/providers/{module}_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/repositories/{module}_repository.dart';
import '../../domain/usecases/get_entities.dart';
// ... other use case imports
import '../../data/datasources/{module}_remote_datasource.dart';
import '../../data/repositories/{module}_repository_impl.dart';

class ModuleProvider with ChangeNotifier {
  final ModuleRepository _repository;
  
  // Use cases
  late final GetEntities _getEntities;
  // ... other use cases

  ModuleProvider({ModuleRepository? repository})
      : _repository = repository ??
            ModuleRepositoryImpl(
              remoteDataSource: ModuleRemoteDataSourceImpl(),
            ) {
    _getEntities = GetEntities(_repository);
    // ... initialize other use cases
  }

  Future<void> loadEntities() async {
    _setLoading(true);
    try {
      _entities = await _getEntities.execute();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
}
```

#### 3.2 Update Screens

Update screens to use the new provider from `features/{module}/presentation/providers/`:

```dart
// Update imports
import 'package:provider/provider.dart';
import '../../features/{module}/presentation/providers/{module}_provider.dart';
import '../../features/{module}/domain/entities/{entity}.dart';

// Use Provider.of or Consumer
final provider = Provider.of<ModuleProvider>(context);
```

## Module-Specific Migration Notes

### Safety Module

- Entities: `SosAlert`, `TrustedContact`, `LiveTracking`, `FakeCall`
- Current service: `lib/data/services/safety_service.dart`
- Migrate to: `features/safety/`

### Growth Module

- Entities: `Course`, `CourseProgress`, `Bookmark`
- Current service: `lib/data/services/growth_service.dart`
- Current data: `lib/modules/growth/data/courses_data.dart`
- Migrate to: `features/growth/`

### Legal Module

- Entities: `LegalArticle`, `Document`, `Lawyer`, `NGO`, `SupportContact`
- Current service: `lib/data/services/legal_service.dart`
- Migrate to: `features/legal/`

### Community Module

- Entities: `Post`, `Comment`
- Current service: `lib/data/services/community_service.dart`
- Migrate to: `features/community/`

### Auth Module

- Entities: `User`
- Current service: `lib/data/services/auth_service.dart`
- Migrate to: `features/auth/`

## Testing Your Migration

After migrating a module:

1. **Check Imports**: Ensure no domain entities import Firebase/Flutter
2. **Run Tests**: `flutter test`
3. **Check Linter**: `flutter analyze`
4. **Test UI**: Run the app and test the module functionality
5. **Update main.dart**: Register new provider if needed

## Best Practices

1. **Start Small**: Migrate one module at a time
2. **Keep Old Code**: Don't delete old code until migration is complete and tested
3. **Update Imports Gradually**: Update imports as you migrate
4. **Document Changes**: Update this guide with module-specific notes
5. **Test Thoroughly**: Test each layer independently

## Common Pitfalls

1. **Circular Dependencies**: Domain should never depend on data/presentation
2. **Business Logic in Providers**: Move business logic to use cases
3. **Entity Dependencies**: Entities should have no external dependencies
4. **Direct Service Calls**: Use repository pattern, not direct service calls

## Questions?

Refer to:
- `features/wellness_hub/` - Original clean architecture example
- `features/marketplace/` - Complete migration example
- This guide for step-by-step instructions












