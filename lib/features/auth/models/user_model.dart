class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int solvedChallengesCount;
  final int createdProjectsCount;
  final int currentStreakDays;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.solvedChallengesCount = 0,
    this.createdProjectsCount = 0,
    this.currentStreakDays = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'solvedChallengesCount': solvedChallengesCount,
        'createdProjectsCount': createdProjectsCount,
        'currentStreakDays': currentStreakDays,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        solvedChallengesCount: json['solvedChallengesCount'] as int? ?? 0,
        createdProjectsCount: json['createdProjectsCount'] as int? ?? 0,
        currentStreakDays: json['currentStreakDays'] as int? ?? 1,
      );
}
