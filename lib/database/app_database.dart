import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal.dart';
import '../models/exercise_session.dart';
import '../models/recovery_checkin.dart';
import '../models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/feeding_session.dart';

class AppDatabase {



  String get _currentUid {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw StateError('No authenticated user.');
  }

  return user.uid;
}


            Future<void> _upgradeDatabase(
            Database db,
            int oldVersion,
            int newVersion,
            ) async {
                    if (oldVersion < 2) {
                        await db.execute('''
                        CREATE TABLE meals (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            time INTEGER NOT NULL,
                            meal_type TEXT NOT NULL,
                            food TEXT NOT NULL,
                            quantity TEXT
                        )
                        ''');
                        
                    }

                    if (oldVersion < 3) {
                        await db.execute('''
                        CREATE TABLE daily_hydration (
                            date TEXT PRIMARY KEY,
                            glasses INTEGER NOT NULL
                        )
                        ''');
                    }

                    if (oldVersion < 4) {
                        await db.execute('''
                            CREATE TABLE exercise_sessions (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            time INTEGER NOT NULL,
                            exercise_type TEXT NOT NULL,
                            duration_minutes INTEGER NOT NULL,
                            notes TEXT
                            )
                        ''');
                    }

                    if (oldVersion < 5) {
                        await db.execute('''
                            CREATE TABLE recovery_checkins (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            date TEXT NOT NULL,
                            sleep_minutes INTEGER NOT NULL,
                            energy INTEGER NOT NULL,
                            mood INTEGER NOT NULL,
                            pain INTEGER NOT NULL,
                            note TEXT
                            )
                        ''');
                    }


                    if (oldVersion < 6) {
                        await db.execute('''
                            CREATE UNIQUE INDEX recovery_checkins_date_unique
                            ON recovery_checkins(date)
                        ''');
                        }

                        if (oldVersion < 7) {
                            await db.execute('''
                                CREATE TABLE profiles (
                                firebase_uid TEXT PRIMARY KEY,
                                name TEXT NOT NULL,
                                email TEXT NOT NULL,
                                baby_name TEXT,
                                created_at TEXT NOT NULL,
                                updated_at TEXT NOT NULL
                                )
                            ''');
                          }



                          if (oldVersion < 8) {
                            await db.execute(
                              'ALTER TABLE feeding_sessions ADD COLUMN firebase_uid TEXT',
                            );

                            await db.execute(
                              'ALTER TABLE meals ADD COLUMN firebase_uid TEXT',
                            );

                            await db.execute(
                              'ALTER TABLE daily_hydration ADD COLUMN firebase_uid TEXT',
                            );

                            await db.execute(
                              'ALTER TABLE exercise_sessions ADD COLUMN firebase_uid TEXT',
                            );

                            await db.execute(
                              'ALTER TABLE recovery_checkins ADD COLUMN firebase_uid TEXT',
                            );

                            final user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              final uid = user.uid;

                              await db.update(
                                'feeding_sessions',
                                {'firebase_uid': uid},
                              );

                              await db.update(
                                'meals',
                                {'firebase_uid': uid},
                              );

                              await db.update(
                                'daily_hydration',
                                {'firebase_uid': uid},
                              );

                              await db.update(
                                'exercise_sessions',
                                {'firebase_uid': uid},
                              );

                              await db.update(
                                'recovery_checkins',
                                {'firebase_uid': uid},
                              );
                            }
                          }
            }
    

    /*Future<int> insertMeal(Meal meal) async {
            final db = await database;

            return await db.insert(
                'meals',
                meal.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
            );
        }

        Future<List<Meal>> getMeals() async {
        final db = await database;

        final maps = await db.query(
            'meals',
            orderBy: 'time DESC',
        );

        return maps
            .map((map) => Meal.fromMap(map))
            .toList();
        }

        Future<int> deleteMeal(int id) async {
        final db = await database;

        return await db.delete(
            'meals',
            where: 'id = ?',
            whereArgs: [id],
        );
        }*/




        Future<int> insertMeal(Meal meal) async {
  final db = await database;

  final data = meal.toMap();
  data['firebase_uid'] = _currentUid;

  return await db.insert(
    'meals',
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Meal>> getMeals() async {
  final db = await database;

  final maps = await db.query(
    'meals',
    where: 'firebase_uid = ?',
    whereArgs: [_currentUid],
    orderBy: 'time DESC',
  );

  return maps
      .map((map) => Meal.fromMap(map))
      .toList();
}

Future<int> deleteMeal(int id) async {
  final db = await database;

  return await db.delete(
    'meals',
    where: 'id = ? AND firebase_uid = ?',
    whereArgs: [id, _currentUid],
  );
}


                static final AppDatabase instance = AppDatabase._internal();

                static Database? _database;
                

                AppDatabase._internal();

                Future<Database> get database async {
                    if (_database != null) {
                    return _database!;
                    }

                    _database = await _initDatabase();

                    return _database!;
                }

                Future<Database> _initDatabase() async {
                    final databasePath = await getDatabasesPath();

                    final path = join(
                    databasePath,
                    'postpartum_app.db',
                    );

                    return await openDatabase(
                    path,
                    version: 8,
                    onCreate: _createDatabase,
                    onUpgrade: _upgradeDatabase,
                    );
                }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute('''
        CREATE TABLE feeding_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    started_at INTEGER NOT NULL,
    ended_at INTEGER NOT NULL,
    side TEXT NOT NULL,
    firebase_uid TEXT NOT NULL
      )
        ''');
    await db.execute('''
        CREATE TABLE meals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            time INTEGER NOT NULL,
            meal_type TEXT NOT NULL,
            food TEXT NOT NULL,
            quantity TEXT,
            firebase_uid TEXT NOT NULL
        )
        ''');

        await db.execute('''
  CREATE TABLE profiles (
    firebase_uid TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    baby_name TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
''');

    await db.execute('''
        CREATE TABLE daily_hydration (
    date TEXT NOT NULL,
    firebase_uid TEXT NOT NULL,
    glasses INTEGER NOT NULL,
    PRIMARY KEY (date, firebase_uid)
        )
        ''');

        await db.execute('''
                CREATE TABLE exercise_sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    time INTEGER NOT NULL,
                    exercise_type TEXT NOT NULL,
                    duration_minutes INTEGER NOT NULL,
                    notes TEXT,
                    firebase_uid TEXT NOT NULL
                )
                ''');

        await db.execute('''
            CREATE TABLE recovery_checkins (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL,
                sleep_minutes INTEGER NOT NULL,
                energy INTEGER NOT NULL,
                mood INTEGER NOT NULL,
                pain INTEGER NOT NULL,
                note TEXT,
                firebase_uid TEXT NOT NULL
            )
            ''');
  }

 /* Future<int> insertFeedingSession(
    FeedingSession session,
  ) async {
    final db = await database;

    return await db.insert(
      'feeding_sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FeedingSession>> getFeedingSessions() async {
    final db = await database;

    final maps = await db.query(
      'feeding_sessions',
      orderBy: 'started_at DESC',
    );

    return maps
        .map(
          (map) => FeedingSession.fromMap(map),
        )
        .toList();
  }

  Future<int> deleteFeedingSession(int id) async {
    final db = await database;

    return await db.delete(
      'feeding_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }*/





  Future<int> insertFeedingSession(
  FeedingSession session,
) async {
  final db = await database;

  final data = session.toMap();
  data['firebase_uid'] = _currentUid;

  return await db.insert(
    'feeding_sessions',
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<FeedingSession>> getFeedingSessions() async {
  final db = await database;

  final maps = await db.query(
    'feeding_sessions',
    where: 'firebase_uid = ?',
    whereArgs: [_currentUid],
    orderBy: 'started_at DESC',
  );

  return maps
      .map((map) => FeedingSession.fromMap(map))
      .toList();
}

Future<int> deleteFeedingSession(int id) async {
  final db = await database;

  return await db.delete(
    'feeding_sessions',
    where: 'id = ? AND firebase_uid = ?',
    whereArgs: [id, _currentUid],
  );
}

 /* Future<int> getTodayWater() async {
  final db = await database;

  final today = DateTime.now();

  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';

  final result = await db.query(
    'daily_hydration',
    where: 'date = ?',
    whereArgs: [date],
    limit: 1,
  );

  if (result.isEmpty) {
    return 0;
  }

  return result.first['glasses'] as int;
}
*/



Future<int> getTodayWater() async {
  final db = await database;

  final today = DateTime.now();

  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';

  final result = await db.query(
    'daily_hydration',
    where: 'date = ? AND firebase_uid = ?',
    whereArgs: [date, _currentUid],
    limit: 1,
  );

  if (result.isEmpty) {
    return 0;
  }

  return result.first['glasses'] as int;
}

Future<List<Map<String, Object?>>> getHydrationHistory() async {
  final db = await database;
  return db.query(
    'daily_hydration',
    columns: ['date', 'glasses'],
    where: 'firebase_uid = ?',
    whereArgs: [_currentUid],
    orderBy: 'date DESC',
  );
}


/*Future<void> setTodayWater(int glasses) async {
  final db = await database;

  final today = DateTime.now();

  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';

  await db.insert(
    'daily_hydration',
    {
      'date': date,
      'glasses': glasses,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}*/
Future<void> setTodayWater(int glasses) async {
  final db = await database;

  final today = DateTime.now();

  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';

  await db.insert(
    'daily_hydration',
    {
      'date': date,
      'firebase_uid': _currentUid,
      'glasses': glasses,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


/*Future<int> insertExerciseSession(ExerciseSession session) async {
  final db = await database;

  return await db.insert(
    'exercise_sessions',
    session.toMap(),
  );
}

Future<List<ExerciseSession>> getExerciseSessions() async {
  final db = await database;

  final result = await db.query(
    'exercise_sessions',
    orderBy: 'time DESC',
  );

  return result
      .map((map) => ExerciseSession.fromMap(map))
      .toList();
}

Future<void> deleteExerciseSession(int id) async {
  final db = await database;

  await db.delete(
    'exercise_sessions',
    where: 'id = ?',
    whereArgs: [id],
  );
}*/


Future<int> insertExerciseSession(
  ExerciseSession session,
) async {
  final db = await database;

  final data = session.toMap();
  data['firebase_uid'] = _currentUid;

  return await db.insert(
    'exercise_sessions',
    data,
  );
}

Future<List<ExerciseSession>> getExerciseSessions() async {
  final db = await database;

  final result = await db.query(
    'exercise_sessions',
    where: 'firebase_uid = ?',
    whereArgs: [_currentUid],
    orderBy: 'time DESC',
  );

  return result
      .map((map) => ExerciseSession.fromMap(map))
      .toList();
}

Future<void> deleteExerciseSession(int id) async {
  final db = await database;

  await db.delete(
    'exercise_sessions',
    where: 'id = ? AND firebase_uid = ?',
    whereArgs: [id, _currentUid],
  );
}


/*Future<int> insertRecoveryCheckIn(
  RecoveryCheckIn checkIn,
) async {
  final db = await database;

  return await db.insert(
    'recovery_checkins',
    checkIn.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<int> deleteRecoveryCheckIn(int id) async {
  final db = await database;

  return await db.delete(
    'recovery_checkins',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<RecoveryCheckIn?> getTodayRecoveryCheckIn() async {
  final db = await database;

  final today = DateTime.now();

  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';

  final result = await db.query(
    'recovery_checkins',
    where: 'date = ?',
    whereArgs: [date],
    limit: 1,
  );

  if (result.isEmpty) {
    return null;
  }

  return RecoveryCheckIn.fromMap(result.first);
}*/
Future<int> insertRecoveryCheckIn(
  RecoveryCheckIn checkIn,
) async {
  final db = await database;

  final data = checkIn.toMap();
  data['firebase_uid'] = _currentUid;

  return await db.insert(
    'recovery_checkins',
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<int> deleteRecoveryCheckIn(int id) async {
  final db = await database;

  return await db.delete(
    'recovery_checkins',
    where: 'id = ? AND firebase_uid = ?',
    whereArgs: [id, _currentUid],
  );
}

Future<RecoveryCheckIn?> getTodayRecoveryCheckIn() async {
  final db = await database;

  final today = DateTime.now();

  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';

  final result = await db.query(
    'recovery_checkins',
    where: 'date = ? AND firebase_uid = ?',
    whereArgs: [date, _currentUid],
    limit: 1,
  );

  if (result.isEmpty) {
    return null;
  }

  return RecoveryCheckIn.fromMap(result.first);
}

Future<List<RecoveryCheckIn>> getRecoveryHistory() async {
  final db = await database;
  final results = await db.query(
    'recovery_checkins',
    where: 'firebase_uid = ?',
    whereArgs: [_currentUid],
    orderBy: 'date DESC',
  );
  return results.map(RecoveryCheckIn.fromMap).toList();
}


Future<void> saveProfile(Profile profile) async {
  final db = await database;

  await db.insert(
    'profiles',
    profile.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Profile?> getProfile(String firebaseUid) async {
  final db = await database;

  final result = await db.query(
    'profiles',
    where: 'firebase_uid = ?',
    whereArgs: [firebaseUid],
    limit: 1,
  );

  if (result.isEmpty) {
    return null;
  }

  return Profile.fromMap(result.first);
}

Future<void> deleteProfile(String firebaseUid) async {
  final db = await database;

  await db.delete(
    'profiles',
    where: 'firebase_uid = ?',
    whereArgs: [firebaseUid],
  );
}




}
