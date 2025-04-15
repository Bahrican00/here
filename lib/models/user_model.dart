enum AccountType { bronze, silver, gold, platinum }

class UserModel {
  final String id;
  final String username;
  final AccountType accountType;
  final String profilePhotoUrl;
  final int dailyPostLimit;
  final int dailyMatchRequestLimit;
  final List<String> posts;
  final List<String> matchRequestsSent;
  final List<String> matchRequestsReceived;
  final List<String> boosts;
  final List<String> superMessages;
  final int stars;
  final bool isProfileOnFire;

  UserModel({
    required this.id,
    required this.username,
    this.accountType = AccountType.bronze,
    this.profilePhotoUrl = '',
    this.dailyPostLimit = 3,
    this.dailyMatchRequestLimit = 10,
    this.posts = const [],
    this.matchRequestsSent = const [],
    this.matchRequestsReceived = const [],
    this.boosts = const [],
    this.superMessages = const [],
    this.stars = 0,
    this.isProfileOnFire = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      accountType: AccountType.values.firstWhere((e) => e.toString() == json['accountType']),
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      dailyPostLimit: json['dailyPostLimit'] ?? 3,
      dailyMatchRequestLimit: json['dailyMatchRequestLimit'] ?? 10,
      posts: List<String>.from(json['posts'] ?? []),
      matchRequestsSent: List<String>.from(json['matchRequestsSent'] ?? []),
      matchRequestsReceived: List<String>.from(json['matchRequestsReceived'] ?? []),
      boosts: List<String>.from(json['boosts'] ?? []),
      superMessages: List<String>.from(json['superMessages'] ?? []),
      stars: json['stars'] ?? 0,
      isProfileOnFire: json['isProfileOnFire'] ?? false,
    );
  }
}