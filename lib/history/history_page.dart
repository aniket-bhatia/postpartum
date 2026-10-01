import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/exercise_session.dart';
import '../models/feeding_session.dart';
import '../models/meal.dart';
import '../models/recovery_checkin.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<Map<DateTime, List<_HistoryEntry>>> _history;

  @override
  void initState() {
    super.initState();
    _history = _loadHistory();
  }

  Future<Map<DateTime, List<_HistoryEntry>>> _loadHistory() async {
    final database = AppDatabase.instance;
    final results = await Future.wait([
      database.getFeedingSessions(),
      database.getMeals(),
      database.getHydrationHistory(),
      database.getExerciseSessions(),
      database.getRecoveryHistory(),
    ]);

    final grouped = <DateTime, List<_HistoryEntry>>{};
    void add(DateTime date, _HistoryEntry entry) {
      final day = DateTime(date.year, date.month, date.day);
      grouped.putIfAbsent(day, () => []).add(entry);
    }

    for (final session in results[0] as List<FeedingSession>) {
      add(session.startedAt, _HistoryEntry(
        time: session.startedAt,
        icon: Icons.child_care,
        title: 'Feeding',
        detail: '${session.side} side · ${_duration(session.duration.inMinutes)}',
      ));
    }
    for (final meal in results[1] as List<Meal>) {
      add(meal.time, _HistoryEntry(
        time: meal.time,
        icon: Icons.restaurant,
        title: meal.mealType,
        detail: '${meal.food}${meal.quantity == null ? '' : ' · ${meal.quantity}'}',
      ));
    }
    for (final row in results[2] as List<Map<String, Object?>>) {
      final day = DateTime.parse(row['date']! as String);
      add(day, _HistoryEntry(
        time: day,
        icon: Icons.water_drop,
        title: 'Hydration',
        detail: '${row['glasses']} glasses of water',
      ));
    }
    for (final session in results[3] as List<ExerciseSession>) {
      add(session.time, _HistoryEntry(
        time: session.time,
        icon: Icons.self_improvement,
        title: session.exerciseType,
        detail: '${session.durationMinutes} minutes${session.notes == null || session.notes!.isEmpty ? '' : ' · ${session.notes}'}',
      ));
    }
    for (final checkIn in results[4] as List<RecoveryCheckIn>) {
      add(checkIn.date, _HistoryEntry(
        time: checkIn.date,
        icon: Icons.favorite_outline,
        title: 'Recovery check-in',
        detail: 'Sleep ${_duration(checkIn.sleepMinutes)} · Energy ${checkIn.energy}/5 · Mood ${checkIn.mood}/5 · Pain ${checkIn.pain}/10${checkIn.note == null || checkIn.note!.isEmpty ? '' : ' · ${checkIn.note}'}',
      ));
    }

    for (final entries in grouped.values) {
      entries.sort((a, b) => b.time.compareTo(a.time));
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  static String _duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    return remainder == 0 ? '${hours}h' : '${hours}h ${remainder}m';
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '$hour:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, List<_HistoryEntry>>>(
      future: _history,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('History could not be loaded.'),
              TextButton(
                onPressed: () => setState(() => _history = _loadHistory()),
                child: const Text('Try again'),
              ),
            ]),
          );
        }
        final days = snapshot.data ?? {};
        if (days.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Text(
                'Your activity will appear here as you log feeds, meals, water, exercise and recovery check-ins.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => setState(() => _history = _loadHistory()),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const Text('Your activity over time', style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 12),
              for (final day in days.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Text(_formatDate(day.key), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Column(
                    children: [
                      for (var i = 0; i < day.value.length; i++) ...[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFEDE7F6),
                            child: Icon(day.value[i].icon, color: const Color(0xFF67558A)),
                          ),
                          title: Text(day.value[i].title),
                          subtitle: Text(day.value[i].detail),
                          trailing: Text(_formatTime(day.value[i].time), style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ),
                        if (i != day.value.length - 1) const Divider(height: 1, indent: 72),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _HistoryEntry {
  const _HistoryEntry({
    required this.time,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final DateTime time;
  final IconData icon;
  final String title;
  final String detail;
}
