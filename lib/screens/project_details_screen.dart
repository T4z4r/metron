import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/task_provider.dart';
import 'package:metron/models/task.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final int projectId;
  final String projectTitle;
  const ProjectDetailsScreen(
      {required this.projectId, required this.projectTitle, super.key});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final _taskCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false)
        .loadTasksForProject(widget.projectId);
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    _taskCtrl.clear();
    final prov = Provider.of<TaskProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
            controller: _taskCtrl,
            decoration: const InputDecoration(labelText: 'Task title')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_taskCtrl.text.trim().isEmpty) return;
              await prov.addTask(widget.projectId, _taskCtrl.text.trim(),
                  dueDate: null);
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
    final prov = Provider.of<TaskProvider>(context);
    final tasks =
        prov.tasks.where((t) => t.projectId == widget.projectId).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.projectTitle)),
      body: RefreshIndicator(
        onRefresh: () => prov.loadTasksForProject(widget.projectId),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          itemBuilder: (_, idx) {
            final t = tasks[idx];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: t.isDone,
                  onChanged: (_) => prov.toggleTaskDone(t),
                ),
                title: Text(t.title,
                    style: TextStyle(
                        decoration:
                            t.isDone ? TextDecoration.lineThrough : null)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      prov.deleteTask(t.id!, projectId: widget.projectId),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
