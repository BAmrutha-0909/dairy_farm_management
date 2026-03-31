class Animal {
  final String id;
  final String name;
  final double dailyMilk;
  final DateTime? purchaseDate;
  final double? purchasePrice;

  Animal({
    required this.id,
    required this.name,
    required this.dailyMilk,
    this.purchaseDate,
    this.purchasePrice,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        id: json['id'],
        name: json['name'],
        dailyMilk: (json['dailyMilk'] ?? 0).toDouble(), // ✅ FIX
        purchaseDate: json['purchaseDate'] != null
            ? DateTime.parse(json['purchaseDate'])
            : null,
        purchasePrice: json['purchasePrice'] != null
            ? (json['purchasePrice']).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dailyMilk': dailyMilk, // ✅ FIX
        'purchaseDate': purchaseDate?.toIso8601String(),
        'purchasePrice': purchasePrice,
      };


  Animal copyWith({
    String? id,
    String? name,
    double? dailyMilk,
    DateTime? purchaseDate,
    double? purchasePrice,
  }) {
    return Animal(
      id: id ?? this.id,
      name: name ?? this.name,
      dailyMilk: dailyMilk ?? this.dailyMilk,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
    );
  }
}
