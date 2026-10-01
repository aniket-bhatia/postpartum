class FeedingSession {
  final int? id;
  final DateTime startedAt;
  final DateTime endedAt;
  final String side;

  FeedingSession({
    this.id,
    required this.startedAt,
    required this.endedAt,
    required this.side,
  });

  Duration get duration => endedAt.difference(startedAt);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'started_at': startedAt.millisecondsSinceEpoch,
      'ended_at': endedAt.millisecondsSinceEpoch,
      'side': side,
    };
  }

  factory FeedingSession.fromMap(Map<String, dynamic> map) {
    return FeedingSession(
      id: map['id'] as int?,
      startedAt: DateTime.fromMillisecondsSinceEpoch(
        map['started_at'] as int,
      ),
      endedAt: DateTime.fromMillisecondsSinceEpoch(
        map['ended_at'] as int,
      ),
      side: map['side'] as String,
    );
  }
}