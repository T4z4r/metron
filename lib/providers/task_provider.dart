import 'package:flutter/material.dart';
import 'package:metron/models/task.dart';
import 'package:metron/database/task_dao.dart';
import 'package:intl/intl.dart';

class TaskProvider extends ChangeNotifier {
  final TaskDao _dao = TaskDao();
  List<Task> tasks = [];

  Future<void> loadTasks() async {
    tasks = await _dao.getAll();
    notifyListeners();
  }

  Future<void> loadTasksForProject(int projectId) async {
    tasks = await _dao.getByProject(projectId);
    notifyListeners();
  }

  Future<void> addTask(int? projectId, String title, {String? dueDate}) async {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final task = Task(
        projectId: projectId, title: title, dueDate: dueDate, createdAt: now);
    await _dao.insert(task);
    if (projectId != null)
      await loadTasksForProject(projectId);
    else
      await loadTasks();
  }

  Future<void> toggleTaskDone(Task task) async {
    final updated = Task(
      id: task.id,
      projectId: task.projectId,
      title: task.title,
      isDone: !task.isDone,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );
    await _dao.update(updated);
    if (task.projectId != null)
      await loadTasksForProject(task.projectId!);
    else
      await loadTasks();
  }

  Future<void> deleteTask(int id, {int? projectId}) async {
    await _dao.delete(id);
    if (projectId != null)
      await loadTasksForProject(projectId);
    else
      await loadTasks();
  }
}
