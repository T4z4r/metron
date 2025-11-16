import 'package:flutter/material.dart';
import 'package:metron/models/project.dart';
import 'package:metron/database/project_dao.dart';
import 'package:intl/intl.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectDao _dao = ProjectDao();
  List<Project> projects = [];

  Future<void> loadProjects() async {
    projects = await _dao.getAll();
    notifyListeners();
  }

  Future<void> addProject(String title,
      {String? description, String? dueDate}) async {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final project = Project(
        title: title,
        description: description,
        dueDate: dueDate,
        createdAt: now);
    await _dao.insert(project);
    await loadProjects();
  }

  Future<void> deleteProject(int id) async {
    await _dao.delete(id);
    await loadProjects();
  }
}
