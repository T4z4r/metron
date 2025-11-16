import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/project_provider.dart';
import 'package:metron/providers/task_provider.dart';
import 'package:metron/providers/habit_provider.dart';
import 'package:metron/providers/journal_provider.dart';
import 'package:metron/screens/main_navigation.dart';
import 'package:metron/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.init(); // initialize DB
  runApp(const MetronApp());
}

class MetronApp extends StatelessWidget {
  const MetronApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProjectProvider()..loadProjects()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
        ChangeNotifierProvider(create: (_) => HabitProvider()..loadHabits()),
        ChangeNotifierProvider(create: (_) => JournalProvider()..loadEntries()),
      ],
      child: MaterialApp(
        title: 'Metron',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF8B5CF6),
            surface: Colors.grey.shade50,
            background: Colors.grey.shade100,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFF1F2937),
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 4,
            shape: CircleBorder(),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
