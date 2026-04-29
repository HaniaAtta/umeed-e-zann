import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';
import 'package:umeed_e_zann/l10n/regional_delegates.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'features/safety/presentation/viewmodels/safety_provider.dart';
import 'features/growth/presentation/viewmodels/growth_provider.dart';
import 'features/legal/presentation/viewmodels/legal_provider.dart';
import 'features/marketplace/presentation/providers/marketplace_provider.dart';
import 'features/wellness_hub/presentation/providers/cycle_tracker_provider.dart';
import 'features/wellness_hub/presentation/providers/family_planning_provider.dart';
import 'features/wellness_hub/presentation/providers/maternity_wing_provider.dart';
import 'features/wellness_hub/presentation/providers/telehealth_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'core/services/user_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'core/services/locale_service.dart';
import 'core/injections.dart';
import 'features/auth/presentation/viewmodels/auth_provider.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/community/presentation/providers/community_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferencesService.init();

  // Initialize Dependency Injection
  await setupInjections();

  // 2️⃣ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        
        // Auth provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            ),
          ),
        ),
        
        // Module providers
        ChangeNotifierProvider(create: (_) => SafetyProvider()),
        ChangeNotifierProvider(create: (_) => GrowthProvider()),
        ChangeNotifierProvider(create: (_) => LegalProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            ChatRepositoryImpl(
              remoteDataSource: ChatRemoteDataSourceImpl(
                firestore: FirebaseFirestore.instance,
                auth: firebase_auth.FirebaseAuth.instance,
              ),
              auth: firebase_auth.FirebaseAuth.instance,
            ),
          ),
        ),
        
        // Wellness providers
        ChangeNotifierProvider(create: (_) => CycleTrackerProvider()),
        ChangeNotifierProvider(create: (_) => FamilyPlanningProvider()),
        ChangeNotifierProvider(create: (_) => MaternityWingProvider()),
        ChangeNotifierProvider(create: (_) => TeleHealthProvider()),
        
        // Community provider
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ],
      child: Consumer<LocaleService>(
        builder: (context, localeService, _) {
          return MaterialApp(
            title: 'امید زن',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            locale: localeService.locale,
            supportedLocales: LocaleService.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              RegionalMaterialLocalizationsDelegate(),
              RegionalCupertinoLocalizationsDelegate(),
            ],
            navigatorKey: AppRouter.navigatorKey,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
