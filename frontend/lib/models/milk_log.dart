class MilkLog {
  final String animalId;
  final DateTime date;
  final double quantity;

  MilkLog({
    required this.animalId,
    required this.date,
    required this.quantity,
  });

  double get liters => quantity;

  Map<String, dynamic> toJson() => {
        "animal": animalId, // FIXED
        "date": date.toIso8601String(),
        "quantity": quantity,
      };

  factory MilkLog.fromJson(Map<String, dynamic> json) => MilkLog(
        animalId: json["animal"] ?? "",
        date: json["date"] != null
            ? DateTime.parse(json["date"])
            : DateTime.now(),
        quantity: (json["quantity"] ?? 0).toDouble(),
      );
}