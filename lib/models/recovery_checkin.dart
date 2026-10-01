class RecoveryCheckIn {
  final int? id;
  final DateTime date;
  final int sleepMinutes;
  final int energy;
  final int mood;
  final int pain;
  final String? note;

  RecoveryCheckIn({
    this.id,
    required this.date,
    required this.sleepMinutes,
    required this.energy,
    required this.mood,
    required this.pain,
    this.note,
  });

  Map<String, dynamic> toMap() {
  final dateOnly =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  return {
    'id': id,
    'date': dateOnly,
    'sleep_minutes': sleepMinutes,
    'energy': energy,
    'mood': mood,
    'pain': pain,
    'note': note,
  };
}

factory RecoveryCheckIn.fromMap(Map<String, dynamic> map) {
  return RecoveryCheckIn(
    id: map['id'] as int?,
    date: DateTime.parse(map['date'] as String),
    sleepMinutes: map['sleep_minutes'] as int,
    energy: map['energy'] as int,
    mood: map['mood'] as int,
    pain: map['pain'] as int,
    note: map['note'] as String?,
  );
}
/*class RecoveryCheckIn {
  final int? id;
  final DateTime date;
  final int sleepMinutes;
  final int energy;
  final int mood;
  final int pain;
  final String? note;

  RecoveryCheckIn({
    this.id,
    required this.date,
    required this.sleepMinutes,
    required this.energy,
    required this.mood,
    required this.pain,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'sleep_minutes': sleepMinutes,
      'energy': energy,
      'mood': mood,
      'pain': pain,
      'note': note,
    };
  }

  factory RecoveryCheckIn.fromMap(Map<String, dynamic> map) {
    return RecoveryCheckIn(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      sleepMinutes: map['sleep_minutes'] as int,
      energy: map['energy'] as int,
      mood: map['mood'] as int,
      pain: map['pain'] as int,
      note: map['note'] as String?,
    );
  }*/
} 