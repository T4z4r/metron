class JournalEntry {
  final int? id;
  final String entry;
  final String createdAt;

  JournalEntry({
    this.id,
    required this.entry,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entry': entry,
      'created_at': createdAt,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as int?,
      entry: map['entry'] as String,
      createdAt: map['created_at'] as String,
    );
  }
}
