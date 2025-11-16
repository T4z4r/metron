// lib/database/task_dao.dart
import 'package:metron/database/app_database.dart';
import 'package:metron/models/task.dart';

class TaskDao {
  Future<int> insert(Task task) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getByProject(int projectId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('tasks',
        where: 'project_id = ?',
        whereArgs: [projectId],
        orderBy: 'created_at DESC');
    return result.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('tasks', orderBy: 'created_at DESC');
    return result.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> update(Task task) async {
    final db = await AppDatabase.instance.database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
