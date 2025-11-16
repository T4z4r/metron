import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/habit_provider.dart';
import 'package:metron/models/habit.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _showAddHabitDialog(BuildContext context) async {
    _nameCtrl.clear();
    final prov = Provider.of<HabitProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Habit name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_nameCtrl.text.trim().isEmpty) return;
              await prov.addHabit(_nameCtrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<HabitProvider>(context);
    final habits = prov.habits;

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: RefreshIndicator(
        onRefresh: prov.loadHabits,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: habits.length,
          itemBuilder: (_, idx) {
            final h = habits[idx];
            return Card(
              child: ListTile(
                title: Text(h.name),
                subtitle: Text('Streak: ${h.streak}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => prov.incrementStreak(h)),
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => prov.deleteHabit(h.id!)),
                ]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
