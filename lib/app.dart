import 'package:flutter/material.dart';
import 'core/widgets_shared/bottom_nav_bar.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/safety/presentation/pages/safety_dashboard.dart';
import 'features/wellness_hub/presentation/screens/wellness_dashboard.dart';
import 'features/growth/presentation/pages/courses_home.dart';
import 'features/legal/presentation/pages/legal_home.dart';
import 'features/marketplace/presentation/pages/marketplace_home_page.dart';

class App extends StatefulWidget {
  final int initialIndex;

  const App({super.key, this.initialIndex = 0});

  @override
  State<App> createState() => AppState();

  static AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppState>();
  }
}

class AppState extends State<App> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const SafetyDashboard(),
    const WellnessDashboard(),
    const CoursesHome(),
    const LegalCategoriesScreen(),
    const MarketplaceHomePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

