// lib/providers/task_provider.dart
import 'package:flutter/material.dart';
import 'package:metron/models/task.dart';
import 'package:metron/database/task_dao.dart';
import 'package:intl/intl.dart';

enum TaskFilter { today, week, all }

class TaskProvider extends ChangeNotifier {
  final TaskDao _dao = TaskDao();
  List<Task> tasks = [];

  TaskFilter activeFilter = TaskFilter.all;

  Future<void> loadTasks() async {
    tasks = await _dao.getAll();
    notifyListeners();
  }

  Future<void> loadTasksForProject(int projectId) async {
    tasks = await _dao.getByProject(projectId);
    notifyListeners();
  }

  Future<void> addTask(int? projectId, String title,
      {DateTime? dueDate}) async {
    if (title.trim().isEmpty) throw ArgumentError('Task title cannot be empty');
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final due = dueDate != null ? dueDate.toIso8601String() : null;
    final task = Task(
        projectId: projectId,
        title: title.trim(),
        dueDate: due,
        createdAt: now);
    await _dao.insert(task);
    if (projectId != null)
      await loadTasksForProject(projectId);
    else
      await loadTasks();
  }

  Future<void> editTask(Task task, {String? title, DateTime? dueDate}) async {
    final newTitle = title == null ? task.title : title.trim();
    if (newTitle.isEmpty) throw ArgumentError('Task title cannot be empty');
    final updated = task.copyWith(
      title: newTitle,
      dueDate: dueDate?.toIso8601String(),
    );
    await _dao.update(updated);
    if (task.projectId != null)
      await loadTasksForProject(task.projectId!);
    else
      await loadTasks();
  }

  Future<void> toggleTaskDone(Task task) async {
    final updated = task.copyWith(isDone: !task.isDone);
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

  // Filtered view based on activeFilter and optional projectId
  List<Task> filteredTasks({int? projectId}) {
    List<Task> list = tasks;
    if (projectId != null) {
      list = list.where((t) => t.projectId == projectId).toList();
    }
    final now = DateTime.now();
    switch (activeFilter) {
      case TaskFilter.today:
        return list.where((t) {
          final dt = t.dueDateTime;
          if (dt == null) return false;
          return _isSameDate(dt, now);
        }).toList();
      case TaskFilter.week:
        return list.where((t) {
          final dt = t.dueDateTime;
          if (dt == null) return false;
          final diff = dt.difference(now).inDays;
          return diff >= 0 && diff <= 7;
        }).toList();
      case TaskFilter.all:
      default:
        return list;
    }
  }

  void setFilter(TaskFilter filter) {
    activeFilter = filter;
    notifyListeners();
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
