class ExerciseSession {
  final int? id;
  final DateTime time;
  final String exerciseType;
  final int durationMinutes;
  final String? notes;

  ExerciseSession({
    this.id,
    required this.time,
    required this.exerciseType,
    required this.durationMinutes,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.millisecondsSinceEpoch,
      'exercise_type': exerciseType,
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }

  factory ExerciseSession.fromMap(Map<String, dynamic> map) {
    return ExerciseSession(
      id: map['id'] as int?,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      exerciseType: map['exercise_type'] as String,
      durationMinutes: map['duration_minutes'] as int,
      notes: map['notes'] as String?,
    );
  }
}