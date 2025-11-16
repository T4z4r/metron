// lib/models/task.dart
import 'package:intl/intl.dart';

class Task {
  final int? id;
  final int? projectId;
  final String title;
  final bool isDone;
  final String? dueDate; // ISO string: yyyy-MM-dd or full timestamp
  final String createdAt;

  Task({
    this.id,
    this.projectId,
    required this.title,
    this.isDone = false,
    this.dueDate,
    required this.createdAt,
  });

  Task copyWith({
    int? id,
    int? projectId,
    String? title,
    bool? isDone,
    String? dueDate,
    String? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'is_done': isDone ? 1 : 0,
      'due_date': dueDate,
      'created_at': createdAt,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      projectId: map['project_id'] as int?,
      title: map['title'] as String,
      isDone: (map['is_done'] as int) == 1,
      dueDate: map['due_date'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  /// Returns parsed DateTime of dueDate or null
  DateTime? get dueDateTime {
    if (dueDate == null) return null;
    try {
      // Accept ISO timestamp or date
      return DateTime.parse(dueDate!);
    } catch (e) {
      try {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dueDate!);
      } catch (_) {
        return null;
      }
    }
  }

  /// Friendly due date label
  String get dueDateFormatted {
    final dt = dueDateTime;
    if (dt == null) return 'No due date';
    return DateFormat.yMMMd().format(dt);
  }
}
