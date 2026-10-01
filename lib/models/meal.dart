class Meal {
  final int? id;
  final DateTime time;
  final String mealType;
  final String food;
  final String? quantity;

  Meal({
    this.id,
    required this.time,
    required this.mealType,
    required this.food,
    this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.millisecondsSinceEpoch,
      'meal_type': mealType,
      'food': food,
      'quantity': quantity,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int?,
      time: DateTime.fromMillisecondsSinceEpoch(
        map['time'] as int,
      ),
      mealType: map['meal_type'] as String,
      food: map['food'] as String,
      quantity: map['quantity'] as String?,
    );
  }
}