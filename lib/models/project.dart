class Project {
  final int? id;
  final String title;
  final String? description;
  final String? dueDate;
  final String createdAt;

  Project({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'created_at': createdAt,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['due_date'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
