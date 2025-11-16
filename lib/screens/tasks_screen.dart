// lib/screens/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/task_provider.dart';
import 'package:metron/models/task.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Task? _editingTask;

  Future<void> _showEditDialog(BuildContext context, Task task) async {
    final titleCtrl = TextEditingController(text: task.title);
    DateTime? selectedDate = task.dueDateTime;
    final provider = Provider.of<TaskProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(selectedDate == null ? 'No due date' : DateFormat.yMMMd().format(selectedDate!)),
                ),
                TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: const Text('Pick')),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                      });
                    },
                  )
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newTitle = titleCtrl.text.trim();
              if (newTitle.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
                return;
              }
              try {
                await provider.editTask(task, title: newTitle, dueDate: selectedDate);
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChips(TaskProvider prov) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TaskFilter.values.map((f) {
        final label = f == TaskFilter.today ? 'Today' : f == TaskFilter.week ? 'Week' : 'All';
        final active = prov.activeFilter == f;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ChoiceChip(
            label: Text(label),
            selected: active,
            onSelected: (_) => prov.setFilter(f),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TaskProvider>(context);
    final tasks = prov.filteredTasks();

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: RefreshIndicator(
        onRefresh: prov.loadTasks,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildFilterChips(prov),
            const SizedBox(height: 12),
            if (tasks.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Text('No tasks found'))),
            ...tasks.map((t) => Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: t.isDone,
                      onChanged: (_) => prov.toggleTaskDone(t),
                    ),
                    title: Text(t.title, style: TextStyle(decoration: t.isDone ? TextDecoration.lineThrough : null)),
                    subtitle: Text(t.dueDateFormatted),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog(context, t)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => prov.deleteTask(t.id!, projectId: t.projectId)),
                    ]),
                    onTap: () => _showEditDialog(context, t),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final titleCtrl = TextEditingController();
    DateTime? selectedDate;
    int? selectedProjectId;
    final provider = Provider.of<TaskProvider>(context, listen: false);
    // optional: to allow assigning to a project you can pull projects provider here

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Task title')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text(selectedDate == null ? 'No due date' : DateFormat.yMMMd().format(selectedDate!))),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: const Text('Pick'),
                  ),
                  if (selectedDate != null)
                    IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => selectedDate = null)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final title = titleCtrl.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
                  return;
                }
                try {
                  await provider.addTask(selectedProjectId, title, dueDate: selectedDate);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      }),
    );
  }
}
