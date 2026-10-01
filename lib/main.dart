import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'database/app_database.dart';
import 'models/feeding_session.dart';
import 'models/exercise_session.dart';
import 'models/recovery_checkin.dart';

import 'models/meal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login_page.dart';
import 'profile/profile_page.dart';
import 'history/history_page.dart';

import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PostpartumApp());
}

class PostpartumApp extends StatelessWidget {
  const PostpartumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Postpartum Recovery',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8E7AB5),
        ),
        fontFamily: 'Roboto',
      ),
      home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (snapshot.hasData) {
      return const HomePage();
    }

    return const LoginPage();
  },
),
    );
  }
}

// ------------------------------------------------------------
// FEEDING SESSION MODEL
// ------------------------------------------------------------



// ------------------------------------------------------------
// HOME PAGE
// ------------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7FB),
        elevation: 0,
        title: const Text(
          'Postpartum Recovery',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: _selectedIndex == 1
          ? const HistoryPage()
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Good morning 🌸',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Day 1 of your recovery',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s recovery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Focus on rest, hydration and gentle recovery.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Your trackers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              TrackerCard(
                icon: Icons.child_care,
                title: 'Breastfeeding',
                subtitle: 'Track feeds and feeding patterns',
                color: const Color(0xFFFFE5EC),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BreastfeedingPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              /*TrackerCard(
                icon: Icons.restaurant,
                title: 'Nutrition',
                subtitle: 'Meals, hydration and nutrients',
                color: const Color(0xFFE4F3E4),
                onTap: () {},
              ),*/
              TrackerCard(
                    icon: Icons.restaurant,
                    title: 'Nutrition',
                    subtitle: 'Meals, hydration and nutrients',
                    color: const Color(0xFFE4F3E4),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NutritionPage(),
                        ),
                      );
                    },
                  ),

              const SizedBox(height: 12),

              TrackerCard(
                icon: Icons.self_improvement,
                title: 'Exercise',
                subtitle: 'Gentle movement for recovery',
                color: const Color(0xFFE4EFFB),
                onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExercisePage(),
                          ),
                        );
                },
              ),

              const SizedBox(height: 12),

              TrackerCard(
                icon: Icons.favorite_outline,
                title: 'Recovery',
                subtitle: 'Daily recovery check-in',
                color: const Color(0xFFF6E4F0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecoveryPage(),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(

        
       
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(),
                  ),
                );
              } else {
                setState(() => _selectedIndex = index);
              }
            },
            destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// BREASTFEEDING PAGE
// ------------------------------------------------------------

class BreastfeedingPage extends StatefulWidget {
  const BreastfeedingPage({super.key});

  @override
  State<BreastfeedingPage> createState() => _BreastfeedingPageState();
}

class _BreastfeedingPageState extends State<BreastfeedingPage> {
  Timer? _timer;

  DateTime? _startTime;

  Duration _elapsed = Duration.zero;

  String _selectedSide = 'Left';

  final List<FeedingSession> _sessions = [];
  

  bool get _isFeeding => _timer != null;

  void _startFeeding() {
    _startTime = DateTime.now();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_startTime == null) return;

