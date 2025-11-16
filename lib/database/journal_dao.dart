import 'package:metron/database/app_database.dart';
import 'package:metron/models/journal_entry.dart';

class JournalDao {
  Future<int> insert(JournalEntry entry) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('journal', entry.toMap());
  }

  Future<List<JournalEntry>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('journal', orderBy: 'created_at DESC');
    return result.map((m) => JournalEntry.fromMap(m)).toList();
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('journal', where: 'id = ?', whereArgs: [id]);
  }
}
