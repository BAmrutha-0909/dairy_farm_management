class Expense {
  DateTime date;
  String type;
  double amount;

  Expense({required this.date, required this.type, required this.amount});

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "type": type,
        "amount": amount,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        date: DateTime.parse(json["date"]),
        type: json["type"],
        amount: json["amount"],
      );
}
