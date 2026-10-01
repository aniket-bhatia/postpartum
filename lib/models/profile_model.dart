class Profile {
  final String firebaseUid;
  final String name;
  final String email;
  final String? babyName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.firebaseUid,
    required this.name,
    required this.email,
    this.babyName,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'firebase_uid': firebaseUid,
      'name': name,
      'email': email,
      'baby_name': babyName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      firebaseUid: map['firebase_uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      babyName: map['baby_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}