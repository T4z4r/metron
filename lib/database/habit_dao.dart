import 'package:metron/database/app_database.dart';
import 'package:metron/models/habit.dart';

class HabitDao {
  Future<int> insert(Habit habit) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('habits', orderBy: 'created_at DESC');
    return result.map((m) => Habit.fromMap(m)).toList();
  }

  Future<int> update(Habit habit) async {
    final db = await AppDatabase.instance.database;
    return await db.update('habits', habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
