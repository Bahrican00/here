class PostModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String location;
  final DateTime createdAt;
  final bool isBoosted;

  PostModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.location,
    required this.createdAt,
    this.isBoosted = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      isBoosted: json['isBoosted'] ?? false,
    );
  }
}