import 'package:flutter/material.dart';
import 'package:metron/models/habit.dart';
import 'package:metron/database/habit_dao.dart';
import 'package:intl/intl.dart';

class HabitProvider extends ChangeNotifier {
  final HabitDao _dao = HabitDao();
  List<Habit> habits = [];

  Future<void> loadHabits() async {
    habits = await _dao.getAll();
    notifyListeners();
  }

  Future<void> addHabit(String name) async {
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final habit = Habit(name: name, streak: 0, createdAt: now);
    await _dao.insert(habit);
    await loadHabits();
  }

  Future<void> incrementStreak(Habit habit) async {
    final updated = Habit(
        id: habit.id,
        name: habit.name,
        streak: habit.streak + 1,
        createdAt: habit.createdAt);
    await _dao.update(updated);
    await loadHabits();
  }

  Future<void> deleteHabit(int id) async {
    await _dao.delete(id);
    await loadHabits();
  }
}
