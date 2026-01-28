class PriceCalculation {
  final int id;
  final String orangeType;
  final String orangeName;
  final double weightKg;
  final double pricePerKg;
  final double totalPrice;
  final DateTime date;

  PriceCalculation({
    required this.id,
    required this.orangeType,
    required this.orangeName,
    required this.weightKg,
    required this.pricePerKg,
    required this.totalPrice,
    required this.date,
  });

  // สร้าง PriceCalculation จาก JSON
  factory PriceCalculation.fromJson(Map<String, dynamic> json) {
    return PriceCalculation(
      id: json['id'],
      orangeType: json['orange_type'],
      orangeName: json['orange_name'] ?? '',
      weightKg: (json['weight_kg'] as num).toDouble(),
      pricePerKg: (json['price_per_kg'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  // แปลง PriceCalculation เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orange_type': orangeType,
      'orange_name': orangeName,
      'weight_kg': weightKg,
      'price_per_kg': pricePerKg,
      'total_price': totalPrice,
      'date': date.toIso8601String(),
    };
  }
}