        setState(() {
          _elapsed = DateTime.now().difference(_startTime!);
        });
      },
    );

    setState(() {});
  }

  
  Future<void> _finishFeeding() async {
    if (_startTime == null) return;

    final endTime = DateTime.now();

    final session = FeedingSession(
      startedAt: _startTime!,
      endedAt: endTime,
      side: _selectedSide,
    );

    await AppDatabase.instance.insertFeedingSession(session);

    _timer?.cancel();
    _timer = null;

    _startTime = null;
    _elapsed = Duration.zero;

    await _loadSessions();
  }
  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await AppDatabase.instance.getFeedingSessions();

    if (!mounted) return;

    setState(() {
  _sessions
    ..clear()
    ..addAll(sessions);
});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

    int get _totalMinutes {
    final now = DateTime.now();

    return _sessions.where((session) {
      return session.startedAt.year == now.year &&
          session.startedAt.month == now.month &&
          session.startedAt.day == now.day;
    }).fold<int>(
      0,
      (total, session) => total + session.duration.inMinutes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7FB),
        elevation: 0,
        title: const Text(
          'Breastfeeding',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Track your feeding sessions',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // SUMMARY
              // ------------------------------------------------

              Row(
                children: [

                  Expanded(
                    child: SummaryCard(
                      value: '${_sessions.length}',
                      label: 'Feeds',
                      icon: Icons.child_care,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SummaryCard(
                      value: '${_totalMinutes} min',
                      label: 'Total time',
                      icon: Icons.timer_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // CURRENT FEEDING
              // ------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: _isFeeding
                      ? const Color(0xFFFFE5EC)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [

                    Text(
                      _isFeeding
                          ? 'Feeding in progress'
                          : 'Ready for the next feed',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_isFeeding)
                      Text(
                        _formatDuration(_elapsed),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    if (!_isFeeding)
                      const Icon(
                        Icons.child_care,
                        size: 55,
                      ),

                    const SizedBox(height: 20),

                    // LEFT / RIGHT / BOTH
                    Row(
                      children: [
                        Expanded(
                          child: SideButton(
                            label: 'Left',
                            selected: _selectedSide == 'Left',
                            onTap: () {
                              setState(() {
                                _selectedSide = 'Left';
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: SideButton(
                            label: 'Right',
                            selected: _selectedSide == 'Right',
                            onTap: () {
                              setState(() {
                                _selectedSide = 'Right';
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: SideButton(
                            label: 'Both',
                            selected: _selectedSide == 'Both',
                            onTap: () {
                              setState(() {
                                _selectedSide = 'Both';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isFeeding
                            ? _finishFeeding
                            : _startFeeding,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          backgroundColor: const Color(0xFF292333),
                        ),
                        child: Text(
                          _isFeeding
                              ? 'Finish Feeding'
                              : 'Start Feeding',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------
              // SESSION HISTORY
              // ------------------------------------------------

              const Text(
                'Today\'s sessions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (_sessions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No feeds recorded yet',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              ..._sessions.map(
                (session) => SessionCard(
                  session: session,
                  time: _formatTime(session.startedAt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// SUMMARY CARD
// ------------------------------------------------------------

class SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            size: 25,
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// SIDE BUTTON
// ------------------------------------------------------------

class SideButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SideButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected
            ? const Color(0xFFEDE7F6)
            : Colors.white,
        side: BorderSide(
          color: selected
              ? const Color(0xFF8E7AB5)
              : Colors.grey.shade300,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(label),
    );
  }
}

// ------------------------------------------------------------
// SESSION CARD
// ------------------------------------------------------------

class SessionCard extends StatelessWidget {
  final FeedingSession session;
  final String time;

  const SessionCard({
    super.key,
    required this.session,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5EC),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.child_care,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  session.side,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${session.duration.inMinutes} min',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// TRACKER CARD
// ------------------------------------------------------------

class TrackerCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const TrackerCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 27,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// NUTRITION PAGE
// ------------------------------------------------------------



class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}
// ------------------------------------------------------------
// MEAL BUTTON
// ------------------------------------------------------------



class MealButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MealButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,

      icon: Icon(icon),

      label: Text(label),

      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),

        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
// ------------------------------------------------------------
// MEAL CARD
// ------------------------------------------------------------





class MealCard extends StatelessWidget {
  final Meal meal;
  final String time;

  const MealCard({
    super.key,
    required this.meal,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFE4F3E4),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.restaurant,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  meal.mealType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  meal.food,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),

                if (meal.quantity != null) ...[
                  const SizedBox(height: 3),

                  Text(
                    meal.quantity!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
// ------------------------------------------------------------
// NUTRITION PAGE STATE
// ------------------------------------------------------------


class _NutritionPageState extends State<NutritionPage> {
  List<Meal> _meals = [];

  bool _loading = true;

  int _waterGlasses = 0;

  @override
  void initState() {
    super.initState();
    _loadNutrition();
  }

  /*Future<void> _loadMeals() async {
    final meals = await AppDatabase.instance.getMeals();

    if (!mounted) return;

    setState(() {
      _meals = meals;
      _loading = false;
    });
  }*/
  Future<void> _loadNutrition() async {
  final meals = await AppDatabase.instance.getMeals();
  final water = await AppDatabase.instance.getTodayWater();

  if (!mounted) return;

  setState(() {
    _meals = meals;
    _waterGlasses = water;
    _loading = false;
  });
  }

  Future<void> _addMeal(String mealType) async {
    final foodController = TextEditingController();
    final quantityController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $mealType'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: foodController,
                decoration: const InputDecoration(
                  labelText: 'What did you eat?',
                  hintText: 'e.g. Dal, roti and vegetables',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g. 1 bowl',
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    if (foodController.text.trim().isEmpty) return;

    final meal = Meal(
      time: DateTime.now(),
      mealType: mealType,
      food: foodController.text.trim(),
      quantity: quantityController.text.trim().isEmpty
          ? null
          : quantityController.text.trim(),
    );

    await AppDatabase.instance.insertMeal(meal);

    foodController.dispose();
    quantityController.dispose();

   // await _loadMeals();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7FB),
        elevation: 0,
        title: const Text(
          'Nutrition',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Fuel your recovery',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              // Water
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFFE4EFFB),
                  borderRadius: BorderRadius.circular(22),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Row(
                      children: [
                        Icon(Icons.water_drop_outlined),

                        SizedBox(width: 10),

                        Text(
                          'Hydration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      '$_waterGlasses / 8 glasses',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: (_waterGlasses / 8).clamp(0.0, 1.0),
                      minHeight: 8,
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      child: OutlinedButton.icon(
                        /*onPressed: () {
                          setState(() {
                            _waterGlasses++;
                          });
                        },*/
                        onPressed: () async {
                            final newValue = _waterGlasses + 1;

                            await AppDatabase.instance.setTodayWater(newValue);

                            if (!mounted) return;

                            setState(() {
                              _waterGlasses = newValue;
                            });
                          },

                        icon: const Icon(
                          Icons.add,
                        ),

                        label: const Text(
                          'Add glass',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Add a meal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: MealButton(
                      icon: Icons.free_breakfast,
                      label: 'Breakfast',
                      onTap: () => _addMeal('Breakfast'),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: MealButton(
                      icon: Icons.lunch_dining,
                      label: 'Lunch',
                      onTap: () => _addMeal('Lunch'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: MealButton(
                      icon: Icons.dinner_dining,
                      label: 'Dinner',
                      onTap: () => _addMeal('Dinner'),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: MealButton(
                      icon: Icons.apple,
                      label: 'Snack',
                      onTap: () => _addMeal('Snack'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Today\'s meals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (_loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),

              if (!_loading && _meals.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Column(
                    children: [
                      Icon(
                        Icons.restaurant_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 10),

                      Text(
                        'No meals recorded yet',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              ..._meals.map(
                (meal) => MealCard(
                  meal: meal,
                  time: _formatTime(meal.time),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final AppDatabase _database = AppDatabase.instance;

  List<ExerciseSession> _sessions = [];

  String _selectedExercise = 'Walking';
  int _duration = 10;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _exerciseTypes = [
    'Walking',
    'Stretching',
    'Breathing',
    'Pelvic floor',
    'Light strength',
  ];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await _database.getExerciseSessions();

    if (!mounted) return;

    setState(() {
      _sessions = sessions;
    });
  }

  Future<void> _saveExercise() async {
    if (_duration <= 0) return;

    final session = ExerciseSession(
      time: DateTime.now(),
      exerciseType: _selectedExercise,
      durationMinutes: _duration,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await _database.insertExerciseSession(session);

    _notesController.clear();

    await _loadSessions();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise saved 🌸'),
      ),
    );
  }

  Future<void> _deleteExercise(int id) async {
    await _database.deleteExerciseSession(id);
    await _loadSessions();
  }

  int get _totalMinutes {
    return _sessions.fold(
      0,
      (total, session) => total + session.durationMinutes,
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_walk,
                  size: 40,
                ),

                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    Text(
                      '$_totalMinutes minutes',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'What did you do?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(//hjghjghjdghjdgfjhdfvhdgvhdgjghjdfgj
            initialValue: _selectedExercise,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: _exerciseTypes.map((exercise) {
              return DropdownMenuItem(
                value: exercise,
                child: Text(exercise),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedExercise = value;
              });
            },
          ),
          DropdownButtonFormField<int>(
              value: _duration,
              decoration: const InputDecoration(
                labelText: 'Duration',
                border: OutlineInputBorder(),
              ),
              items: [
                for (int i = 5; i <= 180; i += 5)
                  DropdownMenuItem(
                    value: i,
                    child: Text('$i minutes'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _duration = value;
                  });
                }
              },
            ),

          //const SizedBox(height: 24),

          

          const SizedBox(height: 16),

          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'How did it feel?',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _saveExercise,
              icon: const Icon(Icons.check),
              label: const Text(
                'Save Exercise',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'Exercise History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (_sessions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No exercise recorded yet.',
                ),
              ),
            ),

          ..._sessions.map(
            (session) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.fitness_center),
                  ),

                  title: Text(
                    session.exerciseType,
                  ),

                  subtitle: Text(
                    '${session.durationMinutes} minutes'
                    '${session.notes != null ? '\n${session.notes}' : ''}',
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: session.id == null
                        ? null
                        : () => _deleteExercise(session.id!),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final AppDatabase _database = AppDatabase.instance;

  RecoveryCheckIn? _todayCheckIn;
  bool _editing = false;

  int _sleepMinutes = 480;
  int _energy = 3;
  int _mood = 3;
  int _pain = 0;

  final TextEditingController _notesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCheckIn();
  }

  Future<void> _loadCheckIn() async {
    final checkIn = await _database.getTodayRecoveryCheckIn();

    if (!mounted) return;

    setState(() {
      _todayCheckIn = checkIn;

      if (checkIn != null) {
        _sleepMinutes = checkIn.sleepMinutes;
        _energy = checkIn.energy;
        _mood = checkIn.mood;
        _pain = checkIn.pain;
        _notesController.text = checkIn.note ?? '';
      }
    });
  }

  Future<void> _saveCheckIn() async {
    final checkIn = RecoveryCheckIn(
      date: DateTime.now(),
      sleepMinutes: _sleepMinutes,
      energy: _energy,
      mood: _mood,
      pain: _pain,
      note: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await _database.insertRecoveryCheckIn(checkIn);
    await _loadCheckIn();

    if (!mounted) return;

    setState(() {
      _editing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recovery check-in saved 🌸'),
      ),
    );
  }

  String _formatSleep(int minutes) {
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;

    if (remaining == 0) {
      return '$hours hours';
    }

    return '$hours h $remaining min';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'A quick daily check-in about your recovery.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 28),

          // --------------------------------------------------
          // FORM
          // --------------------------------------------------

          if (_todayCheckIn == null || _editing) ...[
            const Text(
              'Sleep',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _formatSleep(_sleepMinutes),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            Slider(
              min: 0,
              max: 720,
              divisions: 48,
              value: _sleepMinutes.toDouble(),
              label: _formatSleep(_sleepMinutes),
              onChanged: (value) {
                setState(() {
                  _sleepMinutes = value.round();
                });
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Energy',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              value: _energy.toDouble(),
              label: '$_energy / 5',
              onChanged: (value) {
                setState(() {
                  _energy = value.round();
                });
              },
            ),

            Center(
              child: Text(
                '$_energy / 5',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Mood',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              value: _mood.toDouble(),
              label: '$_mood / 5',
              onChanged: (value) {
                setState(() {
                  _mood = value.round();
                });
              },
            ),

            Center(
              child: Text(
                '$_mood / 5',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Pain / discomfort',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Slider(
              min: 0,
              max: 10,
              divisions: 10,
              value: _pain.toDouble(),
              label: '$_pain / 10',
              onChanged: (value) {
                setState(() {
                  _pain = value.round();
                });
              },
            ),

            Center(
              child: Text(
                '$_pain / 10',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Anything you want to remember?',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saveCheckIn,
                icon: const Icon(Icons.check),
                label: Text(
                  _todayCheckIn == null
                      ? "Save Today's Check-in"
                      : "Update Today's Check-in",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],

          // --------------------------------------------------
          // TODAY'S SAVED CHECK-IN
          // --------------------------------------------------

          if (_todayCheckIn != null && !_editing) ...[
            const Text(
              "Today's Check-in",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep: ${_formatSleep(_todayCheckIn!.sleepMinutes)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Energy: ${_todayCheckIn!.energy}/5',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Mood: ${_todayCheckIn!.mood}/5',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Pain: ${_todayCheckIn!.pain}/10',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    if (_todayCheckIn!.note != null) ...[
                      const SizedBox(height: 8),

                      Text(
                        'Notes: ${_todayCheckIn!.note}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _editing = true;
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          "Edit Today's Check-in",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
