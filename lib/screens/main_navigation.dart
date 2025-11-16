import 'package:flutter/material.dart';
import 'package:metron/screens/dashboard_screen.dart';
import 'package:metron/screens/projects_screen.dart';
import 'package:metron/screens/habits_screen.dart';
import 'package:metron/screens/journal_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProjectsScreen(),
    const HabitsScreen(),
    const JournalScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.folder_outlined),
      activeIcon: Icon(Icons.folder),
      label: 'Projects',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.loop_outlined),
      activeIcon: Icon(Icons.loop),
      label: 'Habits',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined),
      activeIcon: Icon(Icons.book),
      label: 'Journal',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          selectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          unselectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: 22,
          ),
          items: _navItems,
        ),
      ),
    );
  }
}