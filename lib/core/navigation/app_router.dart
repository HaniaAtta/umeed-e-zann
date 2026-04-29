import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/settings_screen.dart';
import '../../features/home/presentation/pages/notifications_screen.dart';
import '../../features/legal/presentation/pages/legal_home.dart';
import '../../features/legal/presentation/pages/legal_detail_screen.dart';
import '../../features/legal/presentation/pages/ai_assistant_screen.dart';
import '../../features/legal/presentation/pages/voice_assistant_screen.dart';
import '../../features/legal/presentation/pages/helpline_screen.dart';
import '../../features/legal/presentation/pages/support_contacts_screen.dart';
import '../../features/legal/presentation/pages/document_vault_screen.dart';
import '../../features/community/presentation/pages/forum_home_page.dart';
import '../../features/marketplace/presentation/pages/create_listing_page.dart';
import '../../features/marketplace/presentation/pages/product_details_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_screen_page.dart';
import '../../features/chat/domain/entities/chat_thread.dart';
import '../../features/community/presentation/pages/create_post_page.dart';
import '../../features/community/presentation/pages/post_details_page.dart';
import '../../app.dart';
import 'route_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const String splash = RoutePaths.splash;
  static const String onboarding = RoutePaths.onboarding;
  static const String login = RoutePaths.login;
  static const String signup = RoutePaths.signup;
  static const String home = RoutePaths.home;
  static const String safety = RoutePaths.safety;
  static const String wellness = RoutePaths.wellness;
  static const String growth = RoutePaths.growth;
  static const String marketplace = RoutePaths.marketplace;
  static const String legal = RoutePaths.legal;
  static const String community = RoutePaths.community;
  static const String profile = RoutePaths.profile;
  static const String settings = RoutePaths.settings;
  static const String notifications = RoutePaths.notifications;

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;

    if (routeName == splash) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    } else if (routeName == onboarding) {
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    } else if (routeName == login) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    } else if (routeName == signup) {
      return MaterialPageRoute(builder: (_) => const SignupScreen());
    } else if (routeName == home) {
      return MaterialPageRoute(
        builder: (_) => const App(initialIndex: 0),
      );
    } else if (routeName == safety) {
      return MaterialPageRoute(
        builder: (_) => const App(initialIndex: 1),
      );
    } else if (routeName == wellness) {
      return MaterialPageRoute(
        builder: (_) => const App(initialIndex: 2),
      );
    } else if (routeName == growth) {
      return MaterialPageRoute(
        builder: (_) => const App(initialIndex: 3),
      );
    } else if (routeName == legal) {
      return MaterialPageRoute(
        builder: (_) => const App(initialIndex: 4),
      );
    } else if (routeName == marketplace) {
      return MaterialPageRoute(
        builder: (_) => const App(initialIndex: 5),
      );
    } else if (routeName == community) {
      return MaterialPageRoute(
        builder: (_) => const ForumHomePage(),
      );
    } else if (routeName == profile) {
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    } else if (routeName == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    } else if (routeName == notifications) {
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());
    } else if (routeName == RoutePaths.legalDetail) {
      final category = routeSettings.arguments as String? ?? 'Legal Rights';
      return MaterialPageRoute(
        builder: (_) => LegalDetailScreen(categoryTitle: category),
      );
    } else if (routeName == RoutePaths.legalCategories) {
      return MaterialPageRoute(
        builder: (_) => const LegalCategoriesScreen(),
      );
    } else if (routeName == RoutePaths.aiAssistant) {
      return MaterialPageRoute(
        builder: (_) => const AIAssistantScreen(),
      );
    } else if (routeName == RoutePaths.voiceAssistant) {
      return MaterialPageRoute(
        builder: (_) => const VoiceAssistantScreen(),
      );
    } else if (routeName == RoutePaths.helpline) {
      return MaterialPageRoute(
        builder: (_) => const HelplineScreen(),
      );
    } else if (routeName == RoutePaths.supportContacts) {
      return MaterialPageRoute(
        builder: (_) => const SupportContactsScreen(),
      );
    } else if (routeName == RoutePaths.documentVault) {
      return MaterialPageRoute(
        builder: (_) => const DocumentVaultScreen(),
      );
    } else if (routeName == RoutePaths.createListing) {
      return MaterialPageRoute(
        builder: (_) => const CreateListingPage(),
      );
    } else if (routeName == RoutePaths.productDetails) {
      final product = routeSettings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => ProductDetailsPage(product: product ?? {}),
      );
    } else if (routeName == RoutePaths.chatList) {
      return MaterialPageRoute(
        builder: (_) => const ChatListPage(),
      );
    } else if (routeName == RoutePaths.chatScreen) {
      final chat = routeSettings.arguments as ChatThread?;
      if (chat == null) {
        // Return to chat list if no chat provided
        return MaterialPageRoute(
          builder: (_) => const ChatListPage(),
        );
      }
      return MaterialPageRoute(
        builder: (_) => ChatScreenPage(chat: chat),
      );
    } else if (routeName == RoutePaths.createPost) {
      return MaterialPageRoute(
        builder: (_) => const CreatePostPage(),
      );
    } else if (routeName == RoutePaths.postDetails) {
      final post = routeSettings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => PostDetailsPage(post: post ?? {}),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Text('Route "$routeName" not found'),
          ),
        ),
      );
    }
  }
}

