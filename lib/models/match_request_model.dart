class MatchRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;

  MatchRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.message = '',
    required this.createdAt,
  });

  factory MatchRequestModel.fromJson(Map<String, dynamic> json) {
    return MatchRequestModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}