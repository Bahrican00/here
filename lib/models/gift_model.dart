enum GiftType { rose, heart, crown }

class GiftModel {
  final String id;
  final GiftType type;
  final double price;
  final int quantity;

  GiftModel({
    required this.id,
    required this.type,
    required this.price,
    this.quantity = 1,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'],
      type: GiftType.values.firstWhere((e) => e.toString() == json['type']),
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}