import 'package:flutter/material.dart';
import 'package:metron/models/journal_entry.dart';
import 'package:metron/database/journal_dao.dart';
import 'package:intl/intl.dart';

class JournalProvider extends ChangeNotifier {
  final JournalDao _dao = JournalDao();
  List<JournalEntry> entries = [];

  Future<void> loadEntries() async {
    entries = await _dao.getAll();
    notifyListeners();
  }

  Future<void> addEntry(String text) async {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final entry = JournalEntry(entry: text, createdAt: now);
    await _dao.insert(entry);
    await loadEntries();
  }

  Future<void> deleteEntry(int id) async {
    await _dao.delete(id);
    await loadEntries();
  }
}
