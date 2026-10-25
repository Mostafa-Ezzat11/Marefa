import 'package:flutter/material.dart';
import '../../constants.dart';
import 'earnings_page.dart';
import 'teacher_home_page.dart';

/// Holds the bottom navigation and switches between the teacher tabs.
class TeacherMainPage extends StatefulWidget {
  const TeacherMainPage({super.key});

  @override
  State<TeacherMainPage> createState() => _TeacherMainPageState();
}

class _TeacherMainPageState extends State<TeacherMainPage> {
  int _currentIndex = 0;

  static const _pages = [
    TeacherHomePage(),
    EarningsPage(),
    Center(child: Text('My Courses')), // TODO: replace
    Center(child: Text('Settings')), // TODO: replace
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primaryColor.withAlpha(30),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(
                  Icons.home_rounded, color: AppColors.primaryColor),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(
                  Icons.bar_chart_rounded, color: AppColors.primaryColor),
              label: 'Earning',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(
                  Icons.menu_book_rounded, color: AppColors.primaryColor),
              label: 'My Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(
                  Icons.settings_rounded, color: AppColors.primaryColor),
              label: 'Settings',
            ),
          ],
        )
    );
  }
}
