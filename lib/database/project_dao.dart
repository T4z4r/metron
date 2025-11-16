import 'package:metron/database/app_database.dart';
import 'package:metron/models/project.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDao {
  Future<int> insert(Project project) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('projects', project.toMap());
  }

  Future<List<Project>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('projects', orderBy: 'created_at DESC');
    return result.map((m) => Project.fromMap(m)).toList();
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }
}
