class Habit {
  final int? id;
  final String name;
  final int streak;
  final String createdAt;

  Habit({
    this.id,
    required this.name,
    this.streak = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'streak': streak,
      'created_at': createdAt,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      streak: map['streak'] as int,
      createdAt: map['created_at'] as String,
    );
  }
}
