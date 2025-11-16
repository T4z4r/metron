import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/project_provider.dart';
import 'package:metron/providers/task_provider.dart';
import 'package:metron/providers/habit_provider.dart';
import 'package:metron/providers/journal_provider.dart';
import 'package:metron/screens/dashboard_screen.dart';
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
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
