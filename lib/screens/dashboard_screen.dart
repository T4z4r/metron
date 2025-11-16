import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/project_provider.dart';
import 'package:metron/providers/task_provider.dart';
import 'package:metron/providers/habit_provider.dart';
import 'package:metron/providers/journal_provider.dart';
import 'package:metron/screens/projects_screen.dart';
import 'package:metron/screens/habits_screen.dart';
import 'package:metron/screens/journal_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProv = Provider.of<ProjectProvider>(context);
    final taskProv = Provider.of<TaskProvider>(context);
    final habitProv = Provider.of<HabitProvider>(context);
    final journalProv = Provider.of<JournalProvider>(context);

    final projectsCount = projectProv.projects.length;
    final tasksCount = taskProv.tasks.length;
    final habitsCount = habitProv.habits.length;
    final journalCount = journalProv.entries.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Metron — Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async {
            await projectProv.loadProjects();
            await taskProv.loadTasks();
            await habitProv.loadHabits();
            await journalProv.loadEntries();
          },
          child: ListView(
            children: [
              Row(
                children: [
                  _StatCard(
                      title: 'Projects',
                      value: projectsCount.toString(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProjectsScreen()));
                      }),
                  const SizedBox(width: 12),
                  _StatCard(
                      title: 'Tasks',
                      value: tasksCount.toString(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProjectsScreen()));
                      }),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatCard(
                      title: 'Habits',
                      value: habitsCount.toString(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HabitsScreen()));
                      }),
                  const SizedBox(width: 12),
                  _StatCard(
                      title: 'Journal',
                      value: journalCount.toString(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const JournalScreen()));
                      }),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProjectsScreen())),
                icon: const Icon(Icons.folder),
                label: const Text('View Projects'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HabitsScreen())),
                icon: const Icon(Icons.loop),
                label: const Text('Track Habits'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const JournalScreen())),
                icon: const Icon(Icons.book),
                label: const Text('Open Journal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  const _StatCard(
      {required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              const Spacer(),
              Text(value,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
