class Sale {
  final String buffaloId; // NEW
  final DateTime date;
  final double amount;
  final double milkSold;

  Sale({
    required this.buffaloId,
    required this.date,
    required this.amount,
    required this.milkSold,
  });

  double get litersSold => milkSold;

  double get pricePerLiter => milkSold != 0 ? (amount / milkSold) : 0;

  Map<String, dynamic> toJson() => {
        "buffaloId": buffaloId,
        "date": date.toIso8601String(),
        "amount": amount,
        "milkSold": milkSold,
      };

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        buffaloId: json["buffaloId"],
        date: DateTime.parse(json["date"]),
        amount: json["amount"].toDouble(),
        milkSold: json["milkSold"].toDouble(),
      );
}