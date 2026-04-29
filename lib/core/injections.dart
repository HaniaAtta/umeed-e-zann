import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupInjections() async {
  // External dependencies
  getIt.registerLazySingleton(() => Connectivity());
  
  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // Auth
  getIt.registerLazySingleton(() => AuthRemoteDataSourceImpl());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetInjections() async {
  await getIt.reset();
}

